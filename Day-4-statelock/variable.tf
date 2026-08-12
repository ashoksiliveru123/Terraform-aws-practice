variable "ami_id"{
    description = "the ami to be used for the instance"
    type=string
    default=""
}

variable "instance_type"{
    description = "the type of the instance to be created"
    type=string
    default=""
}