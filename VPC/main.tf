# Data Sources
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "raza_VPC" {
    cidr_block = "${var.vpc-CIDR}"
    instance_tenancy = "default"
    tags = {
        Name = "raza_VPC"
        Developer = "raza"
    }    
}
# Internet Gateway
resource "aws_internet_gateway" "raza_IG" {
    vpc_id = "${aws_vpc.raza_VPC.id}"
    tags = {
        Name = "raza_IG"
        Developer = "raza"
    }
}
# Public ACL
resource "aws_network_acl" "raza_Public_ACL" {
  vpc_id = "${aws_vpc.raza_VPC.id}"
  subnet_ids = ["${aws_subnet.raza_Public_Subnet_01.id}","${aws_subnet.raza_Public_Subnet_02.id}"]
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  tags = {
        Name = "raza_Public_ACL"
        Developer = "raza"
    }
}
# Private ACL
resource "aws_network_acl" "raza_Private_ACL" {
  vpc_id = "${aws_vpc.raza_VPC.id}"
  tags = {
        Name = "Private"
        Developer = "raza"
    }
    subnet_ids = ["${aws_subnet.raza_Private_Subnet_01.id}","${aws_subnet.raza_Private_Subnet_02.id}"]
}
resource "aws_network_acl_rule" "raza_Private_ACL_Inbound_Rule_01" {
  network_acl_id = "${aws_network_acl.raza_Private_ACL.id}"
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"  
  cidr_block = "${var.vpc-PublicSubnet-01}"
  from_port      = 3306
  to_port        = 3306
}
resource "aws_network_acl_rule" "raza_Private_ACL_Outound_Rule_01" {
  network_acl_id = "${aws_network_acl.raza_Private_ACL.id}"
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"  
  cidr_block = "${var.vpc-PublicSubnet-01}"
  from_port      = 1024
  to_port        = 65535
}
resource "aws_network_acl_rule" "raza_Private_ACL_Inbound_Rule_02" {
  network_acl_id = "${aws_network_acl.raza_Private_ACL.id}"
  rule_number    = 200
  egress         = false
  protocol       = "6"
  rule_action    = "allow"  
  cidr_block = "${var.vpc-PublicSubnet-02}"
  from_port      = 3306
  to_port        = 3306
}
resource "aws_network_acl_rule" "raza_Private_ACL_Outound_Rule_02" {
  network_acl_id = "${aws_network_acl.raza_Private_ACL.id}"
  rule_number    = 200
  egress         = true
  protocol       = "6"
  rule_action    = "allow"  
  cidr_block = "${var.vpc-PublicSubnet-02}"
  from_port      = 1024
  to_port        = 65535
}
# Public Route Table
resource "aws_route_table" "raza_Public_RouteTable" {
    vpc_id = "${aws_vpc.raza_VPC.id}"
    tags = {
        Name = "raza_Public_RouteTable"
        Developer = "raza"
    }    
}
resource "aws_route" "raza_Public_Route" {
    route_table_id = "${aws_route_table.raza_Public_RouteTable.id}"
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.raza_IG.id}"   
}
# Private Route Table
resource "aws_route_table" "raza_Private_RouteTable" {
    vpc_id = "${aws_vpc.raza_VPC.id}"
    tags = {
        Name = "raza_Private_RouteTable"
        Developer = "raza"
    }
}
# Public Subnet
resource "aws_subnet" "raza_Public_Subnet_01" {
    vpc_id = "${aws_vpc.raza_VPC.id}" 
    cidr_block = "${var.vpc-PublicSubnet-01}"
    map_public_ip_on_launch = true    
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    tags = {
        Name = "raza_Public_Subnet_01"
        Developer = "raza"
    }    
}
resource "aws_route_table_association" "raza_Public_Subnet_01_Route_Rable_Association" {
    route_table_id = "${aws_route_table.raza_Public_RouteTable.id}"
    subnet_id = "${aws_subnet.raza_Public_Subnet_01.id}"
}

resource "aws_subnet" "raza_Public_Subnet_02" {
    vpc_id = "${aws_vpc.raza_VPC.id}" 
    cidr_block = "${var.vpc-PublicSubnet-02}"
    map_public_ip_on_launch = true    
    availability_zone = "${data.aws_availability_zones.available.names[1]}"
    tags = {
        Name = "raza_Public_Subnet_02"
        Developer = "raza"
    }
}
resource "aws_route_table_association" "raza_Public_Subnet_02_Route_Rable_Association" {
    route_table_id = "${aws_route_table.raza_Public_RouteTable.id}"
    subnet_id = "${aws_subnet.raza_Public_Subnet_02.id}"
}

