terraform {
  backend "s3" {
    bucket = "terraform-statefile-bucket-day3"
    key = "day-4/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}