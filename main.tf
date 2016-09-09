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
    #policy = "${file("s3-policy.json")}"
    policy = <<EOF
{
	"Version": "2008-10-17",
	"Id": "Policy1425281770533",
	"Statement": [
		{
			"Sid": "Stmt1425281765688",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::107630771604:user/s3-copy"
			},
			"Action": "s3:*",
			"Resource": "arn:aws:s3:::${var.bucket_name}/*"
		},
		{
			"Sid": "Stmt1425281765688",
			"Effect": "Allow",
			"Principal": {
				"AWS": "${aws_iam_role.iam-role.arn}"
			},
			"Action": ["s3:Get*", "s3:List*"],
			"Resource": "arn:aws:s3:::${var.bucket_name}/*"
		},
		{
			"Sid": "Stmt1425281765688",
			"Effect": "Allow",
			"Principal": {
				"AWS": "${aws_iam_role.iam-role.arn}"
			},
			"Action": ["s3:Get*", "s3:List*"],
			"Resource": "arn:aws:s3:::${var.bucket_name}/*"
		}        
	]
}
EOF
}
