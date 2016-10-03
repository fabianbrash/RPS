
#Filename:            VMAutomation_IIS.ps1
#Author:              Fabian Brash
#Date:                09-26-2016
#Modified:            010-03-2016
#Purpose:             Deploy IIS inside of a running VM



<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
                                     



Clear-Host

try
    {
        Import-Module -Name VMware.VimAutomation.Core -ErrorAction Stop
    }
catch
    {
        Write-Error -Message "Could not load Core Modules"
    }


$vc = 'Your VC'

Connect-VIServer -Server $vc
$TargetVM = 'VM-Automation03'
$TargetUser = 'Administrator'

$IISScript = 'Install-WindowsFeature -Name Web-Server -IncludeManagementTools'
$Power_ByPass = 'Set-ExecutionPolicy Unrestricted -Confirm:$False'

try
    {
        Invoke-VMScript -VM $TargetVM -ScriptText $Power_ByPass -GuestCredential (Get-Credential) -ErrorAction Stop
        Invoke-VMScript -VM $TargetVM -ScriptText $IISScript -GuestCredential (Get-Credential) -ErrorAction Stop
    }
catch
    {
        Write-Error -Message "Unable to customize Guest VM..."
    }