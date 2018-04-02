variable "aws_region" {
  description = "AWS region on which we will setup the swarm cluster"
  default = "us-east-1"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default = "ami-7dbd1d00"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.micro"
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
  default = "35.168.203.14"
}

variable "worker1_public_ip" {
  default = "35.172.249.241"
}

variable "worker2_public_ip" {
  default = "18.233.41.155"
}
