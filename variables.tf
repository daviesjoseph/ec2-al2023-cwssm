variable "profile" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-southeast-2"
}

# The name of the instance to be deployed which will be stored in an instance tag
variable "instance_name" {
  type    = string
  default = "TerraformSSMEnabledInstance"
}

variable "owner" {
  type        = string
  description = "Owner of the deployed SSM enabled instance"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
