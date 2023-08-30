locals {
  wh_terraform         = "TERRAFORM_WH"
  config_sandbox_layer = yamldecode(file("../../data/sandbox_layer.yaml"))
}