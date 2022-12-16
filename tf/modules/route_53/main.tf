/*# lookup route53 hosted zones:
data "aws_route53_zone" "hosted_zone" {
  name         = "erkai-tentech.com"
  private_zone = false
}

# create route53 cname record to map to alb dns name:
resource "aws_route53_record" "my_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = "100"
  records = var.alb_dns_name
}
*/


resource "aws_route53_record" "erkai_record" {
  zone_id = var.zone_id
  name    = var.dns_name
  type    = var.type
  ttl     = var.ttl
  records = [var.lb_dns_name]
}