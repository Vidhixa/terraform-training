# NOT DELETE THESE LINES!
#
# Your AMI ID -- ami-eea9f38e
#
# Your subnet ID -- subnet-7e08481a
#
# Your security group ID -- sg-834d35e4
#
# Your Identity is -- autodesk-rabbit
#
terraform {
  backend "atlas" {
    name = "vidhixa/vid"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-west-1"
}

variable "total_count" {
  type = "string"
  default = 3
}

provider "aws" {
  access_key = ${var.aws_access_key}
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami                    = "ami-eea9f38e"
  subnet_id              = "subnet-7e08481a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-834d35e4"]

  tags {
    Identity       = "autodesk-rabbit"
    Cloud_Provider = "AWS"
    Use_Type       = "training"
    Name           = "web ${count.index+1}/${var.total_count}"
  }

  count = "${var.total_count}"
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
