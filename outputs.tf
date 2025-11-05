output "instance_public_ip" {
  value = aws_instance.instance_jewerly.public_ip
}

output "app_url" {
  value = "http://${aws_instance.instance_jewerly.public_ip}:8080"
}
