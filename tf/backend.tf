terraform {
  backend "s3" {
    bucket = "erkai-terraform-tentech"
    key    = "tfstatefile/terraform"
    region = "us-east-1"
  }
}