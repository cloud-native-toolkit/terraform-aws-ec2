
locals {
  name = "${replace(var.vpc_id, "/[^a-zA-Z0-9_\\-\\.]/", "")}-${var.label}"
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}


resource "aws_security_group" "ec2instance" {
  name   = "${var.prefix_name}-inst-sg-group"
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix_name}-inst-sg-group"
  }
}

resource "aws_security_group_rule" "ssh-i" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2instance.id
  cidr_blocks       = var.cidr_blocks
}

resource "aws_security_group_rule" "all-e" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ec2instance.id
  cidr_blocks       = var.cidr_blocks
}

#+++++ Stage-2 Instance Configuration +++++#

#####SSH Key Copy Process#####

resource "aws_key_pair" "ec2_instance" {
  #  key_name   = var.ssh_key
  key_name = "${local.name}-key"
  #  public_key = file("~/.ssh/sivasaivm-pub")
  public_key = var.publickey
  tags = {
    Name = "${local.name}-key"
  }
}

resource "aws_instance" "ec2_pri_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.subnet_count_private
  subnet_id     = element(var.subnet_ids_pri, count.index)
  monitoring    = var.pri_instance_monitoring
  #  user_data     = var.init_script != "" ? var.init_script : file("${path.module}/scripts/init-script-ubuntu.sh")
  #  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  vpc_security_group_ids = ["${aws_security_group.ec2instance.id}"]
  key_name               = aws_key_pair.ec2_instance.id
  root_block_device {
    delete_on_termination = true
    encrypted             = var.root_block_device_encrypted
    #     kms_key_id            = <Amazon Resource Name (ARN) of the KMS Key to use>
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = {
    "Name" = "${format("%s-%s-pri-%02s", var.prefix_name, var.label, count.index + 1)}"
    "project" = "swe"
  }
}


resource "aws_instance" "ec2_pub_instance" {
  ami                         = var.ami_id
  associate_public_ip_address = var.publicIP
  instance_type               = var.instance_type
  count                       = var.subnet_count_public
  subnet_id                   = element(var.subnet_ids_pub, count.index)
  monitoring                  = var.pub_instance_monitoring
  #  user_data     = var.init_script != "" ? var.init_script : file("${path.module}/scripts/init-script-ubuntu.sh")
  #  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  vpc_security_group_ids = ["${aws_security_group.ec2instance.id}"]
  key_name               = aws_key_pair.ec2_instance.id
  root_block_device {
    delete_on_termination = true
    encrypted             = var.root_block_device_encrypted
    #     kms_key_id            = <Amazon Resource Name (ARN) of the KMS Key to use>
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
  tags = {
    "Name" = "${format("%s-%s-pub-%02s", var.prefix_name, var.label, count.index + 1)}"
    "project" = "swe"
  }

}


#+++++ Stage-2 Instance Configuration +++++#

