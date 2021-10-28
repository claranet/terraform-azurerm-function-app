data "http" "myip" {
  url = "http://ip.clara.net"
}

output "my_ip" {
  description = "Current IPv4"
  value       = "${data.http.myip.body}/32"
}
