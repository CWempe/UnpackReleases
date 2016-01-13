Rechte zum Ausführen von Scripten unter Win8:
http://technet.microsoft.com/de-DE/library/hh847748.aspx

Get-ExecutionPolicy -List
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ExecutionPolicy -List

Verknüpfung erstellen in:
%APPDATA%\Microsoft\Windows\SendTo

Pfad der Verpnüpfung:
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -Command "& '%ProgramFiles%\UnpackScript\unpack.ps1'"

