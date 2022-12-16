/*resource "aws_security_group_rule" "rule" {
  count             = length(var.rules)
  type              = element(var.rules[count.index], 0)
  cidr_blocks       = [element(var.rules[count.index], 1)]
  from_port         = element(var.rules[count.index], 2)
  to_port           = element(var.rules[count.index], 3)
  protocol          = element(var.rules[count.index], 4)
  description       = element(var.rules[count.index], 5)
  security_group_id = var.security_group_id
}
*/

resource "aws_security_group_rule" "rule" {
  type                     = var.type
  cidr_blocks              = var.cidr_blocks
  from_port                = var.from_port
  to_port                  = var.to_port
  protocol                 = var.protocol
  description              = var.description
  security_group_id        = var.security_group_id
}
