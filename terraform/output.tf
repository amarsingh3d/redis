output "EC2_Public_IP" {
  value = aws_instance.this[*].public_ip

}