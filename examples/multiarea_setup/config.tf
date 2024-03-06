locals {
  config                 = yamldecode(file("data/config.yaml"))
  wh_terraform           = local.config.wh_terraform

}