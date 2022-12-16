resource "aws_lb_target_group_attachment" "tg_gr_attchment" {
  target_group_arn = var.target_group_arn
  count            = 2
  target_id        = var.target_id[count.index]
  port             =  80
}