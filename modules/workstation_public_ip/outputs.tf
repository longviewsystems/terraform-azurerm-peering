output "result" {
  value       = local.my_public_ip.ip_addr
  description = "Workstation public IP address"
}