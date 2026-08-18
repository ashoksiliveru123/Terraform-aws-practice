module "prod" {
  source = "github.com/ashoksiliveru123/Terraform-aws-practice/Day-7-module-source"

  ami_id="ami-0bdc7d025135d7b49"
  instance_type = "t2.micro"
  name="ashnika"
}