output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.nginx_server.public_dns
}

output "dynatrace_host_url" {
  description = "Dynatrace host page URL"
  value = "https://${replace(var.dynatrace_tenant, "https://", "")}/#hosts/otmk/hostDetails;hostId=${aws_instance.nginx_server.id}"
}

