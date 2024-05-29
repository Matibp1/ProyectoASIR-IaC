#!/bin/bash

# Actualizar 
sudo apt-get update

# Instalar Apache y PHP
echo "Instalando Apache y PHP..."
sudo apt-get install -y apache2 php

# Iniciar y habilitar Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Instalar AWS CLI
sudo apt-get install -y awscli

# Instalar SQL
sudo apt install -y mysql-server 

#realizar peticiones
sudo apt install siege

# #Monta disco EFS
apt-get install -y nfs-common
mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1 ${aws_efs_file_system.mi_efs.dns_name}:/ /mnt/efs


# Crear página web de ejemplo
echo "<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <link rel=\"stylesheet\" href=\"estilo.css\">
    <title>Tu sitio Web</title>
</head>
<body>
<header>
    <nav>
        <ul>
            <li><a href=\"index.html\">Inicio</a></li>
            <li><a href=\"#\">Acerca de</a></li>
            <li><a href=\"#\">Servicios</a></li>
            <li><a href=\"#\">Contacto</a></li>
        </ul>
    </nav>
</header>
<main>
    <h1>Bienvenido a tu sitio web</h1>
    <a href=\"web1.html\"><button class=\"styled-button\">Proyecto de Mati</button></a>
</main>
</body>
</html>" | sudo tee /var/www/html/index.html



#Web1

echo "<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="estilo.css">
    <title>Tu sitio Web</title>
</head>
<body>
<header>
    <nav>
        <ul>
            <li><a href="index.html">Inicio</a></li>
            <li><a href="#">Acerca de</a></li>
            <li><a href="#">Servicios</a></li>
            <li><a href="#">Contacto</a></li>
        </ul>
    </nav>
</header>
<main>
    <h1 >Apruebame :)</h1> 
</main>

</body>
</html>" | sudo tee /var/www/html/web1.html

#CSS

echo "body {
    background-image: url('https://i.ibb.co/FgNCC42/fondo.png');
    background-size: cover;
    margin: 0;
    padding: 0;
}

header {
    width: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    position: fixed;
    top: 0;
    left: 0;
    z-index: 1000;
}

nav ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    display: flex; /* Hace el menú horizontal */
    justify-content: center; /* Centra los elementos del menú */
}

nav ul li {
    margin: 0 20px; /* Mayor espaciado entre palabras del menú */
}

nav ul li a {
    color: #fff;
    text-decoration: none;
    font-size: 2rem;
}

main {
    display: flex;
    flex-direction: column; /* Alinea los elementos en columna */
    align-items: center; /* Centra horizontalmente los elementos */
    height: calc(100vh - 50px);
    justify-content: center; /* Centra verticalmente los elementos */
}


h1 {
    text-align: center;
    font-size: 4rem;
    color: #000000;
    text-shadow: 0 0 3px #fff, 0 0 20px #fff, 0 0 40px #0ff, 0 0 60px #0ff, 0 0 80px #0ff, 0 0 100px #0ff, 0 0 150px #0ff;
}

.styled-button {
    background-color: #4CAF50;
    color: #fff;
    text-decoration: none;
    padding: 10px 20px;
    border-radius: 5px;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
    margin-top: 20px; /* Espacio entre el h1 y el botón */
}

.styled-button:hover {
    background-color: #45a049;
} " | sudo tee /var/www/html/estilo.css

sudo systemctl restart apache2