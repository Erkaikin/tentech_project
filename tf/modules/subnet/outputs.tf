output "sub_id" {
    value = aws_subnet.public_subnet.*.id
}

output "cidr_block" {
  value = aws_subnet.public_subnet.*.cidr_block
}
