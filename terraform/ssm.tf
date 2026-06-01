resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.project_name}/db_host"
  type  = "String"
  value = aws_db_instance.main.address

  tags = {
    Name = "${var.project_name}-db_host"
  }
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.project_name}/db_port"
  type  = "String"
  value = "5432"

  tags = {
    Name = "${var.project_name}-db_port"
  }
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.project_name}/db_name"
  type  = "String"
  value = var.db_name

  tags = {
    Name = "${var.project_name}-db_name"
  }
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.project_name}/db_username"
  type  = "String"
  value = var.db_username

  tags = {
    Name = "${var.project_name}-db_username"
  }
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.project_name}/db_password"
  type  = "SecureString"
  value = var.db_password

  tags = {
    Name = "${var.project_name}-db_password"
  }
}
resource "aws_ssm_parameter" "api_key" {
  name  = "/${var.project_name}/api_key"
  type  = "SecureString"
  value = var.api_key

  tags = {
    Name = "${var.project_name}-api_key"
  }
}