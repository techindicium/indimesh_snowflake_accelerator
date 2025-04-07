data "terraform_remote_state" "this" {
  backend = "s3"
  config = {
    bucket = var.tf_state_s3_bucket_name
    region = var.region
    key    = "terraformstate/aws_datalake/state"
  }
}
