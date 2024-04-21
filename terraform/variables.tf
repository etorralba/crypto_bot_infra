variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "instance_type" {}
variable "ami" {}
variable "environment" {
  default = "dev"
}
variable "project" {
  default = "crypto_bot"
}
variable "organization" {
  default = "etorralba"
}