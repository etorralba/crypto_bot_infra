output "private_key_pem" {
  description = "The private key in PEM format"
  value       = tls_private_key.admin.private_key_pem
  sensitive   = true
}

output "instance_public_dns" {
  description = "The public DNS of the instance"
  value       = aws_instance.main.public_dns
}

output "instance_public_ip" {
  description = "The public IP of the instance"
  value       = aws_instance.main.public_ip
}