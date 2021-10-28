data "http" "myip" {
  url = "http://ip.clara.net"
}

output "my_ip" {
  value = "${data.http.myip.body}/32"
}
