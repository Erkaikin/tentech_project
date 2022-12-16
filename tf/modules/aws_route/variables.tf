variable "vpc_id" {
  description = "(Required) The ID of the VPC whose main route table should be set."
}


variable "destination_cidr_block" {
  description = "(Optional) The destination CIDR block."
  default     = "0.0.0.0/0"
}

variable "gateway_id" {
  description = "(Optional) Identifier of a VPC internet gateway or a virtual private gateway."
  default     = ""
}
