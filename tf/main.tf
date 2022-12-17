# create vpc

module "vpc" {
    source = "./modules/vpc"
    cidr_block = "10.0.0.0/16"
    name = "vpc-project"
}


# create 2 public subnet

module "pub_sub" {
    source = "./modules/subnet"
    vpc_id = module.vpc.vpc_id
    cidr_block = ["10.0.0.0/18", "10.0.64.0/18"]
    

}

# create 2 private subnet

module "private_sub" {
    source = "./modules/private_subnet"
    vpc_id = module.vpc.vpc_id
    cidr_block = ["10.0.128.0/18", "10.0.192.0/18"]
    
}

# create igw:

module "igw" {
    source = "./modules/igw"
    vpc_id = module.vpc.vpc_id
    name = "igw-project"
}


# create nat gw:

 module "nat_gw" {
  source = "./modules/nat_gw" 
  subnet_id = module.pub_sub.sub_id[0]
  name = "nat_gw"
 }

 # create rtb for vpc and routes

module "route-table" {
  source = "./modules/aws_route"
  vpc_id = module.vpc.vpc_id
  gateway_id = module.igw.igw_id
}


 # create pub rtb:

 module "pub_rtb" {
    source = "./modules/route_table"
    vpc_id = module.vpc.vpc_id
    gateway_id = module.igw.igw_id
    nat_gateway_id = null
    subnet_ids = [module.pub_sub.sub_id[0], module.pub_sub.sub_id[1]]
 }


 # create private rtb:

 module "private_rtb" {
    source = "./modules/route_table"
    vpc_id = module.vpc.vpc_id
    gateway_id = null
    nat_gateway_id = module.nat_gw.nat_gw_id
    subnet_ids = [module.private_sub.pr_sub_id[0], module.private_sub.pr_sub_id[1]]
 }

 # create sg for ec2

 module "ec2_sg" {
    source = "./modules/sg"
    vpc_id = module.vpc.vpc_id
    name = "ec2_sg"
 }

# create sg for ALB

module "alb_sg" {
    source = "./modules/sg"
    vpc_id = module.vpc.vpc_id
    name = "alb_sg"
}


 # create rules for ec2_sg

 /*
 module "rules_for_sg" {
    source = "./modules/simple_rules"
    rules = {
    "0" = ["ingress", "0.0.0.0/0", "22", "22", "TCP", "allow ssh from www"]
    "1" = ["egress", "0.0.0.0/0", "0", "65535", "TCP", "allow outbound traffic to www"]
    
  }
  security_group_id = module.ec2_sg.sg_id
}
*/

module "ec2sg_ingress" {
  source = "./modules/simple_rules"
  type            =  "ingress"
  cidr_blocks     =   ["0.0.0.0/0"]
  from_port       =    "22"
  to_port         =    "22"
  protocol        =    "TCP"
  description       =  "allow ssh from www"
  security_group_id  =   module.ec2_sg.sg_id
}

module "ec2sg_egress" {
  source = "./modules/simple_rules"
  type         = "egress"
  cidr_blocks  = ["0.0.0.0/0"]
  from_port    =  "0"
  to_port      =  "65535"
  protocol     =  "TCP" 
  description =  "allow traffic to www"
  security_group_id = module.ec2_sg.sg_id
}

# create rules for alb

 /*
 module "rules_for_alb_sg" {
    source = "./modules/simple_rules"
    rules = {
    "0" = ["egress", "0.0.0.0/0", "0", "65535", "TCP", "allow outbound traffic to www"]
    "1" = ["ingress", "0.0.0.0/0", "80", "80", "TCP", "allow inbound traffic from www"]
  }
  security_group_id = module.alb_sg.sg_id
}
 */

module "albsg_ingress" {
  source = "./modules/simple_rules"
  type            =  "ingress"
  cidr_blocks     =   ["0.0.0.0/0"]
  from_port       =    "80"
  to_port         =    "80"
  protocol        =    "TCP"
  description       =  "allow traffic from www"
  security_group_id  =   module.alb_sg.sg_id
}


module "albsg_ingress_443" {
  source = "./modules/simple_rules"
  type            =  "ingress"
  cidr_blocks     =   ["0.0.0.0/0"]
  from_port       =    "443"
  to_port         =    "443"
  protocol        =    "TCP"
  description       =  "allow traffic from www"
  security_group_id  =   module.alb_sg.sg_id
}


