# variables.tf
variable "access_key" {
     default = "<PUT IN YOUR AWS ACCESS KEY>"
}
variable "secret_key" {
     default = "<PUT IN YOUR AWS SECRET KEY>"
}
variable "region" {
     default = "us-east-2"
}
variable "availabilityZone" {
     default = "us-east-2a"
}
variable "availabilityZone2" {
     default = "us-east-2b"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "subnetCIDRblock1" {
    default = "10.0.1.0/24"
}
variable "subnetCIDRblock2" {
    default = "10.0.2.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
variable "private_key_path" {
  default = "~/.ssh/id_rsa"
}
variable "instance_ami" {
  default = "ami-0dd9f0e7df0f0a138"
}
variable "instance_type" {
  default = "c5.2xlarge"
}
variable "environment_tag_master" {
  default = "K8SMaster"
}
variable "environment_tag_node1" {
  default = "K8SMinion1"
}
variable "environment_tag_node2" {
  default = "K8SMinion2"
}
# end of variables.tf
