resource "aws_key_pair" "sskeu1_prv_pub_key" {
  key_name   = "sskeu1_prv_pub_key"
  public_key = file("./sskeu1_prv.pub")
}

# Create VPC
resource "aws_vpc" "sskeu1_vpc" {
  cidr_block = var.aws_vpc

  tags = {
    Name = "sskeu1_vpc"
  }
}

# Public Subnet 1
resource "aws_subnet" "sskeu1_pubsn_01" {
  vpc_id            = aws_vpc.sskeu1_vpc.id
  cidr_block        = var.aws_pubsn01
  availability_zone = var.availability_zone1
  tags = {
    Name = "sskeu1_pubsn_01"
  }
}

# Public Subnet 2
resource "aws_subnet" "sskeu1_pubsn_02" {
  vpc_id            = aws_vpc.sskeu1_vpc.id
  cidr_block        = var.aws_pubsn02
  availability_zone = var.availability_zone2
  tags = {
    Name = "sskeu1_pubsn_02"
  }
}

# Private Subnet 1
resource "aws_subnet" "sskeu1_prvsn_01" {
  vpc_id            = aws_vpc.sskeu1_vpc.id
  cidr_block        = var.aws_prvsn01
  availability_zone = var.availability_zone1
  tags = {
    Name = "sskeu1_prvsn_01"
  }
}

# Private Subnet 2
resource "aws_subnet" "sskeu1_prvsn_02" {
  vpc_id            = aws_vpc.sskeu1_vpc.id
  cidr_block        = var.aws_prvsn02
  availability_zone = var.availability_zone2
  tags = {
    Name = "sskeu1_prvsn_02"
  }
}

# Private Subnet 3
resource "aws_subnet" "sskeu1_prvsn_03" {
  vpc_id            = aws_vpc.sskeu1_vpc.id
  cidr_block        = var.aws_prvsn03
  availability_zone = var.availability_zone3
  tags = {
    Name = "sskeu1_prvsn_03"
  }
}

# Internet Gateway 
resource "aws_internet_gateway" "sskeu1_igw" {
  vpc_id = aws_vpc.sskeu1_vpc.id

  tags = {
    Name = "sskeu1_igw"
  }
}

#Create Elastic IP for NAT gateway
resource "aws_eip" "sskeu1_nat_eip" {
  vpc = true
  tags = {
    Name = "sskeu1_nat_eip"
  }
}

# Create NAT gateway
resource "aws_nat_gateway" "sskeu1_ngw" {
  allocation_id = aws_eip.sskeu1_nat_eip.id
  subnet_id     = aws_subnet.sskeu1_pubsn_01.id

  tags = {
    Name = "sskeu1_ngw"
  }

  depends_on = [aws_internet_gateway.sskeu1_igw]
}

# Create Public Route Table
resource "aws_route_table" "sskeu1_pub_rt" {
  vpc_id = aws_vpc.sskeu1_vpc.id

  route {
    cidr_block = var.all
    gateway_id = aws_internet_gateway.sskeu1_igw.id
  }

  tags = {
    Name = "sskeu1_pub_rt"
  }
}

# Route table association for public subnet 1
resource "aws_route_table_association" "sskeu1_pub1_rt" {
  subnet_id      = aws_subnet.sskeu1_pubsn_01.id
  route_table_id = aws_route_table.sskeu1_pub_rt.id
}

# Route table association for public subnet 2
resource "aws_route_table_association" "sskeu1_pub2_rt" {
  subnet_id      = aws_subnet.sskeu1_pubsn_02.id
  route_table_id = aws_route_table.sskeu1_pub_rt.id
}

# Create Private Route Table
resource "aws_route_table" "sskeu1_prv_rt" {
  vpc_id = aws_vpc.sskeu1_vpc.id

  route {
    cidr_block     = var.all
    nat_gateway_id = aws_nat_gateway.sskeu1_ngw.id
  }

  tags = {
    Name = "sskeu1_prv_rt"
  }
}

