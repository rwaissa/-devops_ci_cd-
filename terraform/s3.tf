# Criação do Bucket S3
resource "aws_s3_bucket" "static_site" {
  bucket = "mba-devops-raissa-2026" # Mude se este nome já existir, precisa ser único!
}

# Configura o Bucket para Hospedagem de Site
resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }
}

# Remove o bloqueio de acesso público (Necessário para sites estáticos)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}