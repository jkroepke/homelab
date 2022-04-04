import json
import logging
import sys
import boto3
from lib import utils

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.resource('ec2')


def lambda_handler(event, context) -> None:
    logger.info('[Main] LogAutoScalingEvent: %s', json.dumps(event))

    instance_id = event['detail']['EC2InstanceId']
    event_type = utils.EVENT_MAP[event['detail-type']]

    instance = ec2.Instance(instance_id)
    etcd_route53_zone_id, etcd_peer_name, etcd_volume_id = utils.get_tags_from_ec2_instance(instance)

    configure_route53_record(event_type, instance, etcd_route53_zone_id, etcd_peer_name)
    configure_volume_attachment(event_type, instance, etcd_volume_id)

    if context is not None:
        utils.complete_lifecycle_action(event)

    logger.info("[Main] Finishing ASG action")


def configure_route53_record(event_type: str, instance, etcd_route53_zone_id: str, etcd_peer_name: str) -> None:
    if event_type == utils.EVENT_LAUNCH:
        ip_address = utils.get_ip_address_from_route53(etcd_route53_zone_id, etcd_peer_name)
        if ip_address is not None:
            logger.warning("[Route 53] Founded staled record '%s': '%s'", etcd_peer_name, ip_address)
            utils.route53_change_record('DELETE', etcd_route53_zone_id, etcd_peer_name, ip_address)

        action = 'CREATE'
        ip_address = utils.get_ip_address_from_ec2_instance(instance)
    else:
        action = 'DELETE'
        ip_address = utils.get_ip_address_from_route53(etcd_route53_zone_id, etcd_peer_name)
        if ip_address is None:
            logger.info("[Route 53] Record '%s' not found. Continue.", etcd_peer_name)
            return

    utils.route53_change_record(action, etcd_route53_zone_id, etcd_peer_name, ip_address)


def configure_volume_attachment(event_type: str, instance, volume_id: str) -> None:
    volume = ec2.Volume(volume_id)

    if event_type == utils.EVENT_LAUNCH:
        utils.attach_ebs_volume(instance, volume)
    else:
        utils.detach_ebs_volume(instance, volume)


# if invoked manually, assume someone pipes in an event json
if __name__ == "__main__":
    logging.basicConfig()

    lambda_handler(json.load(sys.stdin), None)
