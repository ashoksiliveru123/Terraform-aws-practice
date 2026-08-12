variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = ""
}
variable "region"{
    description="the region to deploy the instance"
    type=string
    default=""
}