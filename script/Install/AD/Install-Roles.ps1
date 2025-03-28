# Define variables
$DomainName = "local.pleter.ovh"  # Change this to your desired domain name
$NetBiosName = "PLETER"     # Change this to your NetBIOS name
$SafeModeAdminPassword = Read-Host "SafeModeAdminPassword" -AsSecureString 

# Install Active Directory Domain Services and DNS Server roles
Install-WindowsFeature -Name AD-Domain-Services, DNS -IncludeManagementTools

# Install Forest and Promote Server to Domain Controller
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetBiosName `
    -SafeModeAdministratorPassword $SafeModeAdminPassword `
    -InstallDNS `
    -Force


###Il est normal de recevoir le warning suivant car local.pleter.ovh n'est pas censé etre résolu par un serveur DNS externe.

#WARNING: A delegation for this DNS server cannot be created because the authoritative parent zone cannot be found or it does not run Windows DNS server. If
#you are integrating with an existing DNS infrastructure, you should manually create a delegation to this DNS server in the parent zone to ensure reliable
#name resolution from outside the domain "local.pleter.ovh". Otherwise, no action is required.