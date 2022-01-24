#!/bin/bash

cd /
mkdir /proyectos
mkdir /proyectos/src
mkdir /proyectos/pruebas


adduser usu_sinformatico
groupadd g_sinformatico
adduser usu_sinformatico g_sinformatico


adduser usu_desarrollo
groupadd g_desarrollo
adduser usu_desarrollo g_desarrollo


adduser usu_explotacion
groupadd g_explotacion
adduser usu_explotacion g_explotacion

setfacl -d -m g:g_sinformacion:7 /proyectos

cd /proyectos

setfacl -d -m g:g_desarrollo:7 src
setfacl -d -m g:g_explotacion:5 src

setfacl -d -m g:g_explotacion:7 pruebas



touch Proyecto1.pdf
touch Proyecto2.pdf

cd pruebas

touch Prueba1.pdf
touch Prueba2.pdf

cd ../src

touch app1.sh
touch app2.sh



