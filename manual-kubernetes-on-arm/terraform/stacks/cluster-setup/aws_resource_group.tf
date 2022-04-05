resource "aws_resourcegroups_group" "test" {
  name = var.project_name

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [{
        Key    = "project"
        Values = [var.project_name]
      }]
    })

    type = "TAG_FILTERS_1_0"
  }
}
