terraform {
  required_version = "> 1.0"
}

// define variables

variable "instance_name" {
  type = string
}

variable "instance_name_fqdn" {
  type = string
}

variable "instance" {
  type = string
}

variable "ansible_playbook_name" {
  type = string
}

variable "region" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_pub_key_path" {
  type = string
}

variable "ssh_pri_key_path" {
  type = string
}

variable "amis" {
 type = map

 default = {
   eu-west-1 = "ami-0c1aea1d6f3bdd76b"
   eu-west-2 = "ami-00f314baca4922fe3"
   eu-west-3 = "ami-021a18be6333356c7"
 }
}

variable "ami" {
  type = string
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "tfstate_bucket" {}
variable "tfstate_lock" {}
variable "tfstate_bucket_name" {
  type = string
}
variable "tfstate_lock_name" {
  type = string
}
locals {
  tfstate_bucket_name = "${var.tfstate_bucket}"
  tfstate_lock_name = "${var.tfstate_lock}"
}

