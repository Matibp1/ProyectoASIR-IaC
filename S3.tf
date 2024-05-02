resource "aws_s3_bucket" "mi-Cubo-Proyecto-Mati" {
  bucket = "micubo619619"

  tags = {
    Name        = "micubo619619"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "object-nuevaCarpeta" {
  bucket       = "micubo619619"
  key    = "www/img/"
}

resource "aws_s3_object" "object-nuevo" {
  bucket = "micubo619619"
  key    = "www/index.php"
  source = "web/www/index.php"
}

resource "aws_s3_object" "object-nuevo2" {
  bucket = "micubo619619"
  key    = "www/estilo.css"
  source = "web/www/estilo.css"
}

resource "aws_s3_object" "object-nuevo3" {
  bucket = "micubo619619"
  key    = "www/web1.php"
  source = "web/www/web1.php"
}

resource "aws_s3_object" "object-nuevo4" {
  bucket = "micubo619619"
  key    = "www/img/fondo.png"
  source = "web/www/img/fondo.png"
}

