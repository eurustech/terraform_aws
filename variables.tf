variable "rds-Username" {
    type = "string"
    default = "razaUser"
}
variable "rds-Password" {
    type = "string"
    default = "razaPassword"
}
variable "instance-AMI" {
    type = "string"
    default = "ami-0bdb828fd58c52235"
}
variable "instance-KeyName" {
    type = "string"
    default = "raza-key-pair"
}