output "vpc_id" {
  description = "ID of the vpc"
  value       = module.vpc.vpc_id
}
 
output "instance_id" {
  description = "ID of EC2 instance"
  value       = module.ec2.instance_id
}
 
output "instance_public_ip1" {
   description = "Public IP of EC2 instance"
   value       = module.ec2.instance_public_ip[0]


}
output "instance_public_ip2" {
   description = "Public IP of EC2 instance"
   value       = module.ec2.instance_public_ip[1]


}

output "rds_endpoint" {
    value = module.rds.address
  
}