provider "aws" {
  
}


resource "aws_instance" "name" {
  ami = "ami-0332d564d76dbd8d6"
  instance_type = "t2.micro"
  key_name      = "Newkey"

#   provisioner "remote-exec" {

#     inline = [ "sudo dnf install nginx -y",
#         "sudo systemctl start nginx"
    
    
#      ]
# }
# connection {
#   type        = "ssh"
#   user        = "ec2-user"
#   private_key = file("./my-key.pem")
#   host        = self.public_ip
# }
#   provisioner "local-exec" {
#     command = "echo EC2 instance created successfully"
#   }

#     provisioner "file" {
#     source      = "./app.txt"
#     destination = "/tmp/app.txt"

#     connection {
#       type        = "ssh"
#       user        = "ec2-user"
#       private_key = file("./my-key.pem")
#       host        = self.public_ip
#     }
#   }

}

resource "null_resource" "provisioners" {

 provisioner "remote-exec" {

    connection {
      
      user = "ec2-user"
       private_key = file("./my-key.pem")
       host        = aws_instance.name.id
    }

    inline = [ "touch 'hello from null resource triggers' >> /tmp/app.txt" ]
   
 }
 triggers = {
    always_run = timestamp()
  }
  
}