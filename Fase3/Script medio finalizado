
#----------------Funcion Submenu  -------------#
function CrearAdministrador { 
$dominio=Read-Host 'Introduce dominio sin sufijo'
$sufijo=Read-Host 'Introduce sufijo del dominio'

$dc="dc="+$dominio+",dc="+$sufijo
if (!(Get-Module -Name ActiveDirectory))
{
  Import-Module ActiveDirectory 

}

  $fichero_csv=Read-Host "Introduce el fichero csv de los usuarios"
$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)

{  $rutaContenedor = $linea_leida.ContainerPath+","+$dc 

 $passAccount=ConvertTo-SecureString $linea_leida.AcountPassword -AsPlainText -force
	
	$name=$linea_leida.Name
	$nameShort=$linea_leida.Name+'.'+$linea_leida.Surname
	$Surnames=$linea_leida.Surname+' '+$linea_leida.Surname2
	$nameLarge=$linea_leida.Name+' '+$linea_leida.Surname+' '+$linea_leida.Surname2



	New-ADUser `
    		-SamAccountName $nameShort `
    		-UserPrincipalName $nameShort `
    		-Name $nameShort `
		    -Surname $Surnames `
    		-DisplayName $nameLarge `
    		-GivenName $name `
	    	-Description $linea_leida.Description `
	    	-AccountPassword $passAccount `
    		-Enabled $true `
		    -CannotChangePassword $false `
    		-ChangePasswordAtLogon $true `
    		-Path $rutaContenedor

	
	$cnGrpAccount="Cn="+$linea_leida.Group+","+$rutaContenedor
	Add-ADGroupMember -Identity $cnGrpAccount -Members $nameShort


}




}


function CrearGrupo {

if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}
$fichero_csv=Read-Host "Introduce el fichero para crear los grupos"

$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)

{

$Grupo=$linea_leida.GroupAdmin

if (!(Get-ADGroup -filter { name -eq $Grupo })) 
{

 New-ADGroup -Name $Grupo -GroupCategory Security -GroupScope Global -Path "OU=Administradores,OU=Administradores-Parciales,DC=san-gva,DC=es" 

 
 }



}




foreach($linea_leida in $fichero_csv_importado)
{
Write-Host $linea_leida.NameGroup
	Add-ADGroupMember -Identity $linea_leida.NameGroup -Members $linea_leida.GroupAdmin
}

}




function CrearUo {


New-ADOrganizationalUnit -Name "Administradores-Parciales" -Path "DC=san-gva, DC=es"
New-ADOrganizationalUnit -Name "Administradors" -Path "OU=Administradores-Parciales,DC=san-gva, DC=es"
New-ADOrganizationalUnit -Name "Plantilla" -Path "OU=Administradores-Parciales,DC=san-gva, DC=es"

}

function eliminarplantilla {

     $Usuario = Read-Host "Introduce el nombre de usuario a borrar"
Write-Host $Usuario

Remove-ADUser -Identity "CN=$Usuario, OU=Administradores,OU=Administradores-Parciales,DC=san-gva,DC=es"
}


function mostrar_Submenu
{
     param (
           [string]$Titulo = 'Submenu.....'
     )
     Clear-Host 
     Write-Host "================ $ Submenu Gestion Objetos dominio principal================"
    
     Write-Host "1: Crear UO"
     Write-Host "2: Crear Administradores parciales"
     Write-Host "3: Crear Grupos."
     Write-Host "s: Ir al menu principal"
do
{
     $input = Read-Host "Por favor, pulse una opcion"
     switch ($input)
     {
           '1' {
                #Creacion de UO

                CrearUo

                return
           } '2' {
                #Creacion de administador   

                CrearAdministrador

                return
           } '3' {
               #Creacion de Grupo'

               CrearGrupo

                return
           } 's' {
               #Vuelta al menu principal'
            mostrarMenu
           }

        }           
}
until ($input -eq 'q')
}


function mostrar_Submenu2
{
     param (
           [string]$Titulo = 'Submenu.....'
     )
     Clear-Host 
     Write-Host "================ $ Submenu Gestion de plantillas de admins parciales================"
    
     Write-Host "1: Crear plantillas"
     Write-Host "2: Listar plantillas"
     Write-Host "3: Eliminar plantillas."
     Write-Host "s: Ir al menu principal"
do
{
     $input = Read-Host "Por favor, pulse una opcion"
     switch ($input)
     {
           '1' {
                #Creacion plantillas

               

                return
           } '2' {
                #Listar plantillas   

                dsquery user -name _*

                return
           } '3' {
               #Eliminar plantillas

             
               eliminarplantilla

                return
           } 's' {
               #Vuelta al menu principal
            mostrarMenu
           }

        }           
}
until ($input -eq 'q')
}



#Función que nos muestra un menú por pantalla con 3 opciones, donde una de ellas es para acceder
# a un submenú) y una última para salir del mismo.

function mostrarMenu 
{ 
     param ( 
           [string]$Titulo = 'Menu principal -Fase3' 
     ) 
     Clear-Host 
     Write-Host "================ $ Menu principal - Fase 3================" 
      
     
     Write-Host "1. Gestion de administradores parciales" 
     Write-Host "2. Gestion de plantillas de admins parciales"
     Write-Host "s. Presiona 's' para salir" 
}

do 
{ 
     mostrarMenu 
     $input = Read-Host "Elegir una Opción" 
     switch ($input) 
     { 
           '1' { 
                Clear-Host  
                #Gestion de administradores principales

                mostrar_Submenu

                pause
           } '2' { 
                Clear-Host  
                #Gestion de administradores parciales

                mostrar_Submenu2

                pause

         
           } '3' {  
                
           } 's' {
                #Saliendo del script...'
                return 
           }  
     } 
     pause 
} 
until ($input -eq 's')
