# Variables
$OUPath = "DC=local,DC=pleter,DC=ovh"
$AdminGroup = "Administrateur"
$UserGroup = "Normal"

# Import Active Directory Module
Import-Module ActiveDirectory

# Create Security Groups
New-ADGroup -Name $AdminGroup -GroupScope Global -Path $OUPath -Description "Adminstrateurs Informatique"
New-ADGroup -Name $UserGroup -GroupScope Global -Path $OUPath -Description "Utilisateur régulier"

