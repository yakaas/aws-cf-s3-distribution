variable "region"           { default = "us-east-1" }
variable "bucket_name" 	    { default = "y-lookup-data2" }


provider "aws" { region = "${var.region}" }

resource "aws_iam_role" "iam-role" {
    name = "iam-role"
    #assume_role_policy = "${file("policies/assume-role-policy.json")}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cf-s3-policy" {
    name = "iam-role-policy"
    role = "${aws_iam_role.iam-role.id}"
    #policy = "${file("policies/iam-policy.json")}"
    policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "${aws_s3_bucket.bucket.arn}",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "bucket" {
    bucket = "${var.bucket_name}"
    policy = "${file("s3policy.json")}"
}
