Clear-Host

Write-Host "Getting .Net Version..." -ForegroundColor Yellow
"`n"
#Get .Net Version
$DotNETVersion = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
$DotNETVersion = (Get-ItemProperty -Path $DotNETVersion -Name Version).Version
Write-Host ".NET Version:" $DotNETVersion -ForegroundColor Green
"`n"
Write-Host "========================================================================"
#Get Powershell Version
"`n"
Write-Host "Powershell Version:" -ForegroundColor Yellow
"`n"
$PSVersionTable.PSVersion