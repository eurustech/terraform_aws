output "Id" {
  value = "${aws_vpc.raza_VPC.id}"
}
output "Public_SubnetId_01_Id" {
  value = "${aws_subnet.raza_Public_Subnet_01.id}"
}
output "Public_SubnetId_02_Id" {
  value = "${aws_subnet.raza_Public_Subnet_02.id}"
}
output "Private_SubnetId_01_Id" {
  value = "${aws_subnet.raza_Private_Subnet_01.id}"
}
output "Private_SubnetId_02_Id" {
  value = "${aws_subnet.raza_Private_Subnet_02.id}"
}
output "Web_SecurityGroup_Id" {
  value = "${aws_security_group.raza_Web_SecurityGroup.id}"
}
output "ELB_SecurityGroup_Id" {
  value = "${aws_security_group.raza_ELB_SecurityGroup.id}"
}