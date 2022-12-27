output "instance_id" {
  value = aws_instance.ec2.*.id
}

output "instance_public_ip" {
   description = "Public IP of EC2 instance"
   value       = try(aws_instance.ec2.*.public_ip, "")
}