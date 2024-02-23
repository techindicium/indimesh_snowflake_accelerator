locals {
  wh_terraform           = "TRAINING_WAREHOUSE" # COLOCAR COMO VARIAVEL ESSE AQUI 
  config                 = yamldecode(file("data/config.yaml"))
}