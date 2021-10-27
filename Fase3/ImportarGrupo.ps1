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


