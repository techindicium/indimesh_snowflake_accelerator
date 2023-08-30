locals {
  wh_terraform = "TERRAFORM_WH"
  config_mds_layer = yamldecode(file("../../data/dbt_layer.yaml"))
}