
param($a,$b)
$dominio=$a
$sufijo=$b
#En la variable dc componemos el nombre dominio y sufijo. Ejemplo: dc=smr,dc=local.

$dc="dc="+$dominio+",dc="+$sufijo

#
#Primero hay que comprobar si se tiene cargado el módulo Active Directory
#
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}

#
#Creación de los usuarios
#
#
#Preguntamos al usuario que nos indique el fichero csv
#
$fichero_csv=Read-Host "Introduce el fichero csv de los usuarios"

#El fichero csv tiene esta estructura (13 campos)
#Name:Surname:Surname2:NIF:Group:ContainerPath:Computer:Hability:DaysAccountExpire:HomeDrive:HomeDirectory:PerfilPath:ScriptPath

#
#Importamos el fichero csv (comando import-csv) y lo cargamos en la variable fichero_csv. 
#El delimitador usado en el csv es el : (separador de campos)
#
$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)
{
	#Componemos la ruta donde queda ubicado el objeto a crear (usuario). Ejemplo: OU=DepInformatica,dc=smr,dc=local
  
  $rutaContenedor = $linea_leida.ContainerPath+","+$dc 


  #Guardamos de manera segura la contraseña con el comando ConvertTo-SecureString.


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
    		-LogonWorkstations:$linea.Computer `
	    	-Description $linea_leida.Description `
    		-EmailAddress $email `
	    	-AccountPassword $passAccount `
    		-Enabled $true `
		    -CannotChangePassword $false `
    		-ChangePasswordAtLogon $true `
    		-Path $rutaContenedor

	
  #Asignar la cuenta de Usuario creada a un Grupo
	# Distingued Name CN=Nombre-grupo,ou=..,ou=..,dc=..,dc=...
	$cnGrpAccount="Cn="+$linea_leida.Group+","+$rutaContenedor
	Add-ADGroupMember -Identity $cnGrpAccount -Members $nameShort
	
	

}

