module "vpc" {
  source = "./Modules/vpc"
  vpc-cidrblock ="10.0.0.0/16"
  subnet_group = "10.0.0.0/24"

}

module "ec2" {
    source = "./Modules/ec2"
    ami = "ami-0332d564d76dbd8d6"
    instance_type = "t2.micro"
    
  
}