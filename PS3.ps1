
<#    
    Purpose:
                CNTS 1201
                LAb3 Files and if
    Aurthor:    Giovanni Perez-Laroque
    File:       PS3.ps1
    Date:       Feb 20,2020
#>

#---------------------------Part #1

Clear-Host
Set-Location $env:USERPROFILE
Get-ChildItem -Filter *.txt | format-table -Property name, length

#-------------------------Checkoff #1-------------------------


#---------------------------Part #2
$PS3Menu= @"

What do you want to do?
    1. Write a contact entry to a file
    2. Display all files last written to after a given date
    3. read a specified text file

"@
$PS3Menu

Write-Output "Enter a choice"
$Choice=Read-Host "[1/2/3]"

#-------------------------Checkoff #2-------------------------


#---------------------------Part #3

if($Choice -eq 1){
    
    $Contactname=Read-Host "Enter the Contact's name"
    $Contactphone=Read-Host "Enter the Contact's phone number"
    $Contactemail=Read-Host "Enter the Contact's email address"
    $contactFile=read-host "Enter the name of the file to save to"
    Add-Content $contactfile $Contactname
    Add-Content $contactfile $Contactphone
    Add-Content $contactfile $Contactemail
    Add-Content $contactfile ""

}elseif($Choice -eq 2){
    
    $earlydatefile=Read-host "Enter the earliest date of the files to display"
    Get-ChildItem -Recurse | Where-Object { $_.LastWriteTime -ge $earlydatefile}| Sort-Object -Property lastwritetime | Format-Table -Property name, lastwritetime

}elseif($Choice -eq 3){
    
    $filename=Read-Host "Enter the name of the file to read"
    $fileexist=Test-Path $filename
    if ($fileexist){
        Write-Output "----------File Read----------"
        Get-Content $filename
        Write-Output "----------File Read----------"
    }else{
        Write-Output "`nFile Not Found"
    }


}else{
    Write-Output "Error on $env:computername, logged on as $env:username.`nNo option was Chosen"
}

#-------------------------Checkoff #3-------------------------