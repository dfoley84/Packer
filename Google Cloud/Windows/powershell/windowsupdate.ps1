param (
    [string]$region = $env:REGION
)

# Install Windows Telnet Client #
#################################
if ((Get-WindowsFeature -Name Telnet-Client).Installed -ne "True") {
    Write-Output "Installing telnet client..."
    Add-WindowsFeature Telnet-Client
}


# Check & Install WinUpdate PS Module #
#######################################
$modules_folder = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"
if(!(Test-Path ($modules_folder+'\PSWindowsUpdate'))) {
    Write-Output "Installing windows update powershell module..."
    $dest_folder = $ENV:TEMP
    $dest_file = 'PSWindowsUpdate.zip'
    $dest = $dest_folder + '\' + $dest_file
    $download_url = "https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/41459/43/PSWindowsUpdate.zip"
    (New-Object System.Net.WebClient).DownloadFile($download_url, $dest)
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($dest)
    foreach($item in $zip.items())
    {
        $shell.Namespace($modules_folder).copyhere($item)
    }
    Write-Output "Installed windows update powershell module"
}
Import-Module PSWindowsUpdate

# Download & Install Windows Updates #
######################################
Write-Output "Checking for windows updates..."
Get-WUInstall -AcceptAll -IgnoreReboot -Verbose
Write-Output "Updates complete"
