terraform {

  required_version = "1.9.5"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      //version = "5.68.0"
      version = "5.91.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "1.32.0"
    }
  }
}
