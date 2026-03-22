# 1. Cria o ZIP do código da Lambda
data "archive_file" "lambda_code" {
  type        = "zip"
  source_content = "def handler(event, context): print('Arquivo processado!'); return {'status': 200}"
  source_content_filename = "index.py"
  output_path = "lambda_function.zip"
}

# 2. Função Lambda
resource "aws_lambda_function" "process_files" {
  filename      = "lambda_function.zip"
  function_name = "mba_process_s3_raissa"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"

  # Destination: O que acontece se a execução falhar?
  # Nota: Em um lab, o SNS pode precisar de permissões extras
}

# 3. Trigger: S3 invocando a Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_files.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.static_site.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.static_site.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_files.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_s3]
}

# Role básica para a Lambda (Obrigatório)
resource "aws_iam_role" "lambda_role" {
  name = "mba_lambda_role_raissa"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}