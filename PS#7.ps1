<#
    Powershell #7
    ADUsers, OUs, and Groups
    Due : 4-17-2020
    Giovanni Perez-laroque
#>

clear-host

do{

    write-host "Choose from the following menu options: "
    write-host "
    A. View one OU`t`t`tB. View all OUs`n
    C. View one group`t`tD. View all groups`n
    E. View one user`t`tF. View all users`n`n
    G. Create one OU`t`tH. Create one group`n
    I. Create one user`t`tJ. Create users from csv file`n`n
    K. Add user to group`tL. Remove user from group`n`n
    M. Delete one group`t`tN. Delete one user`n"

    $option=read-host "Enter anything other than A-N to quit. [A-N]"
    $option = $option.ToLower()

    if($option[0] -like "a"){

        $option2=read-host "Enter the NAME of the OU"
        Get-ADOrganizationalUnit -filter {Name -like $option2 } |Format-Table -Property name, distinguishedname
        read-host "Press enter to continue"

    }elseif($option[0] -like "b"){

        Get-ADOrganizationalUnit -Filter {Name -notlike "Domain Controllers"}  |Format-Table -Property name, distinguishedname
        read-host "Press enter to continue"

    }elseif($option[0] -like "c"){

        $option2=read-host "Enter the name of the group"
        Get-ADGroup -identity $option2  |Format-Table -Property name, groupscope, groupcategory
        read-host "Press enter to continue"

    }elseif($option[0] -like "d"){

        Get-ADGroup -filter * |Format-Table -Property name, groupscope, groupcategory
        read-host "Press enter to continue"

    }elseif($option[0] -like "e"){
        
        $option2=read-host "Enter the name of the user"
        Get-ADUser -filter {Name -like $option2 } |Format-Table -Property name,distinguishedname
        read-host "Press enter to continue"

    }elseif($option[0] -like "f"){
      
        Get-ADUser -filter * |format-table -property name,distinguishedname,givenname,surname
        read-host "Press enter to continue"

    }elseif($option[0] -like "g"){
        
        $option2=read-host "Enter the name of the OU to create"
        New-ADOrganizationalUnit -Name $option2
        Get-ADOrganizationalUnit -Filter {Name -like $option2}|format-table -Property name,distinguishedname
        read-host "Press enter to continue"

    }elseif($option[0] -like "h"){
        
        $option2=read-host "Enter the name of the group the create"
        New-ADGroup -GroupScope Global -GroupCategory Security -Name $option2 -SamAccountName $option2
        Get-ADGroup -Identity $option2 |format-table -Property name,groupscope,groupcategory
        read-host "Press enter to continue"

    }elseif($option[0] -like "i"){
        
        $option2=read-host "Enter the name of the user to create"
        $securepass=ConvertTo-SecureString -string "Password01" -AsPlainText -Force
        $first=read-host "Enter the first name"
        $last=read-host "Enter the last name"
        $address=read-host "Enter the address"
        $city=read-host "Enter the city"
        $state=read-host "Enter the state"
        $zip=read-host "Enter the zip code"
        $company=read-host "Enter the company"
        $division=read-host "Enter the division"
        do{
            $option3=read-host "Will the user go into the users container or an OU? [U/O]"
            $option3=$option3.ToLower()
            if($option3[0] -like "u"){
                
                New-ADUser -Name $option2 -SamAccountName $option2 -UserPrincipalName $option2@adatum.com -AccountPassword $securepass -Enabled $true
                Write-Output "Created in Users Container"
                #Path will be Users Container
            }elseif($option3[0] -like "o"){
                $ou=read-host "Enter the name of the OU"
                New-ADUser -Name $option2 -SamAccountName $option2 -UserPrincipalName $option2@adatum.com -AccountPassword $securepass -Enabled $true -Path "OU=$ou,DC=adatum,DC=com"
            }else{
                Write-Host "Option not recognized"
            }
        }while(-not "ou".Contains($option3[0]))
        Set-ADUser -Identity $option2 -GivenName $first 
        Set-ADUser -Identity $option2 -Surname $last 
        Set-ADUser -Identity $option2 -StreetAddress $address
        Set-ADUser -Identity $option2 -City $city
        Set-ADUser -Identity $option2 -State $state
        Set-ADUser -Identity $option2 -PostalCode $zip
        Set-ADUser -Identity $option2 -Company $company
        Set-ADUser -Identity $option2 -Division $division
        Get-ADUser -identity $option2 -Properties Name, samaccountname,userprincipalname,givenname,surname,city,state,postalcode,company,division|Format-List
        read-host "Press enter to continue"

    }elseif($option[0] -like "j"){
        
        $csv=read-host "Enter the name of the csv file"
        $password=read-host "Enter the password for the users"
        $securepass2=(ConvertTo-SecureString -string $password -AsPlainText -Force)
        $users=import-csv -path $env:userprofile\$csv
        $users|New-ADUser -AccountPassword $securepass2 -Enabled $true -Fax "111-222-3333"
        Get-ADUser -Filter "department -like '*lab*'" -Properties Name, samaccountname,userprincipalname,givenname,surname,city,state,postalcode,company,department|Format-List
        read-host "Press enter to continue"

    }elseif($option[0] -like "k"){
        
        $option2=Read-Host "Enter the name of the group"
        $option3=Read-host "Enter the name of the user"
        Add-ADGroupMember -Identity $option2 -members $option3
        Get-ADGroupMember $option2 |Format-Table -Property samaccountname,distringuishedname
        read-host "Press enter to continue"

    }elseif($option[0] -like "l"){
        
        $option2 = read-host "Enter the name of the group that will lose a user"
        Get-ADGroupMember $option2 |Format-Table -Property samaccountname,distringuishedname
        $option3 = Read-Host "Would you like to remove one of those users? [Y/N]"
        if ($option3[0] -like "y"){
            $option4 = Read-Host " Enter the NAME of the user to remove"
            Remove-ADGroupMember -Identity $option2 -Members $option4
            Get-ADGroupMember $option2 |Format-Table -Property samaccountname,distringuishedname
            read-host "Press enter to continue"
        }

    }elseif($option[0] -like "m"){
        
        $option2 = Read-Host "Enter the NAME of the group to remove"
        Remove-ADGroup -Identity $option2
        Get-ADGroup -Filter * | Format-Table -Property Name,groupscope,groupcategory
        read-host "Press enter to continue"

    }elseif($option[0] -like "n"){
        
        $option2 = Read-Host "Enter the NAME of the user to remove"
        Remove-ADUser -Identity $option2
        Get-ADUser -Filter * | Format-Table -Property name,distinguishedname
        read-host "Press enter to continue"

    }

}while("abcdefghijklmn".contains($option[0]))