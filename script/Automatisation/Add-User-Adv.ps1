###################CONSTANTE##################################
$OU = "CN=Users,DC=LOCAL,DC=PLETER,DC=OVH"  #Organizational Units où insérer l'utilisateur
$DomainName = "LOCAL.PLETER.OVH" #Domaine Active Directory

###################MAIN#######################################

#Demander paramètres utilisateur
$FirstName = Read-Host "Entrez le prénom du nouvel utilisateur "
$LastName = Read-Host "Entrez le nom de famille du nouvel utilisateur "
$DefaultSAM = "$($FirstName.Substring(0,1))$LastName".ToLower()
#Demander sAMAccountName du nouvel utilisateur
$SAMAccountName = Read-Host "sAMAccountName du nouvel utilisateur [$DefaultSAM)] "
if (-not $SAMAccountName) { $SAMAccountName = $DefaultSAM }


$Password = Read-Host "Password" -AsSecureString


#Mise en forme des paramètres du nouvel utilisateur
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
