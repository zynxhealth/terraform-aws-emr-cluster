#
# Gets the latest Amazon Linux AMI for the default region that complies to the
# requirements of EMR custom AMI
#
data "aws_ami" "default" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "is-public"
    values = ["true"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
}
