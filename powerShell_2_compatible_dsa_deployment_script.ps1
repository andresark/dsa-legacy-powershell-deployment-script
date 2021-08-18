#--------------------Functions--------------------
function downloadInstaller {
    # Creation of Temporary Folder to store installer
    $targetdir = 'C:\temp'
    if(!(Test-Path -Path $targetdir )){
       New-Item -ItemType Directory -Path $targetdir
    }
 
    # HTTP location of installer
    $url = "http://[override_with_your_dsm_address]:[override_with_your_dsm_port]/Agent-Core-Windows-10.0.0-3833.x86_64.msi" #Example Windows 10 installer
 
    # Target location of the installer
    $path = "C:\temp\agent.msi"
 
    # Download the installer
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($url, $path)
}
 
function installAgent {
    # below lines copied from the Agent Deployment Script, just modified and used the $path to call the agent.msi location
    echo "$(Get-Date -format T) - DSA install started"
    echo "$(Get-Date -format T) - Installer Exit Code:" (Start-Process -FilePath msiexec -ArgumentList "/i $path /qn ADDLOCAL=ALL /l*v `"$env:LogPath\dsa_install.log`"" -Wait -PassThru).ExitCode
}
 
function activateAgent {
    $ACTIVATIONURL="dsm://agents.deepsecurity.trendmicro.com:443/" #Override with your manager address (get it from your the original deployment script)
    Start-Sleep -s 50
    echo "$(Get-Date -format T) - DSA activation started"
    & "C:\Program Files\Trend Micro\Deep Security Agent\dsa_control" -r
    & "C:\Program Files\Trend Micro\Deep Security Agent\dsa_control" -a $ACTIVATIONURL "tenantID:[override_with_your_tenant_id]" "token:[override_with_your_tenant_token]" "policyid:[desired_policy]" #this entire line can be copied from the original deployment script
}
 
#--------------------Execution--------------------
downloadInstaller
installAgent
activateAgent