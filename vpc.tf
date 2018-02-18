resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "terraform-aws-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
  name = "vpc_nat"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "NATSG"
  }
}

resource "aws_instance" "nat" {
  ami = "ami-0541ea7d" # special ami preconfigured to do NAT
  availability_zone = "us-west-2a"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.us-west-2a-public.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "VPC NAT"
  }
}

/*
  Public Subnet
*/
resource "aws_subnet" "us-west-2a-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_route_table" "us-west-2a-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "us-west-2a-public" {
  subnet_id = "${aws_subnet.us-west-2a-public.id}"
  route_table_id = "${aws_route_table.us-west-2a-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-west-2a-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "Private Subnet"
  }
}
