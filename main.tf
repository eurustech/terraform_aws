module "networkModule" {
  source = "./VPC"
}
module "databaseModule" {
  source = "./RDS"
  vpc-id = "${module.networkModule.Id}"
  vpc-PrivateSubnet-Id-01 = "${module.networkModule.Private_SubnetId_01_Id}"
  vpc-PrivateSubnet-Id-02 = "${module.networkModule.Private_SubnetId_02_Id}"
  instance-web-sg-id = "${module.networkModule.Web_SecurityGroup_Id}"
  rds-Username = "${var.rds-Username}"
  rds-Password = "${var.rds-Password}"
}
module "EC2Module" {
  source = "./EC2"
  vpc-id = "${module.networkModule.Id}"
  vpc-PublicSubnet-Id-01 = "${module.networkModule.Public_SubnetId_01_Id}"
  vpc-PublicSubnet-Id-02 = "${module.networkModule.Public_SubnetId_02_Id}"
  rds-Username = "${var.rds-Username}"
  rds-Password = "${var.rds-Password}"
  rds-DBName = "${module.databaseModule.rds_dbname}"
  rds-Endpoint = "${module.databaseModule.rds_endpoint}"
  instance-AMI = "${var.instance-AMI}"
  instance-KeyName = "${var.instance-KeyName}"
  instance-web-sg-id = "${module.networkModule.Web_SecurityGroup_Id}"
  instance-elb-sg-id = "${module.networkModule.ELB_SecurityGroup_Id}"
}