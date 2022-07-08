terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "main_VPC" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s-cluster"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_VPC.id
}

resource "aws_subnet" "public_subnet" {
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.main_VPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}


resource "aws_route_table" "public_table" {
  vpc_id = aws_vpc.main_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "main-table"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public_table.id
  subnet_id= aws_subnet.public_subnet.id
}




resource "aws_eip" "Nat-Gateway-EIP" {
  vpc = true
}

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.Nat-Gateway-EIP.id
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "Nat-GW"
  }
}

resource "aws_route_table" "worker_table" {
  vpc_id = aws_vpc.main_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GW.id
  }
  tags = {
    Name = "workers-table"
  }
}



resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.worker_table.id
  subnet_id = aws_subnet.worker_subnet.id
}

resource "aws_subnet" "worker_subnet" {
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.main_VPC.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
}





resource "aws_security_group" "public" {
  vpc_id = aws_vpc.main_VPC.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
    from_port = 22
    to_port = 22
  }
  ingress {
    description = "allow anyone on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow anyone on port 8090"
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.main_VPC.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_key_pair" "sh-key-for-me" {
  key_name = "My_Key"
  public_key = file("/root/.ssh/id_rsa.pub")
}

data "aws_ami" "amzn-linux-ec2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

###### Instances ######

resource "aws_instance" "bastion" {
  ami  = data.aws_ami.amzn-linux-ec2.id
  instance_type = "t3.medium"
  key_name = aws_key_pair.sh-key-for-me.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.public.id]
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "bastion"

  }
}

resource "aws_instance" "jenkins" {
  ami  = data.aws_ami.amzn-linux-ec2.id
  instance_type = "t3.medium"
  key_name = aws_key_pair.sh-key-for-me.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.public.id]
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "jenkins"

  }
}


resource "aws_instance" "worker" {
  count = 3
  ami  = data.aws_ami.amzn-linux-ec2.id
  instance_type = "t3.medium"
  key_name = aws_key_pair.sh-key-for-me.key_name
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id = aws_subnet.worker_subnet.id
  tags = {
    Name = "worker-${count.index}"
  }
  root_block_device {
    volume_size = "16"
    volume_type = "standard"
  }
}


resource "aws_instance" "master" {
  ami  = data.aws_ami.amzn-linux-ec2.id
  instance_type = "t3.medium"
  key_name = aws_key_pair.sh-key-for-me.key_name
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id = aws_subnet.worker_subnet.id
  tags = {
    Name = "master"

  }
}

###### temlating inventory file for ansible######

data "template_file" "inventory" {
  template = "${file("./tmp/inventory.ini")}"
  vars = {
    worker-1-prv = "${aws_instance.worker.0.private_ip}"
    worker-2-prv = "${aws_instance.worker.1.private_ip}"
    worker-3-prv = "${aws_instance.worker.2.private_ip}"

    bastion-pub = "${aws_instance.bastion.public_ip}"

    jenkins-pub = "${aws_instance.jenkins.public_ip}"
    jenkins-prv = "${aws_instance.jenkins.private_ip}"

    master-prv = "${aws_instance.master.private_ip}"
    bastion-prv = "${aws_instance.bastion.private_ip}"

  }
}


resource "null_resource" "inventory" {
  triggers = {
    template_rendered = "${data.template_file.inventory.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ./inventory.ini"
 }
}
