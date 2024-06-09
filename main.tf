resource "aws_s3_bucket" "this" {
  bucket = "${var.env}-fullstack-20242-demo-bucket"
}