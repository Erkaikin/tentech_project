/*output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
output "alb_arn" {
 value = aws_lb.alb.arn
}
*/

output "id" {
  value = aws_lb.lb.id
}

output "arn" {
  value = aws_lb.lb.arn
}

output "alb_dns" {
  value = aws_lb.lb.dns_name
}

