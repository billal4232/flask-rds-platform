resource "aws_acm_certificate" "cert" {
  domain_name       = var.subdomain
  validation_method = "DNS"
  #provider = aws.us_east_1

  tags = {
    Name = "${var.project_name}-acm_cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}