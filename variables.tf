#variable "myvariable" {
#  type        = string
#  description = "A description of my variable"
#  default     = ""
#}

variable "aws_region" {
  type        = string
  default     = "us-west-1"
  description = "AWS Region to provision EC2 instance"
}

variable "publickey" {
  type    = string
  default = ""
}


variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "subnet_cidr" {
  type    = list(any)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}


variable "subnet_ids_pri" {
  type    = list(any)
  default = [""]
}

variable "subnet_ids_pub" {
  type    = list(any)
  default = [""]
}

variable "prefix_name" {
  type        = string
  description = "Prefix to be added to the names of resources which are being provisioned"
  default     = "swe"
}

variable "pri_instance_monitoring" {
  type        = bool
  default     = false
  description = "Enable EC2 private instance advance monitoring"
}

variable "pub_instance_monitoring" {
  type        = bool
  default     = true
  description = "Enable EC2 public instance advance monitoring"
}

/*
variable "vpc_subnet_count" {
  type        = number
  description = "Number of vpc subnets"
}

variable "vpc_subnets" {
  type = list(object({
    label = string
    id    = string
    zone  = string
  }))
  description = "List of subnets with labels"
}

*/

variable "azs" {
  type    = list(any)
  default = ["us-west-1a", "us-west-1c"]
}

variable "ssh_key" {
  type        = string
  default     = "fss-key"
  description = "AWS EC2 Instance Public Key"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for bastion host"
  default     = "ami-01f87c43e618bf8f0"
}

variable "subnet_count_private" {
  type    = string
  default = ""
}

variable "subnet_count_public" {
  type    = string
  default = ""
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

variable "vpc_id" {
  type        = string
  description = "Enter  vpc ID"
}


variable "label" {
  type        = string
  description = "The label for the server instance"
  default     = "server"
}


variable "root_volume_type" {
  type        = string
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root volume in gigabytes"
  default     = 10
}

variable "root_block_device_encrypted" {
  type        = bool
  default     = true
  description = "Whether to encrypt the root block device"
}


variable "root_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set to `io1`"
  default     = 0
}

variable "publicIP" {
  type        = bool
  default     = true
  description = "Whether to attach a public IP to EC2 instance"
}

variable "cidr_blocks" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "SG CIDR"
}


######Other options which can be used###



variable "security_groups" {
  description = "A list of Security Group IDs to associate with EC2 instance."
  type        = list(string)
  default     = []
}


variable "security_group_rules" {
  type = list(any)
  default = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  description = <<-EOT
    A list of maps of Security Group rules. 
    The values of map is fully complated with `aws_security_group_rule` resource. 
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule .
  EOT
}


