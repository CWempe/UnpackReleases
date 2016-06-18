Write-Host
Write-Host "This script sets ExecutionPolicy and created a shortcutr to use the 'unpack Releases' script."
Write-Host




Write-Host "Set ExecutionPolicy 'RemoteSigned' to 'CurrentUser'..."
Write-Host "see: http://technet.microsoft.com/de-DE/library/hh847748.aspx"
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Write-Host


# set paths and commands
$WorkingDir = Get-location
$ShortcutFilename = "$env:APPDATA\Microsoft\Windows\SendTo\unpack releases.lnk"
$PowerShellExe = "$env:SYSTEMROOT\system32\WindowsPowerShell\v1.0\powershell.exe"
$PowerShellArguments = "-Command `"& '$WorkingDir\unpack.ps1'`""

Write-Host "These values will be used to create the shortcut:"
Write-Host "shortcut filename:   $ShortcutFilename"
Write-Host "PowerShellExe:       $PowerShellExe"
Write-Host "PowerShellArguments: $PowerShellArguments"
Write-Host "WorkingDir:          $WorkingDir"
Write-Host

Write-Host "Creating shortcut..."
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFilename)
$Shortcut.TargetPath = $PowerShellExe
$Shortcut.Arguments = "$PowerShellArguments"
$Shortcut.WorkingDirectory = "$WorkingDir"
$Shortcut.Save()


Write-Host "You can now use the 'Sent to..' menu in the Explorer to unpack realeases from one folder to another."
