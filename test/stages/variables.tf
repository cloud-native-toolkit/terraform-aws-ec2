variable "region" {
  type        = string
  default     = ""
  description = "Please set the region where the resouces to be created "
}

### var used by SSH Module ####start

variable "private_key_file" {
  type    = string
  default = ""
}

variable "private_key" {
  type    = string
  default = ""
}

variable "public_key_file" {
  type    = string
  default = ""
}

variable "public_key" {
  type    = string
  default = ""
}

variable "rsa_bits" {
  type    = number
  default = 3072
}

variable "name" {
  type    = string
  default = ""
}

variable "label" {
  default = "prd"
  type    = string
}

variable "name_prefix" {
  type        = string
  default     = "swe"
  description = "name prefix"
}


###var used by SSH Module ###end

###var used by VPC Module ###start

variable "provision" {
  type        = bool
  description = "Flag indicating that the instance should be provisioned. If false then an existing instance will be looked up"
  default     = true
}

variable "internal_cidr" {
  type        = string
  description = "The cidr range of the internal network.Either provide manually or chose from AWS IPAM poolsß"
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  type        = string
  description = "Instance is shared / dedicated, etc. #[default, dedicated, host]"
  default     = "default"
}

#used by VPC,Subnet & EC2 Module #
variable "vpc_id" {
  type        = string
  description = "The id of the existing VPC instance"
  #  default     = ""
  default = "vpc-04f723f4bca6e8583"
}


###var used by VPC Module ###end

###var used by Subenet Module ###start


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

variable "availability_zones" {
  description = "List of availability zone ids"
  type        = list(string)
  default     = [""]
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


###var used by Subenet Module ###end

###var used by EC2 module ###start

variable "subnet_ids_pri" {
  type    = list(any)
  default = [""]
}

variable "subnet_ids_pub" {
  type    = list(any)
  default = [""]
}

variable "ami_id" {
  type        = string
  description = "AMI ID for bastion host"
  default     = "ami-03fa4afc89e4a8a09"
  #  default     = "ami-0573b70afecda915d"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type 2 default"
  default     = "t3.large"
}

variable "publickey" {
  type        = string
  default     = ""
  description = "EC2   Instance Public Key"
}

variable "root_block_device_encrypted" {
  type        = bool
  default     = true
  description = "Whether to encrypt the root block device"
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root volume in gigabytes"
  default     = 10
}


variable "root_volume_type" {
  type        = string
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "publicIP" {
  type        = bool
  default     = false
  description = "Whether to attach a public IP to EC2 instance"
}

variable "ssh_key" {
  type    = string
  default = ""
  #  default     = "sivasaivm-pub"
  description = "AWS EC2 Instance Public Key"
}


###var used by EC2 module ###end

###var for KMS module ###start

variable "key_spec" {
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1"
}

variable "rotation_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the key is enabled."
}

variable "alias" {
  type        = string
  default     = "Storage-kms"
  description = "The display name of the key."
}


variable "kms_alias" {
  type        = string
  default     = "Storage-kms"
  description = "The description of the key alias as viewed in AWS console."
}


###var for KMS module ###end


variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}

###var Used by SSH,VPC, module  ###start

variable "prefix_name" {
  type        = string
  description = "Prefix to be added to the names of resources which are being provisioned"
  default     = "swe"
}


###var Used by SSH, module###end


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

