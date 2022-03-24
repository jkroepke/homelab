resource "aws_resourcegroups_group" "test" {
  name = var.name

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [{
        Key = "project"
        Values = [var.name]
      }]
    })

    type = "TAG_FILTERS_1_0"
  }
}