module "albsg_egress" {
  source = "./modules/simple_rules"
  type         = "egress"
  cidr_blocks  = ["0.0.0.0/0"]
  from_port    =  "0"
  to_port      =  "65535"
  protocol     =  "TCP" 
  description =  "allow traffic to www"
  security_group_id = module.alb_sg.sg_id
}




# add ingress rules for EC2 sg to allow http traffic from ALB sg:


module "ec2_sg_ingress_from_alb" {
  source = "./modules/rules_with_id"
  type  = "ingress"
  rules = {
    "0" = [module.alb_sg.sg_id, "80", "80", "TCP", "allow http traffic from ALB"]
  }
  security_group_id = module.ec2_sg.sg_id
}

# create ec2

module "ec2" {
  source = "./modules/ec2"
  vpc_security_group_id = [module.ec2_sg.sg_id]
  subnet_id = [module.pub_sub.sub_id[0], module.pub_sub.sub_id[1]]



output "instance_public_ip" {
   description = "Public IP of EC2 instance"
   value       = module.ec2.instance_id
}
}

# create target group and attach to ec2s

module "tg_gr" {
  source = "./modules/target_group"
  name = "target-group"
  vpc_id = module.vpc.vpc_id

}

# tg gr attachment

module "tg_attachment" {
  source = "./modules/target_gr_attachment"
  target_group_arn = module.tg_gr.tg_arn
  target_id = module.ec2.instance_id[*]

}


# create alb 
/*
module "alb" {
  source = "./modules/alb"
  name = "alb-project"
  security_group = [module.alb_sg.sg_id]
  subnet_id =  [module.pub_sub.sub_id[0], module.pub_sub.sub_id[1]]
  my_target_group_arn = module.tg_gr.tg_arn
}
*/

module "alb" {
  source          = "./modules/alb"
  name            = "projectALB"
  subnets         = [module.pub_sub.sub_id[0], module.pub_sub.sub_id[1]]
  security_groups = [module.alb_sg.sg_id]
  load_balancer_arn = module.alb.arn
  target_group_arn  = module.tg_gr.tg_arn
}


#create db subnet group

module "db_sub_gr" {
  source = "./modules/subnet_group"
  subnet_id = [module.private_sub.pr_sub_id[0], module.private_sub.pr_sub_id[1]]

}

# create sg for rds

module "rds_sg" {
  source = "./modules/sg"
  name = "rds_sg"
  vpc_id = module.vpc.vpc_id
}
/*
module "rules_for_rds_sg" {
    source = "./modules/simple_rules"
    rules = {
    "0" = ["egress", "0.0.0.0/0", "0", "65535", "TCP", "allow outbound traffic to www"]
    
  }
  security_group_id = module.rds_sg.sg_id
}
 */

 module "rdssg_ingress" {
  source = "./modules/simple_rules"
  type            =  "ingress"
  cidr_blocks     =   [module.pub_sub.cidr_block[0]]
  from_port       =    "3306"
  to_port         =    "3306"
  protocol        =    "TCP"
  description       =  "allow traffic from subnet 1"
  security_group_id  =   module.rds_sg.sg_id
}

module "rds_sg_ingress" {
  source = "./modules/simple_rules"
  type            =  "ingress"
  cidr_blocks     =   [module.pub_sub.cidr_block[1]]
  from_port       =    "3306"
  to_port         =    "3306"
  protocol        =    "TCP"
  description       =  "allow traffic from subnet 1"
  security_group_id  =   module.rds_sg.sg_id
}


module "rdssg_egress" {
  source = "./modules/simple_rules"
  type         = "egress"
  cidr_blocks  = ["0.0.0.0/0"]
  from_port    =  "0"
  to_port      =  "65535"
  protocol     =  "TCP" 
  description =  "allow traffic to www"
  security_group_id = module.rds_sg.sg_id
}


# opren 3306 traffic from ec2 to rds sg
/*
module "rds_ingress" {
  source = "./modules/rules_with_id"
  type  = "ingress"
  rules = {
    "0" = [module.ec2_sg.sg_id, "3306", "3306", "TCP", "allow 3306 traffic from ec2"]
  }
  security_group_id = module.rds_sg.sg_id
}
*/
# create rds

module "rds" {
  source = "./modules/rds"
  db_security_group_id = [module.rds_sg.sg_id]
  db_subnet_group_name = module.db_sub_gr.db_subnet_group_id
}


# create dns record

module "dns" {
  source = "./modules/route_53"
  lb_dns_name = module.alb.alb_dns
  dns_name    = "pr.erkai-tentech.com" #replace with your dns name
  zone_id     = "Z0606220PY9TVRBHRBO3"        #replace with your zone id 
}
