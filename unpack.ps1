
### Variablen
$DefaultDir = Get-location
$zip = "C:\Program Files\7-Zip\7z.exe"
#$date = Get-Date -uformat "%Y-%m-%d"

foreach ($arg in $args)
{
	#Write-Host "Arg: $arg";
	$PathExists = Test-Path $arg
	If ($PathExists) {
		$DefaultDir = $arg
	}
}



###
### Quellverzeichnis angeben
###

do {
	$SrcDir = Read-Host "Quellverzeichnis angeben ["$DefaultDir"]"
	If ($SrcDir -eq "")
	{
		$SrcDir = $DefaultDir
	}
	$PathExists = Test-Path $SrcDir
}
until ($PathExists)
$SrcDir = [string]::join("", $SrcDir)
Write-Host "Quellverzeichnis ist: "$SrcDir
Write-Host ""


###
### Quellverzeichnis angeben
###

$DstDir = ""
do {
	$DstDir = Read-Host "Zielverzeichnis angeben ["$SrcDir"]"
	If ($DstDir -eq "")
	{
		$DstDir = $SrcDir
	}
	$PathExists = Test-Path $DstDir
	If ($PathExists -eq $False) {
		$AskCreate = Read-Host "Verzeichnis existiert nicht. Erstellen? [j/n]"
		If ($AskCreate -eq "j")
		{
			Write-Host "Erstelle Verzeichnis ..."
			New-Item $DstDir -type directory -force
			$PathExists = Test-Path $DstDir
		}
	}
}
until ($PathExists)
$DstDir = [string]::join("", $DstDir)
Write-Host "Zielverzeichnis ist: "$DstDir
Write-Host ""

$Logfile = $SrcDir+"\logfile.log"
#$Logfile = "F:\test\logfile.txt"

#Return

$time = Get-Date -uformat "%Y-%m-%d %H:%M:%S" 
Write "Start:" > $Logfile
Write $time >> $Logfile
Write "" >> $Logfile
Write "Quellverzeichnis ist: "$SrcDir >> $Logfile
Write "Zielverzeichnis ist: "$DstDir >> $Logfile
Write "Logfile ist: "$Logfile >> $Logfile
Write "" >> $Logfile



###
### RAR-Dateien suchen und entpacken
###

foreach ($file in get-childitem $SrcDir -include *.rar -recurse)
{
	Write "############" >> $Logfile
	#Write $file >> $Logfile
	
	### Pfad in Einzelteile aufteilen
	$path = split-path $file
	
	### Releasenamen speichern		
	$SrcDirSlash = [string]::join("", $SrcDir)
	$SrcDirSlash = $SrcDirSlash+"\"
	$relname = $path.Replace($SrcDirSlash, "")
	$relname = $relname.Replace("\", " ")
	$relname = $relname.Replace(" Subs", "")
	Write "Releasename: "$relname >> $Logfile
	
	### Releasekürzel speichern
	$shortname = split-path $file -leaf
	$shortname = $shortname.Replace(".rar", "")
	$shortname = $shortname.Replace("-subs", "")
	Write "Releasekürzel: "$shortname >> $Logfile
		
	
	### Entpacken
	#   Nur Dateien, die nicht weiterfolgende Teilarchive von "part(0)01.rar" sind.
	if ( $file -notmatch "^.*part[0-9]{2,3}.rar$" ) {
		$outparam = "-o"+$DstDir
		Write "Entpacken ..." >> $Logfile		
		& $zip e "$file" $outparam -y
	}
	elseif (  $file -match "^.*part0?01.rar$" ) {
		$outparam = "-o"+$DstDir
		Write "Entpacken ..." >> $Logfile		
		& $zip e "$file" $outparam -y
	}
	else {
		Write "Überspringe Teilarchiv ..."
	}
	
	

	
	### Umbenennen	
	#   Ersetze Releasekürzel durch Releasename
	Write "Dateien umbenennen ..." >> $Logfile
	get-childitem $DstDir"\"$shortname* | foreach { rename-item $_ $_.Name.Replace(”$shortname-“, “$relname.”) }
	get-childitem $DstDir"\"$shortname* | foreach { rename-item $_ $_.Name.Replace(”$shortname“, “$relname”) }
	
	Write "" >> $Logfile
}

$time = Get-Date -uformat "%Y-%m-%d %H:%M:%S" 
Write "" >> $Logfile
Write "Ende:" >> $Logfile
Write $time >> $Logfile
