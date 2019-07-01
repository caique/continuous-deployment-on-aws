variable "region" {
    type = "string"
    description = "The AWS region to use."
}
variable "shared_credentials_file" {
    type = "string"
    description = "Path to AWS credentials file"
}

provider "aws" {
    version                 = "~> 2.0"
    region                  = var.region
    shared_credentials_file = var.shared_credentials_file
}