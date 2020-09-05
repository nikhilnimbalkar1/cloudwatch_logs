locals {
  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}


resource "aws_iam_instance_profile" "cw_role_instanceprofile" {
  name = "cw_role_instanceprofile"
  role = aws_iam_role.cw_role.name
}


resource "aws_iam_role_policy_attachment" "cw_att" {
  count = length(local.role_policy_arns)
  role       = aws_iam_role.cw_role.name
  policy_arn = element(local.role_policy_arns, count.index)
}

resource "aws_iam_role_policy" "cw_iam_rolepolicy" {
  name = "cw_iam_rolepolicy"
  role = aws_iam_role.cw_role.id
  policy =jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}


resource "aws_iam_role" "cw_role" {
  name = "cw_role"
  path = "/"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow"
        }
      ]
    }
  )
}