# Private Subnet
resource "aws_subnet" "raza_Private_Subnet_01" {
    vpc_id = "${aws_vpc.raza_VPC.id}" 
    cidr_block = "${var.vpc-PrivateSubnet-01}"
    map_public_ip_on_launch = false    
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    tags = {
        Name = "raza_Private_Subnet_01"
        Developer = "raza"
    }
}
resource "aws_route_table_association" "raza_Private_Subnet_01_Route_Rable_Association" {
    route_table_id = "${aws_route_table.raza_Private_RouteTable.id}"
    subnet_id = "${aws_subnet.raza_Private_Subnet_01.id}"
}
resource "aws_subnet" "raza_Private_Subnet_02" {
    vpc_id = "${aws_vpc.raza_VPC.id}" 
    cidr_block = "${var.vpc-PrivateSubnet-02}"
    map_public_ip_on_launch = false    
    availability_zone = "${data.aws_availability_zones.available.names[1]}"
    tags = {
        Name = "raza_Private_Subnet_02"
        Developer = "raza"
    }
}
resource "aws_route_table_association" "raza_Private_Subnet_02_Route_Rable_Association" {
    route_table_id = "${aws_route_table.raza_Private_RouteTable.id}"
    subnet_id = "${aws_subnet.raza_Private_Subnet_02.id}"
}
# NAT Gateway
resource "aws_eip" "raza_ElasticIP" {
    vpc = true
    tags = {
        Name = "raza_EP"
        Developer = "raza"        
    }
}
resource "aws_nat_gateway" "raza_NAT_Gateway" {
    subnet_id = "${aws_subnet.raza_Public_Subnet_01.id}"
    allocation_id = "${aws_eip.raza_ElasticIP.id}"
    tags = {
        Name = "raza_NAT_Gateway"
        Developer = "raza"
    }
}
resource "aws_route" "raza_NAT_Gateway_Route" {
    nat_gateway_id = "${aws_nat_gateway.raza_NAT_Gateway.id}"
    route_table_id = "${aws_route_table.raza_Private_RouteTable.id}"
    destination_cidr_block = "0.0.0.0/0"
}
# Security Groups
resource "aws_security_group" "raza_Web_SecurityGroup" {
    name = "raza_Web_SG"
    vpc_id = "${aws_vpc.raza_VPC.id}"
    ingress = {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        from_port = "80"
        to_port = "80"        
    }
    ingress = {
        ipv6_cidr_blocks = ["::/0"]
        protocol = "tcp"
        from_port = "80"
        to_port = "80"      
    }
    ingress = {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        from_port = "443"
        to_port = "443"    
    }
    ingress = {
        ipv6_cidr_blocks = ["::/0"]
        protocol = "tcp"
        from_port = "443"
        to_port = "443" 
    }
    ingress = {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        from_port = "22"
        to_port = "22"
    }
    ingress = {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        from_port = "3000"
        to_port = "3000"
    }
    egress= {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "-1"
        from_port = "0"
        to_port = "0"
    }    
    tags = {
        Name = "raza_Web_SecurityGroup"
        Developer = "raza"
    }
}
resource "aws_security_group" "raza_ELB_SecurityGroup" {
    name = "raza_ELB_SG"
    vpc_id = "${aws_vpc.raza_VPC.id}"    
    ingress = {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "-1"
        from_port = "0"
        to_port = "0"
    }
    egress = {
        security_groups = ["${aws_security_group.raza_Web_SecurityGroup.id}"]
        protocol = "tcp"
        from_port = "80"
        to_port = "80"
    }
    egress = {
        security_groups = ["${aws_security_group.raza_Web_SecurityGroup.id}"]
        protocol = "tcp"
        from_port = "443"
        to_port = "443"
    }
    egress = {
        security_groups = ["${aws_security_group.raza_Web_SecurityGroup.id}"]
        protocol = "tcp"
        from_port = "3000"
        to_port = "3000"
    }
    tags = {
        Name = "raza_ELB_SecurityGroup"
        Developer = "raza"
    }
}