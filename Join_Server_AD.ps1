#Add the current system to the domain in the specified container


<#________   ________   ________      
|\   __  \ |\   __  \ |\   ____\     
\ \  \|\  \\ \  \|\  \\ \  \___|_    
 \ \   _  _\\ \   ____\\ \_____  \   
  \ \  \\  \|\ \  \___| \|____|\  \  
   \ \__\\ _\ \ \__\      ____\_\  \ 
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>
  

$RPS_OU = "OU"
$RPSCred = "USERNAME"
$RPSDomain = "DOMAIN"

Add-Computer -DomainName $RPSDomain -OUpath $RPS_OU -Credential $RPSCred -Passthru -Verbose -Restart