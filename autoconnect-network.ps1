$GetState = netsh wlan show interfaces | Select-String State
$ScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path
$SSID = Read-Host -Prompt 'Quel est le SSID du reseau avec lequel vous souhaitez utiliser le script ?'
$GetSSID = netsh wlan show interfaces | Select-String SSID

Write-Host ""

netsh wlan export profile $SSID folder=$ScriptRoot

while ($true) {
    
    If (!($GetSSID -match $SSID -and $GetState -match "connected")) {
        Write-Host "Not connected to $SSID, creating Profile and connecting.. "
        netsh wlan add profile filename="$ScriptRoot\Wi-Fi-$SSID.xml"
        start-sleep -Seconds 3
        netsh wlan connect name=$SSID
        start-sleep -Seconds 3
    }
    
    $IsConnected = Get-NetAdapter -Name "Wi-Fi" | Select-Object -ExpandProperty Status
    If ($IsConnected -eq "Up") {
        Write-Host "Connexion reussie au SSID $SSID"
        start-sleep -Seconds 3
    }
    elseif ($IsConnected -eq "Disconnected") {
        Write-Host "Vous n'etiez pas connecte au reseau $SSID"
        start-sleep -Seconds 3
    }

    start-sleep -Seconds 60

}