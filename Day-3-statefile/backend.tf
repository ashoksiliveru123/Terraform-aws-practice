terraform{
    backend "s3" {
        bucket = "terraform-statefile-bucket-day3"
        key    = "terraform.tfstate"
        region = "us-east-1"
    }
}