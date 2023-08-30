locals {
  wh_terraform = "TERRAFORM_WH"
  raw_layer    = yamldecode(file("../../data/raw_layer.yaml"))
}