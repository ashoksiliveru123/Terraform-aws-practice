variable "ami_id" {
    description = "The AMI ID for the EC2 instance"
    type=string
    default=""
}

variable "instance_type" {
    description = "the type of the instance to be created"
    type=string
    default=""
}