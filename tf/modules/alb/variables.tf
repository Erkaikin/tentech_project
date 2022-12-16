/*variable "name" {

}
variable "security_group" {

}
variable "subnet_id" {

}

variable "my_target_group_arn" {

}
*/

variable "name" {
  description = "(Optional) The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
}

variable "load_balancer_type" {
  description = "(Optional) The type of load balancer to create. Possible values are application or network. The default value is application."
  default     = "application"
}

variable "internal" {
  description = "(Optional) If true, the LB will be internal."
  default     = false
}

variable "security_groups" {
  description = "(Optional) A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application."
  default     = []
}

variable "subnets" {
  description = "(Optional) A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network. Changing this value for load balancers of type network will force a recreation of the resource."
  default     = []
}

variable "idle_timeout" {
  description = "(Optional) The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60."
  default     = "60"
}

variable "enable_deletion_protection" {
  description = "(Optional) If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "(Optional) If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to false."
  default     = false
}

variable "enable_http2" {
  description = "(Optional) Indicates whether HTTP/2 is enabled in application load balancers. Defaults to true."
  default     = true
}

variable "ip_address_type" {
  description = "(Optional) The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  default     = "ipv4"
}

variable "bucket" {
  description = "(Required) The S3 bucket name to store the logs in."
  default     = "testalbs3"
}

variable "enabled" {
  description = "(Optional) Boolean to enable / disable access_logs. Defaults to false, even when bucket is specified."
  default     = false
}

variable "lb_create_timeout" {
  description = "(Default 10 minutes) Used for Creating LB."
  default     = "10m"
}

variable "lb_update_timeout" {
  description = "(Default 10 minutes) Used for LB modifications."
  default     = "10m"
}

variable "lb_delete_timeout" {
  description = "(Default 10 minutes) Used for destorying LB."
  default     = "10m"
}


variable "load_balancer_arn" {
  description = "(Required, Forces New Resource) The ARN of the load balancer."
}
/*
variable "port" {
  description = "(Required) The port on which the load balancer is listening."
  default     = "80"
}

variable "protocol" {
  description = "(Optional) The protocol for connections from clients to the load balancer. Valid values are TCP, TLS, UDP, TCP_UDP, HTTP and HTTPS. Defaults to HTTP."
  default     = "HTTP"
}
*/
#variable "type" {
  #description = "(Required) The type of routing action. Valid values are forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc."
  ##default     = "forward"
#}

variable "target_group_arn" {
  description = "(Optional) The ARN of the Target Group to which to route traffic. Required if type is forward."
  default     = "forward"
}
