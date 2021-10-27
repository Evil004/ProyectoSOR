
$dominio="san-gva"
$sufijo="es"
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
$fichero_csv=Read-Host "Introduce el fichero csv de las plantillas"

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
  Write-Host $linea_leida.ContainerPath
  $rutaContenedor = $linea_leida.ContainerPath+","+$dc 

  Write-Host $rutaContenedor

  #Guardamos de manera segura la contraseña con el comando ConvertTo-SecureString.


  $passAccount=ConvertTo-SecureString $linea_leida.AcountPassword -AsPlainText -force
	
	$name=$linea_leida.Name



	New-ADUser `
    		-SamAccountName $name `
    		-UserPrincipalName $name `
    		-Name $name `
    		-DisplayName $name `
    		-GivenName $name `
	    	-Description $linea_leida.Description `
	    	-AccountPassword $passAccount `
    		-Enabled $false `
    		-ChangePasswordAtLogon $true `
    		-Path $rutaContenedor

	
  #Asignar la cuenta de Usuario creada a un Grupo
	# Distingued Name CN=Nombre-grupo,ou=..,ou=..,dc=..,dc=...
	$cnGrpAccount="Cn="+$linea_leida.Group+","+$linea_leida.GroupPath
	Add-ADGroupMember -Identity $cnGrpAccount -Members $name
	
	

}
