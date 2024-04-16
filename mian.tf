provider "aws" {
  region = "us-east-1" # Modify according to your region
}

resource "aws_iam_policy" "example_policy" {
  name        = "example-policy"
  description = "Example policy for Terraform"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "example_role" {
  name = "example-role"
  
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example_attachment_${random_integer}" {
  role       = aws_iam_role.example_role.name
  policy_arn = aws_iam_policy.example_policy.arn
}

resource "aws_iam_role_policy_attachment" "example_attachment_${random_integer}" {
  role       = aws_iam_role.example_role.name
  policy_arn = aws_iam_policy.example_policy.arn
  depends_on = [aws_instance.example_instance]
}

resource "aws_iam_role_policy_attachment" "example_attachment_${random_integer}" {
  role       = aws_iam_role.example_role.name
  policy_arn = aws_iam_policy.example_policy.arn
  depends_on = [aws_instance.example_instance]
}

resource "aws_instance" "example_instance" {
  count         = 2
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_role.example_role.name
  
  tags = {
    Name = "example-instance-${count.index}"
  }
}
