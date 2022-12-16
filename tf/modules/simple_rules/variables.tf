/*variable "rules" {
  type = map(any)
  default = {
    "" = ["", "", "", "", "", ""]
  }
}

variable "security_group_id" {

}
*/

variable "type" {
}

variable "cidr_blocks" {
  default = ""
}

variable "from_port" {

}

variable "to_port" {

}

variable "protocol" {

}

variable "description" {

}

variable "security_group_id" {
}