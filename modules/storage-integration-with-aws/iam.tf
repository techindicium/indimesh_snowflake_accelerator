resource "aws_iam_role" "this" {
  name = var.storage_integration_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
      },
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          AWS = snowflake_storage_integration.this.storage_aws_iam_user_arn
        },
        Condition = {
          StringEquals = {
            "sts:ExternalId" = snowflake_storage_integration.this.storage_aws_external_id
          }
        }
      }
    ],
  })
}

resource "aws_iam_policy" "this" {
  name        = var.storage_integration_policy_name
  description = "${var.storage_integration_name} - Policy for Snowflake storage integration"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetObjectVersion",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:GetBucketLocation"
        ],
        Effect = "Allow",
        Resource = [
          "${data.terraform_remote_state.this.outputs.s3_bucket_arn}",
          "${data.terraform_remote_state.this.outputs.s3_bucket_arn}/*"
        ],
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
