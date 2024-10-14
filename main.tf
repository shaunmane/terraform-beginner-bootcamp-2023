terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "ExamPro"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  #  cloud {
  #    organization = "My_First_Terra_"
  #    workspaces {
  #      name = "terra-house-1"
  #    }
  #  }
}

provider "terratowns" {
  endpoint  = "http://localhost:4567/api"
  user_uuid = "e328f4ab-b99f-421c-84c9-4ccea042c7d1"
  token     = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

#module "terrahouse_aws" {
#   source = "./modules/terrahouse_aws"
#   user_uuid = var.user_uuid
#   bucket_name = var.bucket_name
#   index_html_filepath = var.index_html_filepath
#   error_html_filepath = var.error_html_filepath
#   content_version = var.content_version
#   assets_path = var.assets_path
#}

resource "terratowns_home" "home" {
  name = "Porsche Singer"
  description = <<DESCRIPTION
In June 2022, Singer unveiled the Turbo Study, 
their first turbocharged model to celebrate the Porsche 930 Turbo based on a 964 chassis. 
It features a 3.8L twin turbocharged, 
intercooled flat-six producing either 450 in the standard trim or 510 HP in the sports focused trim.
Power is sent through a 6-speed manual transmission and rear-wheel-drive drivetrain. 
The suspension is touring-focused, and it features carbon-ceramic brakes.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "3fdq3gz.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1
}