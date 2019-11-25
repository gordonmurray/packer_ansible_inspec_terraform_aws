# Packer, Ansible, Inspec and Terraform on AWS

A working demo application created using Packer, Ansible, Inspec and Terraform, deployed to AWS.

The purpose of this demo app is to show a working example of these tools working together.

The end result is a simple Hello World script running on an EC2 instance on AWS.

* [Packer](https://www.packer.io/) is used to create an Amazon Machine Image (AMI). An AMI is like a prepared EC2 instance that has not been started up yet.

* [Ansible](https://www.ansible.com/) is used within Packer to install some neccessary services while Packer is building the image.

* [Inspec](https://www.inspec.io/) is used within Packer also, to perform some verification steps to make sure Packer and Ansible have created the Image as expected.

* [Terraform](https://www.terraform.io/) is used to create the minimum AWS infrastructure we need. It will use the Image created by Packer and create a small running EC2 instance within a new VPC.

## A short video of the Packer, Ansible and Inspec stage

[![asciicast](https://asciinema.org/a/aO3KtTeRAmQNJy5QZ2UJRAv0Z.svg)](https://asciinema.org/a/aO3KtTeRAmQNJy5QZ2UJRAv0Z)

## A short video of the Terraform stage

[![asciicast](https://asciinema.org/a/282235.svg)](https://asciinema.org/a/282235)

## Before you begin, You will need

* You will need an AWS account and your [AWS account ID](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html#FindingYourAWSId)
* [Packer](https://www.packer.io/) installed locally
* [Terraform](https://www.terraform.io/) installed locally
* [Inspec](https://www.inspec.io/) installed locally

## Create an AWS user

Use the following steps to create a new user in your AWS account and give it permission to create EC2 instances and Route53 zones. This will be used by Packer and Terraform to create an AMI and an EC2 instance.

* `aws iam create-user --user-name example`
* `aws iam create-access-key --user-name example`
* ( Make sure to save the AccessKeyId and SecretAccessKey from the output)
* `aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --user-name example`
* `aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --user-name example`
* Create a file at ~/.aws/credentials with the following content: 

```
[example]
aws_access_key_id = Your_AccessKeyId
aws_secret_access_key = Your_SecretAccessKey
```
* Copy your public key so Terraform can use it to create a .pem file which you can use to SSH in to the EC2 instance if needed: `cat ~/.ssh/id_rsa.pub > ../terraform/files/id_rsa.pub`

## Usage

1. Clone this repo
2. Add your AWS Account ID to terraform/terraform.tfvars
3. Validate Packer using : `packer validate -var-file=packer/variables.json packer/server.json`
4. Build the AMI with Packer using : `packer build -var-file=packer/variables.json packer/server.json`
5. Deploy the image with Terraform using:
* `cd /terraform`
* `terraform init`
* `terraform apply`

## Clean up

### Terraform destroy

`terraform destroy`

### Delete the AWS IAM user

`aws iam  delete-user --user-name example`

### Delete the AMI created by Packer

First, get the AMI ID value using:

`aws ec2 describe-images --filters "Name=tag:Name,Values=example.com" --profile=example --region=eu-west-1 --query 'Images[*].{ID:ImageId}'`

### Then delete the AMI

`aws ec2 deregister-image --image-id ami-<value>`

