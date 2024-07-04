terraform {
  cloud {
    organization = "My_First_Terra_"

    workspaces {
      name = "terra-house-1"
    }
  }

  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

provider "aws" {
  # Configuration options
}
  
provider "random" {
  # Configuration options
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string 
resource "random_string" "bucket_name" {
  lower = true
  upper = false
  length    = 32
  special   = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket 
resource "aws_s3_bucket" "example" {
  # Bucket Naming Rules
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html 
  bucket = random_string.bucket_name.id
}

output "random_bucket_name" {
  value = random_string.bucket_name.id
}
