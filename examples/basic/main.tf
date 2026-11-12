module "public_ip" {
  source = "../../"

  object_name       = "web-public-ip"
  availability_zone = "S1"
}
