resource "aws_instance" "private_subnet_instance_1" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "us-west-2a"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.us-west-2a-public.id}"
  associate_public_ip_address = false
  source_dest_check = false

  tags {
    Name = "Private subnet Server 1"
  }
}
