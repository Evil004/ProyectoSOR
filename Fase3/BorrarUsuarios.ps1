$Usuario = Read-Host "Introduce el nombre de usuario a borrar"
Write-Host $Usuario

Remove-ADUser -Identity "CN=$Usuario, OU=Administradores,OU=Administradores-Parciales,DC=san-gva,DC=es"
