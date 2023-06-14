# CREATING S3 Policy 

resource "aws_iam_policy" "S3_Policy" {
  name        = "S3-Bucket-Access-Policy"
  description = "Provides permission to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
          "s3-object-lambda:*"
        ]
        Effect = "Allow"
        Resource = [

        "arn:aws:s3:::s3_policy/*"]
      }

    ]
  })
}

# CREATING IAM ROLE

resource "aws_iam_role" "Three-Tier-Role" {
  name = "threetierrole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# CREATING IAM POLICY

resource "aws_iam_policy_attachment" "Policy_Attech" {
  name       = "policy_attachment"
  roles      = [aws_iam_role.Three-Tier-Role.name]
  policy_arn = aws_iam_policy.S3_Policy.arn
}

resource "aws_iam_instance_profile" "Private_Profile" {
  name = "private_profile"
  role = aws_iam_role.Three-Tier-Role.name
}



##############################################################################################################################

# CREATING EC2 INSTANCE

# INSTANCE - 1
resource "aws_instance" "Private-Instance-1" {
  ami                    = data.aws_ami.aws_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.Private_EC2_Security_Group_id
  iam_instance_profile   = aws_iam_instance_profile.Private_Profile.name
  subnet_id              = var.Private_Subnet_AZ1_id
  tags = {
    Name = "Terraform-Instance"
  }

}

# INSTANCE - 2
resource "aws_instance" "Public-Instance-2" {
  ami                    = data.aws_ami.aws_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.Public_EC2_Security_Group_id
  iam_instance_profile   = aws_iam_instance_profile.Private_Profile.name
  subnet_id              = var.Public_Subnet_AZ1_id
  tags = {
    Name = "Terraform-Instance"
  }

}

##########################################################################################################################################################


