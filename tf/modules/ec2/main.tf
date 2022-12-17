data "aws_ami" "amzLinux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
}


# create ssh key:
resource "aws_key_pair" "ssh_key" {
  key_name   = "project_ssh_key"
  public_key = sensitive(file("~/.ssh/id_rsa.pub"))
}



resource "aws_instance" "ec2" {
  count                  = length(var.subnet_id)
  ami                    = data.aws_ami.amzLinux.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id[count.index]
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = var.vpc_security_group_id

/*
  user_data = <<EOF
   #!/bin/bash
yum update -y
yum install httpd -y 
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF

*/

  tags = {
    Name = "project_ec2_${count.index + 1}"
  }

  depends_on = [
    aws_key_pair.ssh_key
  ]
}
