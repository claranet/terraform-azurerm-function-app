data "http" "myip" {
  url = "http://ip4.clara.net"
}

locals {
  my_ip = trimspace(data.http.myip.body)
}

output "my_ip" {
  description = "Current IPv4"
  value       = "${local.my_ip}/32"
}
