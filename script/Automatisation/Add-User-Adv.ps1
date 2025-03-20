###################CONSTANTE##################################
$OU = "CN=Users,DC=LOCAL,DC=PLETER,DC=OVH"
$DomainName = "LOCAL.PLETER.OVH"

###################MAIN#######################################

#
$FirstName = Read-Host "Entrez le prénom de l'utilisateur "
$LastName = Read-Host "Entrez le nom de famille de l'utilisateur "
$DefaultSAM = "$($FirstName.Substring(0,1))$LastName".ToLower()
#Demander sAMAccountName du nouvel utilisateur
$SAMAccountName = Read-Host "sAMAccountName [$DefaultSAM)] "
if (-not $SAMAccountName) { $SAMAccountName = $DefaultSAM }


$Password = Read-Host "Password" -AsSecureString




#Mise en forme du nouvel utilisateur
$NewADUserParameters = @{
  Name = "$FirstName $LastName"
  GivenName = $FirstName
  Surname = $LastName
  sAMAccountName = $SAMAccountName
  UserPrincipalName = "$SAMAccountName@$DomainName"
  AccountPassword = $Password
  Path = $OU
  Enabled = $true
}

#Ajout de l'utilisateur à l'annuaire
New-ADUser @NewADUserParameters
