terraform {
  required_version = ">= 1.11.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.91.0"
    }
  }

  backend "s3" {
    bucket         = "tf-states-free-tier" 
    key            = "infra.tfstate"   
    region         = "eu-west-1"                 
    encrypt        = true                        
    dynamodb_table = "terraform-lock-table"      
  }
}


provider "aws" {
  region = "eu-west-1" 
}