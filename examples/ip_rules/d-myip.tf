data "http" "myip" {
  url = "http://ip4.clara.net"
}

output "my_ip" {
  description = "Current IPv4"
  value       = "${data.http.myip.body}/32"
}
