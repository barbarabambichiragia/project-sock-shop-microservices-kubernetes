# VPC CIDR BLOCK
variable "aws_vpc" {
  default = "10.0.0.0/16"
}

# Public Subnet 1
variable "aws_pubsn01" {
  default = "10.0.1.0/24"
}

#Public Subnet 2
variable "aws_pubsn02" {
  default = "10.0.2.0/24"
}

#Private Subnet 1
variable "aws_prvsn01" {
  default = "10.0.3.0/24"
}

#Private Subnet 2
variable "aws_prvsn02" {
  default = "10.0.4.0/24"
}

#Private Subnet 3
variable "aws_prvsn03" {
  default = "10.0.5.0/24"
}

#All IP CIDR
variable "all" {
  default = "0.0.0.0/0"
}

#Any Ports
variable "any" {
  default = "0"
}

# Ubuntu Instance
variable "ami_ubuntu" {
  default = "ami-0f540e9f488cfa27d"
}


#  Az
variable "availability_zone1" {
  default = "eu-west-2a"
}

#  Az
variable "availability_zone2" {
  default = "eu-west-2b"
}

#  Az
variable "availability_zone3" {
  default = "eu-west-2c"
}

#  Instance Type
variable "instance_type" {
  default = "t2.medium"
}