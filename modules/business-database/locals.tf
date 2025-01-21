locals {
  schemas = length(var.schemas) > 0 ? var.schemas : ["PUBLIC"]
}
