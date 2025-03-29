function Validate-IPAddress {
    param (
        [string]$IPAddress
    )
    $octets = $IPAddress -split '\.'
    if ($octets.Count -ne 4) { return $false }
    foreach ($octet in $octets) {
        if ($octet -notmatch '^[0-9]+$' -or [int]$octet -lt 0 -or [int]$octet -gt 255) {
            return $false
        }
    }
    return $true
}

function Convert-SubnetMaskToPrefix {
    param (
        [string]$SubnetMask
    )
    $binaryMask = ($SubnetMask -split '\.') | ForEach-Object { [Convert]::ToString([int]$_, 2).PadLeft(8, '0') }
    return ($binaryMask -join '').IndexOf('0')
}

# Liste des interfaces réseau disponibles
$interfaces = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
if ($interfaces.Count -eq 0) {
    Write-Host "Aucune interface réseau active trouvée." -ForegroundColor Red
    exit
}

# Affichage des interfaces disponibles
Write-Host "Sélectionnez une interface réseau:" -ForegroundColor Cyan
$interfaces | ForEach-Object { Write-Host "[$($_.InterfaceIndex)] $($_.Name)" }

# Sélection de l'interface
$selectedIndex = Read-Host "Entrez l'index de l'interface"
$interface = $interfaces | Where-Object { $_.InterfaceIndex -eq $selectedIndex }
if (-not $interface) {
    Write-Host "Interface invalide." -ForegroundColor Red
    exit
}

# Demande des informations réseau
$ipAddress = Read-Host "Entrez l'adresse IP statique"
if (-not (Validate-IPAddress $ipAddress)) {
    Write-Host "Adresse IP invalide." -ForegroundColor Red
    exit
}

$subnetMask = Read-Host "Entrez le masque de sous-réseau (ex: 255.255.255.0)"
if (-not (Validate-IPAddress $subnetMask)) {
    Write-Host "Masque de sous-réseau invalide." -ForegroundColor Red
    exit
}
$prefixLength = Convert-SubnetMaskToPrefix $subnetMask

$gateway = Read-Host "Entrez l'adresse de la passerelle"
if (-not (Validate-IPAddress $gateway)) {
    Write-Host "Passerelle invalide." -ForegroundColor Red
    exit
}

# Configuration de l'interface
Write-Host "Configuration de l'interface $($interface.Name)..." -ForegroundColor Yellow

# Désactivation du DHCP
Set-NetIPInterface -InterfaceIndex $interface.InterfaceIndex -Dhcp Disabled

# Suppression de l'ancienne configuration
Remove-NetIPAddress -InterfaceIndex $interface.InterfaceIndex -Confirm:$false -ErrorAction SilentlyContinue
Remove-NetRoute -InterfaceIndex $interface.InterfaceIndex -Confirm:$false -ErrorAction SilentlyContinue

# Attribution de la nouvelle configuration
New-NetIPAddress -InterfaceIndex $interface.InterfaceIndex -IPAddress $ipAddress -PrefixLength $prefixLength -DefaultGateway $gateway

Write-Host "Configuration appliquée avec succès !" -ForegroundColor Green
