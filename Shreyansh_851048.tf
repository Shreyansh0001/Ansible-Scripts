#setting up the provider as aws
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

#creating the resources here
resource "aws_instance" "server_resource"
{
    ami = "${lookup(var.instance_amis,var.aws_region, count.index)}"
    instance_type = "t2.micro"
    count = "${var.instance_count == "multi"? 1 : 2}"
}

resource "aws_s3_bucket" "Storage"
{
    bucket ="s3-leonc-bucket"
    region ="${var.aws_region}"
}


#output 
output "success" {
  value = "Successfully created the instance"
}

#setting up the provisioner
provisioner "remote-exec"
{  
    inline = [
    "sudo apt update", 
    "sudo apt upgrade",
    "sudo apt-get install enginix"
    ]
    connection {
        userid = "${var.aws_access_key}"
        secret_key = "${var.aws_secret_key}"
    }
}


#variable part
variable "aws_access_key" {}
variable "aws_secret_key" {}
#   Type the following command in terminal to fetch the access key and the secret key
#   export TF_VAR_access_key = aws_access_key
#   export TF_VAR_secret_key = aws_secret_key

variable "aws_region"
{
    default = "us-east-1"
}
variable "instance_count"
{
    default = "multi"
}


#creating a map for the ami mapping
variable "instance_amis"{
    "us-east-1" = "ami-b86758998"
    "sa-south-1" = "ami-26754675"
    "us-north-2" = "ami-648764a66"
} 
