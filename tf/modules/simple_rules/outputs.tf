/*output "rule_id" {
  value = aws_security_group_rule.rule.*.id
}
*/


output "id" {
  value = aws_security_group_rule.rule.id
}