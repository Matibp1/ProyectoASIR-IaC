#Espacio para los S3 (Buckets)

resource "aws_s3_bucket" "mi-Cubo-Proyecto-Mati" {
  bucket = var.S3 # Nombre del bucket de S3 definido en variable, tiene que ser unico 

  tags = {
    Name        = var.S3 # Etiqueta con el nombre del bucket
    Environment = "Dev"
  }
}

# Creación de un objeto en S3 para una nueva carpeta
resource "aws_s3_object" "object-nuevaCarpeta" {
  bucket     = aws_s3_bucket.mi-Cubo-Proyecto-Mati.id  # ID del bucket de S3
  key        = "www/img/"  #Ruta del fichero
  depends_on = [aws_s3_bucket.mi-Cubo-Proyecto-Mati] #Depende de la creacion del S3 para crearlo
}
# Creación de un objeto en S3 para una nueva archivo
resource "aws_s3_object" "object-nuevo" {
  bucket     = aws_s3_bucket.mi-Cubo-Proyecto-Mati.id
  key        = "www/index.html"
  source     = "web/www/index.html"
  depends_on = [aws_s3_bucket.mi-Cubo-Proyecto-Mati]
}
# Creación de un objeto en S3 para una nueva archivo
resource "aws_s3_object" "object-nuevo2" {
  bucket     = aws_s3_bucket.mi-Cubo-Proyecto-Mati.id
  key        = "www/estilo.css"
  source     = "web/www/estilo.css"
  depends_on = [aws_s3_bucket.mi-Cubo-Proyecto-Mati]
}
# Creación de un objeto en S3 para una nueva archivo
resource "aws_s3_object" "object-nuevo3" {
  bucket     = aws_s3_bucket.mi-Cubo-Proyecto-Mati.id
  key        = "www/web1.html"
  source     = "web/www/web1.html"
  depends_on = [aws_s3_bucket.mi-Cubo-Proyecto-Mati]
}
# Creación de un objeto en S3 para una nueva archivo
resource "aws_s3_object" "object-nuevo4" {
  bucket     = aws_s3_bucket.mi-Cubo-Proyecto-Mati.id
  key        = "www/img/fondo.png"
  source     = "web/www/img/fondo.png"
  depends_on = [aws_s3_bucket.mi-Cubo-Proyecto-Mati]
}


