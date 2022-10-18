provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web" {
  count = 2
  ami = "ami-0c17b6e26919642e9"
  instance_type = var.instancetype
  key_name = aws_key_pair.keypair.id
  vpc_security_group_ids = [var.securitygroup]
  subnet_id = "${element(var.subnet, count.index )}"
  
  tags = {
    Name = "web-server-${count.index + 1}"
  }
}
resource "aws_key_pair" "keypair" {
  key_name = "poc"
  public_key = "${file(var.my-public-key)}"
}

data "template_file" "init" {
  template = "${file("${path.module}/userdata.tpl")}"
}
