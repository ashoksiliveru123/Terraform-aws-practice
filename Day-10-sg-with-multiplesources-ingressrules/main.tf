provider "aws" {
  
}


variable "ports" {

    default = [{port:80,source:"10.0.1.0/24"},
    {port:443,source:"10.0.2.0/24"}
    
    
    
    ]
  
}

resource "aws_security_group" "name" {
    name = "web-sg"
    description ="allow"

    dynamic "ingress" {
        for_each = var.ports

        content {
          from_port = ingress.value.port
          to_port = ingress.value.port
          protocol = "tcp"
          cidr_blocks = [ingress.value.source]
        }
      
    }
    egress = {
        from_port=0
        to_port=0
        protocol="-1"
        cidr_block=["0.0.0.0/0"]
    }
  
}