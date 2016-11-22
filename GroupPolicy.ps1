

Clear-Host


<#
    Valid values are AllSettingsEnabled, AllSettingsDisabled, UserSettingsDisabled and ComputerSettingsDisabled.
#>




try
    {
        Import-Module -Name ActiveDirectory -ErrorAction Stop
        Import-Module -Name GroupPolicy -ErrorAction Stop
     }
catch
    {
        Write-Error -Message "Could not find and load modules"
    }


$gpoStatus = Get-GPO "RPS-Student-WorkstationSecurity"

$gpoStatus.GpoStatus

if($gpoStatus.GpoStatus -eq 'AllSettingsDisabled')
    {
        Write-Host "Success it's off"
    }
else
    {
        Write-Host "Still on!!"
    }

<# We can set the status like
    $gpoStatus.GpoStatus = "AllSettingsEnabled"
#>