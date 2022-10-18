provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source            = "./vpc"
  vpc_cidr          = "10.0.0.0/16"
  public-subnet     = ["10.0.1.0/24", "10.0.2.0/24"]
  private-subnet    = ["10.0.3.0/24", "10.0.4.0/24"]
  db-private-subnet = ["10.0.5.0/24", "10.0.6.0/24"]
}

module "ec2" {
  source        = "./ec2"
  my-public-key = "./id_rsa.pub"
  instancetype  = "t2.micro"
  securitygroup = module.vpc.security_group
  subnet        = module.vpc.subnet
}

module "elb" {
  source = "./elb"
  #current variablename = module.vpc.outputnameofvpcmodule
  dev-vpc      = module.vpc.aws_vpc_id
  instance1_id = module.ec2.instance1
  instance2_id = module.ec2.instance2
  subnet1      = module.vpc.subnet11
  subnet2      = module.vpc.subnet22
}

module "autoscaling" {
  source           = "./autoscaling"
  subnet1          = module.vpc.subnet11
  subnet2          = module.vpc.subnet22
  target_group_arn = module.elb.alb_target_group_arn
  dev-vpc          = module.vpc.aws_vpc_id
}
module "database" {
  source      = "./database"
  db_instance = "db.t2.micro"
  dev-vpc     = module.vpc.aws_vpc_id
  rds_subnet1 = module.vpc.db-private-subnet1
  rds_subnet2 = module.vpc.db-private-subnet2
  elb-sg      = module.vpc.security_group
}