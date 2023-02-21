resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-backup"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${var.irsa_oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.k8s_namespace}:platz-backup"]
    }

    principals {
      type        = "Federated"
      identifiers = [var.irsa_oidc_arn]
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.name_prefix}-backup"
  policy = data.aws_iam_policy_document.role_policy.json
}

locals {
  bucket_path = var.bucket_prefix == "" ? "*" : "${var.bucket_prefix}/*"
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/${local.bucket_path}",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
