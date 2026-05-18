output "public_ip" {
  description = "Public IP of Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.jenkins_server.id
}
