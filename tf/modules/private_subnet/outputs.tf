output "pr_sub_id" {
    value = aws_subnet.private_subnet.*.id
}