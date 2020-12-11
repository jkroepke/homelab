resource "aws_resourcegroups_group" "resource_group" {
  name = var.name

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "project",
      "Values": ["${var.name}"]
    }
  ]
}
JSON
  }
}
