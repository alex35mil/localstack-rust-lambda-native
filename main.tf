provider "aws" {
  region = "us-west-2"

  skip_credentials_validation = true
  skip_metadata_api_check     = true

  endpoints {
    lambda = "http://localhost:4566"
    iam    = "http://localhost:4566"
    sts    = "http://localhost:4566"
  }
}

locals {
  fn_archive = "${path.module}/target/lambda/hello-world-fn/bootstrap.zip"
}

resource "aws_lambda_function" "hello_world" {
  function_name    = "hello-world-fn"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "bootstrap"
  filename         = local.fn_archive
  source_code_hash = filebase64sha256(local.fn_archive)
  runtime          = "provided.al2023"
  architectures    = ["arm64"]

  environment {
    variables = {
      RUST_BACKTRACE = "1"
    }
  }
}

resource "aws_lambda_function_url" "hello_world_url" {
  function_name      = aws_lambda_function.hello_world.function_name
  authorization_type = "NONE"
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "function_url" {
  description = "URL of the Lambda function"
  value       = aws_lambda_function_url.hello_world_url.function_url
}
