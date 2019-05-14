# Terraform script to setup AWS infrastructure
---
This terraform script will setup an infrastructure with a VPC, 2 public subnets and 2 private subnets in AWS environment. It will setup a mysql database in 2 private subnets and sample nodejs application in 2 public subnets with load balancing/autoscaling feature. It wll setup security groups, route tables, network access control list (NACL), NAT Gateway and Internet Gateway (IGW) as well.

Following are the modules used to setup infrastructure.

## Modules

1. VPC module (with 2 public and 2 private subnets)
2. Database module (with variables i.e dbname and credentials)
3. EC2 module (to spinup new instances in vpc using ALB and autoscaling group)