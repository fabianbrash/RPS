#Filename:            softwareDeployTemplate.ps1
#Author:              Fabian Brash
#Date:                01-04-2017
#Modified:            01-04-2017
#Purpose:             This is a template for installing software of desktop systems



<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
                                     

Clear-Host

<# Global Variables #>

$MSI = "msiexec.exe"
$Install = "/i"
$Remove = "/x"
$Silent = "/qn"
$QuietBasic = "/qb"
$CurLogFile = 'C:\InstallLogs\Flash24ZeroDay_Patch.txt'
$CurLogFileName = "Flash24ZeroDay_Patch.txt"
$LogFolder = 'C:\InstallLogs\'
$PrevLogFile = 'C:\InstallLogs\Flash22ZeroDay_Patch.txt'
$AppLocation = "PATH_TO_APP"

<# End Global Variables #>

<# Function Block #>

function InstallApp($AppLocation)
    {
        #This should work as well
        #Start-Process -FilePath msiexec -ArgumentList /i,$AppLocation,/qn -Wait

        & $MSI $Install $AppLocation $Silent
    }

function PreCheck
    {
        #Check to see if we have run before
        if(Test-Path $CurLogFile)
            {
                Exit
            }
        #Check to see if we have already created our Log folder
        if(-not (Test-Path $LogFolder) )
            {
                New-Item -Path $LogFolder -type directory
                Add-Content $LogFolder$CurLogFileName "Flash 24 Installed"
            }
        else
            {
                Add-Content $LogFolder$CurLogFileName "Flash 24 Installed"
            }
    }

function CleanUp
    {
        if(Test-Path $PrevLogFile)
            {
                Remove-Item $PrevLogFile -recurse
            }  
    }

<# End Function Block #>

    PreCheck
    InstallApp $AppLocation
    CleanUp