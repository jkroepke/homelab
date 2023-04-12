package main

import (
	"bytes"
	"context"
	"encoding/json"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/costmanagement/armcostmanagement"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/clientcredentials"
	"golang.org/x/oauth2/microsoft"
	"log"
	"net/http"
	"net/url"
	"os"
	"time"
)

func main() {
	// define query
	// import "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/costmanagement/armcostmanagement"
	query := armcostmanagement.QueryDefinition{
		Type:      to.Ptr(armcostmanagement.ExportTypeUsage),
		Timeframe: to.Ptr(armcostmanagement.TimeframeTypeCustom),
		TimePeriod: &armcostmanagement.QueryTimePeriod{
			From: to.Ptr(time.Now().Add(time.Hour * 24 * 30 * -1)),
			To:   to.Ptr(time.Now()),
		},
		Dataset: &armcostmanagement.QueryDataset{
			Granularity: to.Ptr(armcostmanagement.GranularityType("Daily")),
			Aggregation: map[string]*armcostmanagement.QueryAggregation{
				"totalCost": {
					Name:     to.Ptr("PreTaxCost"),
					Function: to.Ptr(armcostmanagement.FunctionTypeSum),
				},
			},
			Grouping: []*armcostmanagement.QueryGrouping{{
				Type: to.Ptr(armcostmanagement.QueryColumnTypeDimension),
				Name: to.Ptr("ResourceId"),
			}},
		},
	}

	// stringify query
	body, err := json.MarshalIndent(query, "", "  ")
	if err != nil {
		log.Panic(err)
	}

	// create http client
	endpoint := microsoft.AzureADEndpoint("9c1de352-64a4-4509-b3fc-4ef2df8db9b8") // from "golang.org/x/oauth2/microsoft"
	endpoint.AuthStyle = oauth2.AuthStyleInParams
	var azureConfig = &clientcredentials.Config{
		ClientID:     os.Getenv("AZURE_CLIENT_ID"),
		ClientSecret: os.Getenv("AZURE_CLIENT_SECRET"),
		Scopes:       []string{"https://management.azure.com/.default"},
		TokenURL:     endpoint.TokenURL,
		AuthStyle:    oauth2.AuthStyleInParams,
	}
	client := azureConfig.Client(context.Background())

	scope := "/subscriptions/" + os.Getenv("AZURE_SUBSCRIPTION_ID")

	res := armcostmanagement.QueryProperties{
		NextLink: to.Ptr("https://management.azure.com" + scope + "/providers/Microsoft.CostManagement/query?api-version=2021-10-01&$top=100"),
		Columns:  nil,
		Rows:     [][]interface{}{},
	}

	// pull the data
	for res.NextLink != nil && *res.NextLink != "" {
		log.Println(*res.NextLink)
		host, err := url.ParseRequestURI(*res.NextLink)
		// TODO: error handling
		request, err := http.NewRequest(http.MethodPost, host.String(), bytes.NewBuffer(body))
		// TODO: error handling
		request.Header.Set("Content-Type", "application/json")
		nextPage, err := client.Do(request)
		// TODO: error handling

		decoder := json.NewDecoder(nextPage.Body)
		data := &armcostmanagement.QueryClientUsageResponse{}
		if err = decoder.Decode(data); err != nil {
			log.Panic(err)
		}
		res.Columns = data.Properties.Columns
		res.NextLink = data.Properties.NextLink
		res.Rows = append(res.Rows, data.Properties.Rows...) // at the end you have all rows inside this struct
	}

	for _, row := range res.Rows {

		log.Printf("%v\n", row)
	}
	log.Println(len(res.Rows))
}
