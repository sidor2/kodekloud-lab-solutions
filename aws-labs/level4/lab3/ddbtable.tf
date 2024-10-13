resource "aws_dynamodb_table" "kodek_ddb_table" {
    name           = "${var.project_name}-S3CopyLogs"
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "LogID"

    attribute {
        name = "LogID"
        type = "S"
    }

    tags = {
        Name = "devops-S3CopyLogs"
    }
}