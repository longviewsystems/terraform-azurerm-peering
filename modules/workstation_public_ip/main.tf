data "http" "my_public_ip" {
  url = "https://ifconfig.me/all.json"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  my_public_ip = jsondecode(data.http.my_public_ip.body)
}