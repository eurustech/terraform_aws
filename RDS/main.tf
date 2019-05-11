resource "aws_security_group" "raza_RDS_SecurityGroup" {
    name = "raza_DB_Security_Group"
    vpc_id = "${var.vpc-id}"
    ingress = {
        security_groups = ["${var.instance-web-sg-id}"]
        from_port = 3306
        to_port = 3306
        protocol = "tcp"        
    }
    egress = {
        protocol = "-1"
        from_port = "0"
        to_port = "0"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "raza_DB_SecurityGroup"
        Developer = "raza"
    }
}
resource "aws_db_subnet_group" "raza_RDS_SubnetGroup" {
  name       = "razamysqlsubnetgroup"
  subnet_ids = ["${var.vpc-PrivateSubnet-Id-01}", "${var.vpc-PrivateSubnet-Id-02}"]
  tags = {
      Name = "raza_DB_SubnetGroup"
      Developer = "raza"
  }
}
resource "aws_db_instance" "raza_MySQL_DB_Instance" {
    identifier = "razamysql"
    name = "razaDB"
    allocated_storage = "6"
    instance_class = "db.t2.micro"
    engine = "mysql"
    engine_version = "5.7"
    username = "${var.rds-Username}"
    password = "${var.rds-Password}"
    db_subnet_group_name = "${aws_db_subnet_group.raza_RDS_SubnetGroup.name}"
    vpc_security_group_ids = ["${aws_security_group.raza_RDS_SecurityGroup.id}"]    
    skip_final_snapshot = "true"
    tags = {
      Name = "raza_MySQL_DB"
      Developer = "raza"
    }
}