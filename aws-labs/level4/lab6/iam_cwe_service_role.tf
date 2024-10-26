resource "aws_iam_role" "cwe_service_role" {
    name = "${var.proj_name}-cwe_service_role"
    assume_role_policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "events.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    })
}

resource "aws_iam_policy" "cwe_policy" {
  name        = "${var.proj_name}-cwe_policy"
  description = "${var.proj_name} Allows Amazon CloudWatch Events to automatically start a new execution in the xfusion-pipeline pipeline when a change occurs"
  policy      = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "codepipeline:StartPipelineExecution"
          ],
          "Resource": "arn:aws:codepipeline:${var.region}:${var.account_id}:${var.proj_name}-pipeline"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "cwe_policy_attachment" {
  role       = aws_iam_role.cwe_service_role.name
  policy_arn = aws_iam_policy.cwe_policy.arn
}

