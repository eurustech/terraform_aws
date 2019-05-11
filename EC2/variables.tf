variable "vpc-id" {
    type = "string"
}
variable "vpc-PublicSubnet-Id-01" {
    type = "string"
}
variable "vpc-PublicSubnet-Id-02" {
    type = "string"
}
variable "rds-Username" {
    type = "string"
}
variable "rds-Password" {
    type = "string"
}
variable "rds-DBName" {
    type = "string"
}
variable "rds-Endpoint" {
    type = "string"
}
variable "instance-AMI" {
    type = "string"
}
variable "instance-KeyName" {
    type = "string"
}
variable "instance-web-sg-id" {
    type = "string"
}
variable "instance-elb-sg-id" {
    type = "string"
}