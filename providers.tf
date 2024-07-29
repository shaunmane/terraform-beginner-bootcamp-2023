terraform {
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "ExamPro"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  cloud {
    organization = "My_First_Terra_"
    workspaces {
      name = "terra-house-1"
    }
  }
  required_providers {
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