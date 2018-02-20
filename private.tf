resource "aws_security_group" "db" {
  name = "vpc_db"
  description = "Allow incoming database connections."

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "DBServerSG"
  }
}

resource "aws_instance" "db-1" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "us-west-2a"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  subnet_id = "${aws_subnet.us-west-2a-public.id}"
  associate_public_ip_address = false
  source_dest_check = false

  tags {
    Name = "DB Server 1"
  }
}