# Route table association for private subnet 1
resource "aws_route_table_association" "sskeu1_prv01_rt" {
  subnet_id      = aws_subnet.sskeu1_prvsn_01.id
  route_table_id = aws_route_table.sskeu1_prv_rt.id
}

# Route table association for private subnet 2
resource "aws_route_table_association" "sskeu1_prv02_rt" {
  subnet_id      = aws_subnet.sskeu1_prvsn_02.id
  route_table_id = aws_route_table.sskeu1_prv_rt.id
}

# Route table association for private subnet 3
resource "aws_route_table_association" "sskeu1_prv03_rt" {
  subnet_id      = aws_subnet.sskeu1_prvsn_03.id
  route_table_id = aws_route_table.sskeu1_prv_rt.id
}
# Security group for Master Server
resource "aws_security_group" "sskeu1_Master_sg" {
  name        = "sskeu1_Master_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.sskeu1_vpc.id

  ingress {
    description = "SSH"
    from_port   = var.any
    to_port     = var.any
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.any
    to_port     = var.any
    protocol    = "-1"
    cidr_blocks = [var.all]
  }

  tags = {
    Name = "sskeu1_Naster_sg"
  }
}

# Security group for Worker Server
resource "aws_security_group" "sskeu1_Worker_sg" {
  name        = "sskeu1_Worker_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.sskeu1_vpc.id

  ingress {
    description = "SSH"
    from_port   = var.any
    to_port     = var.any
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.any
    to_port     = var.any
    protocol    = "-1"
    cidr_blocks = [var.all]
  }

  tags = {
    Name = "sskeu1_Worker_sg"
  }
}


# Security group for Ansible server
resource "aws_security_group" "sskeu1_Ansible_sg" {
  name        = "sskeu1_Ansible_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.sskeu1_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all]
  }

  egress {
    from_port   = var.any
    to_port     = var.any
    protocol    = "-1"
    cidr_blocks = [var.all]
  }

  tags = {
    Name = "sskeu1_Ansible_sg"
  }
}

# Security group for Load Balancer Server
resource "aws_security_group" "sskeu1_LB_sg" {
  name        = "sskeu1_LB_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.sskeu1_vpc.id

  ingress {
    description = "SSH"
    from_port   = var.any
    to_port     = var.any
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.any
    to_port     = var.any
    protocol    = "-1"
    cidr_blocks = [var.all]
  }

  tags = {
    Name = "sskeu1_LB_sg"
  }
}


# Provisioning of Master01 Node
resource "aws_instance" "sskeu1_Master01_Node" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.sskeu1_prv_pub_key.key_name
  subnet_id                   = aws_subnet.sskeu1_pubsn_01.id
  vpc_security_group_ids      = [aws_security_group.sskeu1_Master_sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
  #!bin/bash
  sudo su
  apt-get update -y
  apt-get upgrade -y
  systemctl reload sshd
  chmod -R 700 .ssh/
  chown ubuntu /home/ubuntu/ .ssh/authorized_keys
  chgrp ubuntu /home/ubuntu/ .ssh/authorized_keys
  hostnamectl set-hostname Master01
  
  EOF
  tags = {
    Name = "sskeu1_Master01_Node"
  }

}

# Provisioning of Master02 Node
resource "aws_instance" "sskeu1_Master02_Node" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.sskeu1_prv_pub_key.key_name
  subnet_id                   = aws_subnet.sskeu1_pubsn_01.id
  vpc_security_group_ids      = [aws_security_group.sskeu1_Master_sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
  #!bin/bash
  sudo su
  apt-get update -y
  apt-get upgrade -y
  systemctl reload sshd
  chmod -R 700 .ssh/
  chown ubuntu /home/ubuntu/ .ssh/authorized_keys
  chgrp ubuntu /home/ubuntu/ .ssh/authorized_keys
  hostnamectl set-hostname Master02
  EOF

  tags = {
    Name = "sskeu1_Master02_Node"
  }

}

