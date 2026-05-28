resource "aws_s3_bucket" "project_bucket" {
  bucket = "flask-rds-s3-bucket"

  tags = {
    Name = "${var.project_name}-bucket"
  }
}
resource "terraform_data" "upload_app" {
  provisioner "local-exec" {
    command = "aws s3 cp ../app/app.py s3://${aws_s3_bucket.project_bucket.bucket}/app.py --profile ${var.aws_profile}"
  }

  depends_on = [aws_s3_bucket.project_bucket]
}