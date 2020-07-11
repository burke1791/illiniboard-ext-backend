
variable "region" {
  default = "us-east-1"
}

variable "amis" {
  default = {
    "us-east-1" = "ami-0ab9011d6e9ec01e4" # custom and private AMI with SQL Server 2019 installed and configured for remote access
  }
}

variable "key_pair" {
  default = "burke+02-mbp" # manually generated key-pair
}

variable "s3_bucket_lambda" {}
variable "app_version" {}

variable "lambda_runtime" {
  default = "nodejs12.x"
}

variable "lambda_subnet_ids" {
  default = [
    "subnet-c069be9f"
  ]
}

variable "lambda_security_group_ids" {
  default = [
    "sg-0aec2cd279067317a"
  ]
}

variable "lambda_env" {}