# Provisioning of Worker01 Node
resource "aws_instance" "sskeu1_Worker01_Node" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.sskeu1_prv_pub_key.key_name
  subnet_id                   = aws_subnet.sskeu1_pubsn_01.id
  vpc_security_group_ids      = [aws_security_group.sskeu1_Worker_sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
  #!bin/bash
  sudo su
  apt-get update -y
  apt-get upgrade -y
  systemctl reload sshd
  chmod -R 700 .ssh/
  chown ubuntu /home/ubuntu/ .ssh/authorized_keys
  chgrp ubuntu /home/ubuntu/ .ssh/authorized_keys
  hostnamectl set-hostname Worker01
  EOF

  tags = {
    Name = "sskeu1_Worker01_Node"
  }

}

# Provisioning of Worker01 Node
resource "aws_instance" "sskeu1_Worker02_Node" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.sskeu1_prv_pub_key.key_name
  subnet_id                   = aws_subnet.sskeu1_pubsn_01.id
  vpc_security_group_ids      = [aws_security_group.sskeu1_Worker_sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
  #!bin/bash
  sudo su
  apt-get update -y
  apt-get upgrade -y
  systemctl reload sshd
  chmod -R 700 .ssh/
  chown ubuntu /home/ubuntu/ .ssh/authorized_keys
  chgrp ubuntu /home/ubuntu/ .ssh/authorized_keys
  hostnamectl set-hostname Worker02
  EOF

  tags = {
    Name = "sskeu1_Worker02_Node"
  }

}
#Data Source for Master1
data "aws_instance" "DS_master_01" {

  filter {
    name   = "tag:Name"
    values = ["sskeu1_Master01_Node"]
  }
  depends_on = [
    aws_instance.sskeu1_Master01_Node,
  ]

}

#Data Source for Master2
data "aws_instance" "DS_master_02" {

  filter {
    name   = "tag:Name"
    values = ["sskeu1_Master02_Node"]
  }
  depends_on = [
    aws_instance.sskeu1_Master02_Node,
  ]
}

#Data Source for Worker1
data "aws_instance" "DS_worker_01" {

  filter {
    name   = "tag:Name"
    values = ["sskeu1_Worker01_Node"]
  }
  depends_on = [
    aws_instance.sskeu1_Worker01_Node,
  ]
}

#Data Source for Worker2
data "aws_instance" "DS_worker_02" {

  filter {
    name   = "tag:Name"
    values = ["sskeu1_Worker02_Node"]
  }
  depends_on = [
    aws_instance.sskeu1_Worker02_Node,
  ]
}

# Create Ansible Server
resource "aws_instance" "sskeu1_ansible_node" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.sskeu1_prv_pub_key.key_name
  subnet_id                   = aws_subnet.sskeu1_pubsn_01.id
  vpc_security_group_ids      = [aws_security_group.sskeu1_Ansible_sg.id]
  associate_public_ip_address = true

  # Connection Through SSH
  connection {
    type        = "ssh"
    private_key = file("sskeu1_prv")
    user        = "ubuntu"
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "./sskeu1_prv"
    destination = "/home/ubuntu/key.pem"
  }

  provisioner "file" {
    source      = "./MyPlaybook.yaml"
    destination = "/home/ubuntu/MyPlaybook.yaml"
  }

  user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible -y
sudo chmod 400 key.pem
cat <<EOT>> /etc/ansible/hosts
[masters]
"${data.aws_instance.DS_master_01.public_ip}" ansible_ssh_private_key_file=/home/ubuntu/key.pem
#"${data.aws_instance.DS_master_02.public_ip}" ansible_ssh_private_key_file=/home/ubuntu/key.pem
[workers]
"${data.aws_instance.DS_worker_01.public_ip}" ansible_ssh_private_key_file=/home/ubuntu/key.pem
"${data.aws_instance.DS_worker_02.public_ip}" ansible_ssh_private_key_file=/home/ubuntu/key.pem 
EOT



EOF
  tags = {
    Name = "sskeu1_ansible_node"
  }
}

