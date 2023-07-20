terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.7.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}


###############
# Data blocks
###############

# Filter and retrieve the latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

data "template_cloudinit_config" "user_data" {
  part {
    content_type = "text/x-shellscript"
    content      = file("./shell/install_cw_agent.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("./shell/install_cw_agent.sh")
  }
}

###############
# Resource blocks
###############

resource "aws_instance" "TerraformSSMEnabledInstance" {
  ami                  = data.aws_ami.al2023.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.TerraformSSMEnabledInstanceProfile.name

  user_data = data.template_cloudinit_config.user_data.rendered

  tags = {
    Name  = var.instance_name
    Owner = var.owner
  }
}

resource "aws_iam_instance_profile" "TerraformSSMEnabledInstanceProfile" {
  name = "SSMEnabledInstanceProfile"
  role = aws_iam_role.TerraformSSMEnabledInstanceRole.name
}

resource "aws_iam_role" "TerraformSSMEnabledInstanceRole" {
  name = "TerraformSSMEnabledInstanceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = var.owner
  }
}

resource "aws_iam_role_policy_attachment" "ManagedAmazonSSMFullAccess" {
  role       = aws_iam_role.TerraformSSMEnabledInstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  depends_on = [aws_iam_role.TerraformSSMEnabledInstanceRole]
}

resource "aws_iam_role_policy_attachment" "ManagedAmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.TerraformSSMEnabledInstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  depends_on = [aws_iam_role.TerraformSSMEnabledInstanceRole]
}
