
#Filename:            VMware_VM_Automation.ps1
#Author:              Fabian Brash
#Date:                09-28-2016
#Modified:            10-03-2016
#Purpose:             Deploy and Customize a VM **Must be run in x86 version of Powershell or PowerCLI



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
        Write-Error -Message "VmWare core automation module could not be loaded..."
    }



#Get-OSCustomizationSpec -Name "Server2012-Customization_Automation"
#Get-OSCustomizationSpec -Name "Server2012-Customization_Automation" | Get-OSCustomizationNicMapping

$RPS_DataStore = "YOUR DATASTORE"
$VMNetwork = "YOUR NETWORK"
$VMName = 'VM-Automation03'
$RPS_Folder = 'YOUR FOLDER'
$SourceCustomization = "Server2012R2-Customization_PowerCLI"
$Subnet = 'YOUR SUBNET'
$RPS_IPMode = 'UseStaticIp'
$RPS_IPAddress = 'YOUR IP'
$Gateway = 'YOUR GATEWAY'
$RPS_DNS = 'YOUR DNS'
$RPS_DNS2 = 'YOUR DNS2'
$vCenter = "YOUR VCENTER"
$RPS_Description = 'Automated Deployment Updates as of 09-30-2016'


Connect-ViServer -Server $vCenter

#Variables from inside vCenter
$TargetCluster = Get-Cluster -Name "YOUR CLUSTER"
$SourceTemplate = Get-Template -Name "Clonable_Server2012R2"


#$nicMapping = Get-OSCustomizationNicMapping -OSCustomizationSpec -Name $SourceCustomization | where {$_.Position -eq 1}
Get-OSCustomizationSpec $SourceCustomization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode $RPS_IPMode -IpAddress $RPS_IPAddress -SubnetMask $Subnet -DefaultGateway $Gateway -Dns $RPS_DNS

Write-Verbose -Message "Beginning deployment of VM..." -Verbose
try{

    New-VM -Name $VMName -ResourcePool $TargetCluster -Location $RPS_Folder -Datastore $RPS_DataStore -Template $SourceTemplate -OSCustomizationSpec $SourceCustomization -Description $RPS_Description -ErrorAction Stop
    Start-VM -VM $VMName
    #-RunAsync Do not add to New-Vm command if you want to use Start-VM -VM $myVM command
}

catch{
        Write-Error "Deployment Failed..."
    }