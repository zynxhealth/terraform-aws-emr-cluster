variable "project" {
  default = "Unknown"
}

variable "environment" {
  default = "Unknown"
}

variable "name" {}

variable "custom_ami_id" {}

variable "vpc_id" {}

variable "release_label" {
  default = "emr-5.8.0"
}

variable "applications" {
  default = ["Spark"]
  type    = "list"
}

variable "configurations" {}

variable "key_name" {}

variable "subnet_id" {}

variable "instance_groups" {
  default = [
    {
      name           = "MasterInstanceGroup"
      instance_role  = "MASTER"
      instance_type  = "m3.xlarge"
      instance_count = 1
    },
    {
      name           = "CoreInstanceGroup"
      instance_role  = "CORE"
      instance_type  = "m3.xlarge"
      instance_count = "1"
      bid_price      = "0.30"
    },
  ]

  type = "list"
}

variable "additional_master_security_groups" {
  default = ""
}

variable "bootstrap_action" {
  default = {}
  type    = "map"
}

variable "log_uri" {}
