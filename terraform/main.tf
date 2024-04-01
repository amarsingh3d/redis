# use default VPC to create EC2
data "aws_vpc" "this" {
  default = true
}

# Select Subnet from Default vpc
data "aws_subnet" "this" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "availability-zone"
    values = ["eu-west-1a"] # Replace with the desired Availability Zone (AZ)

  }

}

# grabbing latest ubuntu ami
data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID
}


# SG for EC2
resource "aws_security_group" "this" {
  name   = "${var.name}-SG"
  vpc_id = data.aws_vpc.this.id
  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      description = var.description
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [var.cidr_blocks]

    }
  }
  ingress {
    description = var.description
    from_port   = var.ssh-port
    to_port     = var.ssh-port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_blocks]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "${var.name}-SG"
  }
}

# EC2 Key
resource "aws_key_pair" "this" {
  key_name   = var.name
  public_key = var.pub_key

}

#Minikube EC2 setup
resource "aws_instance" "this" {
  instance_type          = var.instance_type
  count                  = var.instance_count
  ami                    = data.aws_ami.latest_ubuntu.image_id
  subnet_id              = data.aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = aws_key_pair.this.key_name
  user_data              = file("setup-minikube.sh")

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  tags = {
    Name = "${var.name}-${count.index +1}"
    Automation= "Terraform"

  }


}

# EIP for EC2
resource "aws_eip" "this" {
  count    = length(aws_instance.this)
  instance = aws_instance.this[count.index].id

}

