variable "vpc-CIDR" {
    type = "string"
    default = "192.167.0.0/16"
}
variable "vpc-PublicSubnet-01" {
    type = "string"
    default = "192.167.1.0/24"
}
variable "vpc-PublicSubnet-02" {
    type = "string"
    default = "192.167.2.0/24"
}
variable "vpc-PrivateSubnet-01" {
    type = "string"
    default = "192.167.3.0/24"
}
variable "vpc-PrivateSubnet-02" {
    type = "string"
    default = "192.167.4.0/24"
}