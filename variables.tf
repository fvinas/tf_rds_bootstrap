variable "name" {
  description = "Name to be used as a basename on all the resources identifiers"
  default     = "RDS_BOOSTRAP_EPHEMERAL"
}

variable "subnet_id" {
  description = "Subnet in which the ephemeral instance is created"
  default     = ""
}

variable "security_group_ids" {
  description = "A list of security groups the ephemeral instance will belong to"
  default     = []
}

variable "iam_instance_profile" {
  description = "Instance profile name that will be used by the bootstrap instance"
  default     = ""
}

variable "endpoint" {
  description = "RDS connection endpoint"
  default     = ""
}

variable "port" {
  description = "RDS connection port"
  default     = ""
}

variable "master_username" {
  description = "RDS master user name"
  default     = ""
}

variable "master_password" {
  description = "RDS master password"
  default     = ""
}

variable "database" {
  description = "RDS database name"
  default     = ""
}

variable "shell_script" {
  description = "A shell script template that will be run from the ephemeral instanceRDS database name"
  default     = ""
}

variable "sql_script" {
  description = "A SQL script that will be run from the ephemeral instance against a MySQL/Aurora RDS DB"
  default     = ""
}

variable "instance_type" {
  description = "Ephemeral instance type"
  default     = "t2.micro"
}

variable "ami_name_filter" {
  description = "Name to filter on for AMI"
  default = "amzn-ami-hvm*-x86_64-gp2"
}

variable "ami_owner_id_filter" {
  description = "OwnerID (one) to filter on for AMI"
  default = "137112412989"
}

