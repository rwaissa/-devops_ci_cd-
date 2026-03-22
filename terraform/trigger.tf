# Dá permissão para o S3 chamar a Lambda
resource "aws_lambda_permission" "permissao_s3" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mba_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.static_site.arn
}

# Configura o gatilho (Trigger)
resource "aws_s3_bucket_notification" "gatilho_s3" {
  bucket = aws_s3_bucket.static_site.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.mba_lambda.arn
    events              = ["s3:ObjectCreated:*"] # Dispara em qualquer upload
  }
  depends_on = [aws_lambda_permission.permissao_s3]
}