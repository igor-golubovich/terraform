region        = "us-east-1"
instance_type = "t2.small"

ingress_ports = ["80", "22", "666"]

common_tags = {
  Owner      = "goood"
  Project    = "type_z"
  CostCenter = "12345"
  Enviroment = "shere"
}
