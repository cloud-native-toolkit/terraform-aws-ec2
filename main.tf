locals {
  name                = "${replace(var.vpc_id, "/[^a-zA-Z0-9_\\-\\.]/", "")}-${var.label}"
  subnet_ids          = concat(var.subnet_ids_pri, var.subnet_ids_pub)
  sunet_len           = length(local.subnet_ids)
  base_security_group = var.base_security_group != null ? var.base_security_group : data.aws_security_group.newsg.id
  ssh_security_group_rule = var.allow_ssh_from != "" ? [{
    name        = "ssh-i"
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
    }, {
    name        = "all-e"
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allow_ssh_from
  }] : []
  security_group_rules = concat(local.ssh_security_group_rule, var.security_group_rules)
  #  base_acl_group       = var.base_acl_group != null ? var.base_acl_group : data.aws_network_acls.newacl.id
  base_acl_group = var.base_acl_group != null ? var.base_acl_group : aws_network_acl.ec2acl.id
  acl_group_rule = var.allow_acl_from != "" ? [{
    rule_number = 100
    egress      = true
    protocol    = "tcp"
    rule_action = "allow"
    cidr_block  = var.allow_acl_from
    from_port   = 22
    to_port     = 22
    }, {
    rule_number = 200
    egress      = false
    protocol    = "tcp"
    rule_action = "allow"
    cidr_block  = var.allow_acl_from
    from_port   = 22
    to_port     = 22
  }] : []
  acl_group_rules = concat(local.acl_group_rule, var.acl_group_rules)
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


data "aws_security_group" "newsg" {
  id = aws_security_group.ec2instance.id
}


resource "aws_network_acl" "ec2acl" {
  #  name   = "${var.prefix_name}-inst-acl-group"
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix_name}-inst-acl-group"
  }
}


resource "aws_security_group_rule" "addSGrule" {

  count             = length(local.security_group_rules)
  security_group_id = local.base_security_group
  type              = local.security_group_rules[count.index]["type"]
  from_port         = lookup(local.security_group_rules[count.index], "from_port", null)
  to_port           = lookup(local.security_group_rules[count.index], "to_port", null)
  protocol          = lookup(local.security_group_rules[count.index], "protocol", null)
  cidr_blocks       = lookup(local.security_group_rules[count.index], "cidr_blocks", null)
  #  ip_version        = lookup(local.security_group_rules[count.index], "ip_version", null)

}

resource "aws_network_acl_rule" "addACLrule" {

  count          = length(local.acl_group_rules)
  network_acl_id = local.base_acl_group
  rule_number    = local.acl_group_rules[count.index]["rule_number"]
  egress         = lookup(local.acl_group_rules[count.index], "egress", null)
  protocol       = lookup(local.acl_group_rules[count.index], "protocol", null)
  rule_action    = lookup(local.acl_group_rules[count.index], "rule_action", null)
  cidr_block     = lookup(local.acl_group_rules[count.index], "cidr_block", null)
  from_port      = lookup(local.acl_group_rules[count.index], "from_port", null)
  to_port        = lookup(local.acl_group_rules[count.index], "to_port", null)
  #  ip_version        = lookup(local.security_group_rules[count.index], "ip_version", null)

}

resource "aws_instance" "ec2_pri_instance" {
#  depends_on    = [module.ssh_key_swe]
  ami           = var.ami_id
  instance_type = var.instance_type
  #  count         = var.subnet_count_private
  count = local.sunet_len
  #  subnet_id     = element(var.subnet_ids_pri, count.index)
  subnet_id  = element(local.subnet_ids, count.index)
  monitoring = var.pri_instance_monitoring
  # user_data     = var.init_script != "" ? var.init_script : "${file("./scripts/init-script-ubuntu.sh")}"
  user_data = var.init_script != "" ? var.init_script : file("${path.module}/scripts/init-script-ubuntu.sh")
  #  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  vpc_security_group_ids = ["${aws_security_group.ec2instance.id}"]
  #  key_name               = aws_key_pair.ec2_instance.id
  key_name                    = var.ssh_key
  associate_public_ip_address = var.publicIP
  root_block_device {
    delete_on_termination = true
    encrypted             = var.root_block_device_encrypted
    #     kms_key_id            = <Amazon Resource Name (ARN) of the KMS Key to use>
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = {
    "Name"    = "${format("%s-%s-%02s", var.prefix_name, var.label, count.index + 1)}"
    "project" = "swe"
  }
}


