resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id
}

resource "aws_route" "r" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = var.gateway_id
}