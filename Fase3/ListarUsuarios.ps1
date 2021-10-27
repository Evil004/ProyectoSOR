Get-ADUser -Filter * -SearchBase "OU=Administradores,OU=Administradores-Parciales,DC=san-gva,DC=es" | Ft Name,Enabled
