variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "Please set the region where the resouces to be created "
}

variable "publickey" {
  type        = string
  default     = ""
  description = "EC2   Instance Public Key"
}

variable "subnet_ids_pri" {
  type    = list(any)
  default = ["subnet-06d0a8066ed3e64d1"]
  #  default = [""]
}

variable "subnet_ids_pub" {
  type    = list(any)
  default = [""]
}

variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}

/*
variable "vpc_subnet_count" {
  type        = number
  description = "Number of vpc subnets"
}

variable "vpc_subnets" {
  type        = list(object({
    label = string
    id    = string
    zone  = string
  }))
  description = "List of subnets with labels"
}

*/

variable "prefix_name" {
  type        = string
  description = "Prefix to be added to the names of resources which are being provisioned"
  default     = "swe"
}
variable "instance_tenancy" {
  type        = string
  description = "Instance is shared / dedicated, etc. #[default, dedicated, host]"
  default     = "default"
}

variable "internal_cidr" {
  type        = string
  description = "The cidr range of the internal network.Either provide manually or chose from AWS IPAM poolsß"
  default     = "10.0.0.0/16"
}

variable "provision" {
  type        = bool
  description = "Flag indicating that the instance should be provisioned. If false then an existing instance will be looked up"
  default     = false
}
variable "vpc_id" {
  type        = string
  description = "The id of the existing VPC instance"
  #  default     = ""
  default = "vpc-04f723f4bca6e8583"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "(Required) The CIDR block for the private subnet."
  default     = ["10.0.125.0/24"]
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "(Required) The CIDR block for the public subnet."
  default     = ["10.0.0.0/20"]
}


variable "tags" {
  type = map(string)
  default = {
    project = "swe"
  }
  description = "(Optional) A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default = {
    tier = "public"
  }
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default = {
    tier = "private"
  }
}

variable "availability_zones" {
  description = "List of availability zone ids"
  type        = list(string)
  default     = [""]
}


#From ec2insatnce script
variable "aws_region" {
  type        = string
  default     = "us-west-1"
  description = "AWS Region to provision EC2 instance"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "subnet_cidr" {
  type    = list(any)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

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
  default     = "ami-03fa4afc89e4a8a09"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type 2 default"
  default     = "t3.large"
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
  default     = false
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

/*
variable "vpc_id" {
  type        = string
  description = "Enter  vpc ID"
}

*/
