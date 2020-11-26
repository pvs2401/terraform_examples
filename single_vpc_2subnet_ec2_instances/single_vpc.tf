provider "aws" {
  region = "us-east-2"
}
# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "MyVPC"
  }
} # end resource
# create the Subnet
resource "aws_subnet" "My_VPC_Subnet1" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock1
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
  tags = {
    Name = "My VPC Subnet1"
  }
} # end resource
resource "aws_subnet" "My_VPC_Subnet2" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock2
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone2
  tags = {
    Name = "My VPC Subne2"
  }
} # end resource
# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id       = aws_vpc.My_VPC.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
  }
} # end resource
# Create the Internet Gateway
resource "aws_internet_gateway" "My_VPC_GW" {
 vpc_id = aws_vpc.My_VPC.id
  tags = {
        Name = "My VPC Internet Gateway"
  }
} # end resource
# Create the Route Table
resource "aws_route_table" "My_VPC_route_table" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My VPC Route Table"
  }
} # end resource
# Create the Internet Access
resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.My_VPC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
} # end resource
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_association1" {
  subnet_id      = aws_subnet.My_VPC_Subnet1.id
  route_table_id = aws_route_table.My_VPC_route_table.id
}
# end resource
resource "aws_route_table_association" "My_VPC_association2" {
  subnet_id      = aws_subnet.My_VPC_Subnet2.id
  route_table_id = aws_route_table.My_VPC_route_table.id
}
# Create EC2 keypair
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = file(var.public_key_path)
}
# end resource
resource "aws_instance" "K8SM" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.My_VPC_Subnet1.id
  vpc_security_group_ids = [aws_security_group.My_VPC_Security_Group.id]
  key_name = aws_key_pair.ec2key.key_name
  root_block_device {
    volume_size = 50
  }
  connection {
    type = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host = self.public_ip
  } 
  provisioner "file" {
    source      = "install_k8s.sh"
    destination = "/tmp/install_k8s.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_k8s.sh",
      "sudo sh +x /tmp/install_k8s.sh",
    ]
  }
  tags = {
    Name = "Master"
  }
}
resource "aws_instance" "K8SN1" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.My_VPC_Subnet1.id
  vpc_security_group_ids = [aws_security_group.My_VPC_Security_Group.id]
  key_name = aws_key_pair.ec2key.key_name
  root_block_device {
    volume_size = 50
  }
  connection {
    type = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host = self.public_ip
  }   
  provisioner "file" {
    source      = "install_k8s.sh"
    destination = "/tmp/install_k8s.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_k8s.sh",
      "sudo /tmp/install_k8s.sh",
    ]
  }  
  tags = {
    Name = "Node1"
  }
}
resource "aws_instance" "K8SN2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.My_VPC_Subnet1.id
  vpc_security_group_ids = [aws_security_group.My_VPC_Security_Group.id]
  key_name = aws_key_pair.ec2key.key_name
  root_block_device {
    volume_size = 50
  }
  connection {
    type = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host = self.public_ip
  }   
  provisioner "file" {
    source      = "install_k8s.sh"
    destination = "/tmp/install_k8s.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_k8s.sh",
      "sudo sh +x /tmp/install_k8s.sh",
    ]
  }  
  tags = {
    Name = "Node2"
  }  
}
resource "aws_instance" "K8SN3" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.My_VPC_Subnet2.id
  vpc_security_group_ids = [aws_security_group.My_VPC_Security_Group.id]
  key_name = aws_key_pair.ec2key.key_name
  root_block_device {
    volume_size = 50
  }
  connection {
    type = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host = self.public_ip
  }   
  provisioner "file" {
    source      = "install_k8s.sh"
    destination = "/tmp/install_k8s.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_k8s.sh",
      "sudo sh +x /tmp/install_k8s.sh",
    ]
  }  
  tags = {
    Name = "Node3"
  }  
}
# end vpc.tf
