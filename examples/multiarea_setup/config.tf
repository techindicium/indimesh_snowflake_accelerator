locals {
  wh_terraform           = "TERRAFORM_WH"
  config                 = yamldecode(file("data/config.yaml"))
}