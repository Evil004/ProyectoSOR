
#----------------Funcion Submenu  -------------#
function CrearAdministradoresCSV { 
    $dominio=Read-Host 'Introduce dominio sin sufijo'
    $sufijo=Read-Host 'Introduce sufijo del dominio'

    $dc="dc="+$dominio+",dc="+$sufijo
    if (!(Get-Module -Name ActiveDirectory))
    {
    Import-Module ActiveDirectory 

    }

    $fichero_csv=Read-Host "Introduce el fichero csv de los usuarios"
    $fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
    foreach($linea_leida in $fichero_csv_importado){  
            
        $rutaContenedor = $linea_leida.ContainerPath+","+$dc 
        Write-Host $rutaContenedor
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
    foreach($linea_leida in $fichero_csv_importado){

        $Grupo=$linea_leida.GroupAdmin

        if (!(Get-ADGroup -filter { name -eq $Grupo })) 
        {

            New-ADGroup -Name $Grupo -GroupCategory Security -GroupScope Global -Path "OU=Administradores,OU=Administradores-Parciales,DC=san-gva,DC=es" 

        }


        }


        foreach($linea_leida in $fichero_csv_importado)
        {
            Add-ADGroupMember -Identity $linea_leida.NameGroup -Members $linea_leida.GroupAdmin
        }

}




function CrearUo {

    New-ADOrganizationalUnit -Name "Administradores-Parciales" -Path "DC=san-gva, DC=es"
    New-ADOrganizationalUnit -Name "Administradores" -Path "OU=Administradores-Parciales,DC=san-gva, DC=es"
    New-ADOrganizationalUnit -Name "Plantillas" -Path "OU=Administradores-Parciales,DC=san-gva, DC=es"

}

function CrearPlantillas{

    $dominio="san-gva"
    $sufijo="es"
    #En la variable dc componemos el nombre dominio y sufijo. Ejemplo: dc=smr,dc=local.
    
    $dc="DC="+$dominio+",DC="+$sufijo
    
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
      
      $rutaContenedor = $linea_leida.ContainerPath+","+$dc 
    
    
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
        #$cnGrpAccount="CN="+$linea_leida.Group+","+$linea_leida.GroupPath
        Add-ADGroupMember -Identity $linea_leida.Group -Members $name
        
        
    
    }

}

function eliminarplantilla {

    $Usuario = Read-Host "Introduce el nombre de usuario a borrar"
    Write-Host $Usuario

    Remove-ADUser -Identity $Usuario
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
    $Option = Read-Host "Por favor, introduzca una opcion"
    switch ($Option)
    {
            '1' {
                #Creacion de UO
                Clear-Host
                CrearUo
                Write-Host "Se han creado las UOs correctamente"
                
                return
            } '2' {
                #Creacion de administador   
                Clear-Host
                CrearAdministradoresCSV
                Write-Host "Se han creado los administradores correctamente"
                return
            } '3' {
               #Creacion de Grupo'
               Clear-Host
               CrearGrupo
               Write-Host "Se han creado los grupos correctamente"
                return
            } 's' {
                Clear-Host
                #Vuelta al menu principal'
                mostrarMenu
            break
            }

        }           
    }
until ($Option -eq 'q')
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
    $Option = Read-Host "Por favor, introduzca una opcion"
    switch ($Option)
    {
            '1' {
                #Creacion plantillas
                Clear-Host
                CrearPlantillas   
                Write-Host "Se han creado las plantillas con exito"
                return
            } '2' {
                #Listar plantillas   
                Clear-Host
                Write-Host "Las plantillas son: "
                dsquery user -name _*
                
                return
            } '3' {
               #Eliminar plantillas

                Clear-Host
                eliminarplantilla
                Write-Host "Se ha eliminado correctamente la plantilla"
                return
            } 's' {
                Clear-Host
                #Vuelta al menu principal
                mostrarMenu
                break
            }

        }           
    }
    until ($Option -eq 'q')
}



#Función que nos muestra un menú por pantalla con 3 opciones, donde una de ellas es para acceder
# a un submenú) y una última para salir del mismo.

function mostrarMenu 
{ 
     

    do 
    {
        param ( 
        [string]$Titulo = 'Menu principal -Fase3' 
        ) 
        Clear-Host 
        Write-Host "================ $ Menu principal - Fase 3================" 
        
        
        Write-Host "1. Gestion de administradores parciales" 
        Write-Host "2. Gestion de plantillas de admins parciales"
        Write-Host "s. Presiona 's' para salir"
            $Option = Read-Host "Elegir una Opción" 
        switch ($Option) 
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
            
                } 's' {
                    Clear-Host
                    #Saliendo del script...'
                    break 
                }  
        } 
        
    }until ($Option -eq 's')
}


mostrarMenu
