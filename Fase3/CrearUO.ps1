New-ADOrganizationalUnit -Name "Administradores-Parciales" -Path "DC=san-gva, DC=es"
New-ADOrganizationalUnit -Name "Administradors" -Path "OU=Administradores-Parciales,DC=san-gva, DC=es"
New-ADOrganizationalUnit -Name "Plantilla" -Path "OU=Administradores-Parciales,DC=san-gva, DC=es"
