#FileName:      Core_Deployment.ps1
#Author:        Fabian Brash
#Date:          07-05-2016
#Modified:      07-05-2016



<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
  
  
  Clear-Host
  
  $FeatureName=""
  $WildCard="*"
  $DotNetCore_3_5 = "NET-Framework-Core"
  $IIS = "Web-Server"
  $ManagementTools = "-IncludeManagementTools"
  $SubFeatures = "-IncludeAllSubFeature"
  $TraceMode = "-WhatIf"

  $Server = Read-Host "Please enter target server"

  
  #Let's get all features of the OS
  
  Get-WindowsFeature -ComputerName $Server
  
  #sconfig will setup basic features of the server IP, hostname, etc..
  
  #Install a particular feature

  #Install-WindowsFeature -Name $FeatureName  
  
                                  