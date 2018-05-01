variable "aws_region" {
  description = "AWS region on which we will setup the swarm cluster"
  default = "us-east-1"
}

variable "ami-master" {
  description = "Amazon Linux AMI"
  default = "ami-7974cb06"
}

variable "ami-worker1" {
  description = "Amazon Linux AMI"
  default = "ami-4f73cc30"
}

variable "ami-worker2" {
  description = "Amazon Linux AMI"
  default = "ami-f174cb8e"
}

variable "ami-web" {
  description = "Amazon Linux AMI"
  default = "ami-372f9148"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.medium"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "id_rsa.pub"
}


variable "key_name" {
  description = "SSH Public Key name"
  default = "aws_terraform"
}


variable "bootstrap_path" {
  description = "Script to install Docker Engine"
  default = "install-docker.sh"
}

variable "master_public_ip" {
  default = "18.208.27.151"
}

variable "worker1_public_ip" {
  default = "18.234.17.242"
}

variable "worker2_public_ip" {
  default = "35.174.145.65"
}

variable "web_public_ip" {
  default = "35.174.79.128"
}
