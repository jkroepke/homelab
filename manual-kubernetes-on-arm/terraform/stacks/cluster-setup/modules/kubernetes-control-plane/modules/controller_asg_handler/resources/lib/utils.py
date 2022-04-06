from typing import Optional

from botocore import exceptions

import logging
import time
import boto3

autoscaling = boto3.client('autoscaling')
route53 = boto3.client('route53')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

EBS_DEVICE = '/dev/xvdf'

EVENT_LAUNCH = 'launch'
EVENT_TERMINATE = 'terminate'
EVENT_MAP = {
    "EC2 Instance-launch Lifecycle Action": EVENT_LAUNCH,
    "EC2 Instance-terminate Lifecycle Action": EVENT_TERMINATE,
}


def complete_lifecycle_action(event: dict) -> None:
    response = None
    try:
        response = autoscaling.complete_lifecycle_action(
            AutoScalingGroupName=event['detail']['AutoScalingGroupName'],
            InstanceId=event['detail']['EC2InstanceId'],
            LifecycleHookName=event['detail']['LifecycleHookName'],
            LifecycleActionToken=event['detail']['LifecycleActionToken'],
            LifecycleActionResult='CONTINUE'
        )
        logger.info("[ASG] ASG action complete: %s", response)
    except exceptions.ClientError as error:
        logger.error("[ASG] ASG heartbeat failed: %s", str(error))
        raise error
    except Exception as error:
        if response is not None:
            logger.error(response)
        raise error


# EBS START ##################################################

def attach_ebs_volume(instance, volume) -> None:
    wait_until_volume_is_available(volume)
    logger.info("[EC2] Volume '%s' is in state '%s'.", volume.volume_id, volume.state)

    try:
        instance.wait_until_running()
        volume.attach_to_instance(
            Device=EBS_DEVICE,
            InstanceId=instance.instance_id,
        )
        logger.info("[EC2] Volume attachment '%s' on '%s' triggered", instance.instance_id, volume.volume_id)
    except Exception as error:
        logger.error("[EC2] Volume attachment '%s' on '%s' failed: %s", instance.instance_id, volume.volume_id, str(error))
        raise error


def detach_ebs_volume(instance, volume) -> None:
    if volume.state != 'in-use':
        logger.info("[EC2] Volume '%s' is in state '%s'.", volume.volume_id, volume.state)
        return

    if instance.instance_id != volume.attachments[0]['InstanceId']:
        logger.info("[EC2] Volume '%s' is attached on different instance. Actual: '%s'. Excepted: '%s'.",
                    volume.volume_id, instance.instance_id, volume.attachments[0]['InstanceId'])
        return

    try:
        volume.detach_from_instance(
            Device=EBS_DEVICE,
            InstanceId=instance.instance_id,
        )
        logger.info("[EC2] Volume detachment '%s' on '%s' triggered", instance.instance_id, volume.volume_id)
    except exceptions.ClientError as error:
        logger.error("[EC2] Volume detachment '%s' on '%s' failed: %s", instance.instance_id, volume.volume_id, str(error))
        raise error


def wait_until_volume_is_available(volume) -> None:
    if volume.state == 'in-use':
        logger.info("[EC2] Volume is attached on '%s'. Detaching...", volume.attachments[0]['InstanceId'])
        volume.detach_from_instance(
            Device='/dev/xvdf',
            InstanceId=volume.attachments[0]['InstanceId'],
        )

    while True:
        if volume.state == 'available':
            return

        logger.info("[EC2] Volume is in state '%s'. Waiting...", volume.state)
        time.sleep(2)
        volume.reload()


# EC2 START ##################################################


def get_tags_from_ec2_instance(instance) -> tuple[str, str, str]:
    etcd_peer_name = get_tag_from_ec2_instance(instance, 'etcd_peer_name')
    etcd_route53_zone_id = get_tag_from_ec2_instance(instance, 'etcd_route53_zone_id')
    etcd_volume_id = get_tag_from_ec2_instance(instance, 'etcd_volume_id')

    return etcd_route53_zone_id, etcd_peer_name, etcd_volume_id


def get_tag_from_ec2_instance(instance, key):
    for tags in instance.tags:
        if tags["Key"] == key:
            return tags["Value"]

    raise ValueError("Missing tag '%s' on instance '%s'." % (key, instance.instance_id))


def get_ip_address_from_ec2_instance(instance) -> str:
    # Wait until PrivateIpAddress is assigned
    try:
        while True:
            logger.info("[EC2] Fetching IP for instance-id '%s'", instance.instance_id)
            instance.load()

            if instance.private_ip_address:
                break

            time.sleep(0.25)

        ip_address = instance.private_ip_address
        logger.info("[EC2] Found private IP for instance-id '%s': %s", instance.instance_id, ip_address)

        return ip_address
    except Exception as error:
        logger.error("[EC2] Error while describe instance-id '%s': %s", instance.instance_id, str(error))
        raise error


# ROUTE53 START ##################################################


def route53_change_record(action: str, zone_id: str, record_name: str, value: str) -> None:
    logger.info("[Route 53] Changing record with %s for %s -> %s in %s", action, record_name, value, zone_id)
    response = None
    try:
        response = route53.change_resource_record_sets(
            HostedZoneId=zone_id,
            ChangeBatch={
                'Changes': [
                    {
                        'Action': action,
                        'ResourceRecordSet': {
                            'Name': record_name,
                            'Type': 'A',
                            'TTL': 60,
                            'ResourceRecords': [{'Value': value}]
                        }
                    }
                ]
            }
        )
    except exceptions.ClientError as error:
        logger.error("[Route 53] Changing record with %s for %s -> %s in %s failed: %s", action, record_name, value, zone_id, str(error))
        raise error
    except Exception as error:
        if response is not None:
            logger.error(response)
        raise error


def get_ip_address_from_route53(zone_id: str, record_name: str) -> Optional[str]:
    response = None
    try:
        response = route53.list_resource_record_sets(HostedZoneId=zone_id, StartRecordName=record_name, MaxItems='1')

        if not response['ResourceRecordSets'] or record_name not in response['ResourceRecordSets'][0]['Name']:
            return None

        ip_address = response['ResourceRecordSets'][0]['ResourceRecords'][0]['Value']
        logger.info("[Route 53] Found IP for record '%s': %s", response['ResourceRecordSets'][0]['Name'], ip_address)
        return ip_address
    except exceptions.ClientError as error:
        logger.error("[Route 53] List records in zone '%s' failed: %s", zone_id, str(error))
        raise error
    except Exception as error:
        if response is not None:
            logger.error(response)
        raise error
