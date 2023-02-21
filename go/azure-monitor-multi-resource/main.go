package main

import (
	"context"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/policy"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/monitor/armmonitor"
	"log"
)

func main() {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		log.Fatalf("failed to obtain a credential: %v", err)
	}
	ctx := context.Background()
	client, err := armmonitor.NewMetricsClient(cred, &arm.ClientOptions{ClientOptions: policy.ClientOptions{
		APIVersion: "2021-05-01",
	}})

	res, err := client.List(ctx, "subscriptions/e1608e24-0728-4efd-ba5b-a05693b53c5a", &armmonitor.MetricsClientListOptions{
		Timespan:        to.Ptr("PT1M"),
		Interval:        to.Ptr("PT1M"),
		Metricnames:     to.Ptr("Available Memory Bytes"),
		Aggregation:     to.Ptr("average"),
		Top:             to.Ptr(int32(10)),
		Orderby:         nil,
		Filter:          to.Ptr("Microsoft.ResourceId eq '/subscriptions/e1608e24-0728-4efd-ba5b-a05693b53c5a/resourceGroups/default/providers/Microsoft.Compute/virtualMachines/bastion-win' or Microsoft.ResourceId eq '/subscriptions/e1608e24-0728-4efd-ba5b-a05693b53c5a/resourceGroups/default/providers/Microsoft.Compute/virtualMachines/bastion-linux'"),
		ResultType:      nil,
		Metricnamespace: to.Ptr("microsoft.compute/virtualmachines"),
	})

	if err != nil {
		log.Fatalf("failed to finish the request: %v", err)
	}
	// TODO: use response item
	_ = res
}
