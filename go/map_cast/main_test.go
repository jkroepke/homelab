package main

import (
	"encoding/json"
	"testing"

	jsoniter "github.com/json-iterator/go"
	"github.com/stretchr/testify/require"
	"github.com/trivago/tgo/tcontainer"
)

var (
	expectedJson = []byte(`{"customfield_10001":{"value":"green", "child":{"value":"blue"} },"customfield_10002":"2011-10-03","customfield_10003":"2011-10-19T10:29:29.908+1100","customfield_10004":"Free text goes here.  Type away!","customfield_10005":{ "name":"jira-developers" },"customfield_10007":[{ "name":"admins" }, { "name":"jira-developers" }, { "name":"jira-users" }],"customfield_10008":[ {"value":"red" }, {"value":"blue" }, {"value":"green" }],"customfield_10009":[ {"name":"charlie" }, {"name":"bjones" }, {"name":"tdurden" }],"customfield_10010":42.07,"customfield_10011":{ "key":"JRADEV" },"customfield_10012":{ "value":"red" },"customfield_10013":{ "value":"red" },"customfield_10014":{ "name":"5.0" },"customfield_10015":"Is anything better than text?","customfield_10016":"http://www.atlassian.com","customfield_10017":{ "name":"brollins" },"customfield_10018":[{ "name":"1.0" }, { "name":"1.1.1" }, { "name":"2.0" }],"customfield_10019":[24],"timetracking":{"originalEstimate":"1d 2h","remainingEstimate":"3h 25m"}}`)
	jiraFieldMap = map[string]any{
		"customfield_10001": map[any]any{
			"value": "green",
			"child": map[any]any{
				"value": "blue",
			},
		},
		"customfield_10002": "2011-10-03",
		"customfield_10003": "2011-10-19T10:29:29.908+1100",
		"customfield_10004": "Free text goes here.  Type away!",
		"customfield_10005": map[any]any{
			"name": "jira-developers",
		},
		"customfield_10007": []map[any]any{
			{"name": "admins"}, {"name": "jira-developers"}, {"name": "jira-users"},
		},
		"customfield_10008": []map[any]any{
			{"value": "red"}, {"value": "blue"}, {"value": "green"},
		},
		"customfield_10009": []map[any]any{
			{"name": "charlie"}, {"name": "bjones"}, {"name": "tdurden"},
		},
		"customfield_10010": 42.07,
		"customfield_10011": map[any]any{
			"key": "JRADEV",
		},
		"customfield_10012": map[any]any{
			"value": "red",
		},
		"customfield_10013": map[any]any{
			"value": "red",
		},
		"customfield_10014": map[any]any{
			"name": "5.0",
		},
		"customfield_10015": "Is anything better than text?",
		"customfield_10016": "http://www.atlassian.com",
		"customfield_10017": map[any]any{
			"name": "brollins",
		},
		"customfield_10018": []map[any]any{
			{"name": "1.0"}, {"name": "1.1.1"}, {"name": "2.0"},
		},
		"customfield_10019": []any{
			24,
		},
		"timetracking": map[any]any{
			"originalEstimate": "1d 2h", "remainingEstimate": "3h 25m",
		},
	}
)

func TestJsonStdlib(t *testing.T) {
	fieldJSON, err := json.Marshal(jiraFieldMap)

	require.NoError(t, err)
	require.JSONEq(t, string(expectedJson), string(fieldJSON))
}

func TestJsonStdlibWithTcontainer(t *testing.T) {
	jiraFieldMapWithStringKeys, err := tcontainer.ConvertToMarshalMap(jiraFieldMap, func(v string) string { return v })
	fieldJSON, err := json.Marshal(jiraFieldMapWithStringKeys)

	require.NoError(t, err)
	require.JSONEq(t, string(expectedJson), string(fieldJSON))
}

func TestJsonStdlibWithJsoniter(t *testing.T) {
	fieldJSON, err := jsoniter.Marshal(jiraFieldMap)

	require.NoError(t, err)
	require.JSONEq(t, string(expectedJson), string(fieldJSON))
}
