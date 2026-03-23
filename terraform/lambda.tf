# Usamos o código da Lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_content = "def handler(event, context): print('Processando arquivo do MBA!'); return 'Sucesso'"
  source_content_filename = "index.py"
  output_path = "lambda_function.zip"
}

# Criamos a Lambda usando a Role padrão do Lab (LabRole)
resource "aws_lambda_function" "process_files" {
  filename      = "lambda_function.zip"
  function_name = "mba_process_s3_raissa"
  # O ARN abaixo é o padrão do AWS Academy, ele permite que a lambda rode.
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  handler       = "index.handler"
  runtime       = "python3.9"
}

data "aws_caller_identity" "current" {}