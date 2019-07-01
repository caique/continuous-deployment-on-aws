# Continuous Deployment on Amazon Web Services

This project aims to configure a continuous deployment pipeline using Jenkins as CI tool and Kubernetes as cluster manager. All resources will be provisioned on Amazon Web Services.

### Requirements
- a valid Amazon Web Services account
- [Amazon Web Services CLI Tool](https://aws.amazon.com/cli/) (`aws-cli`)
- [Terraform CLI Tool](https://www.terraform.io/)

### Running
- Make sure that your AWS credentials are properly configured by running `aws configure`.
- Export variables:
    - `TF_VAR_region` as one of AWS regions (such as `us-east-1`)
    - `TF_VAR_shared_credentials_file` as the path to your AWS credentials (such as `$HOME/.aws/credentials`)
- Execute the following commands:
    - `make bootstrap` to generate the backend file
    - `terraform init jenkins` to download all modules and required dependencies
    - `terraform plan jenkins` to plan the execution on AWS
    - `terraform apply jenkins` to create all resources on AWS