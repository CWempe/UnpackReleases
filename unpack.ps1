
### variables
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
### set source directory
###

do {
	$SrcDir = Read-Host "set source directory ["$DefaultDir"]"
	If ($SrcDir -eq "")
	{
		$SrcDir = $DefaultDir
	}
	$PathExists = Test-Path $SrcDir
}
until ($PathExists)
$SrcDir = [string]::join("", $SrcDir)
Write-Host "source directory is: "$SrcDir
Write-Host ""


###
### set target directory
###

$DstDir = ""
do {
	$DstDir = Read-Host "set target directory ["$SrcDir"]"
	If ($DstDir -eq "")
	{
		$DstDir = $SrcDir
	}
	$PathExists = Test-Path $DstDir
	If ($PathExists -eq $False) {
		$AskCreate = Read-Host "Target directory does not exits. Create it? [y/n]"
		If ($AskCreate -eq "y")
		{
			Write-Host "creating directory ..."
			New-Item $DstDir -type directory -force
			$PathExists = Test-Path $DstDir
		}
	}
}
until ($PathExists)
$DstDir = [string]::join("", $DstDir)
Write-Host "target directory is: "$DstDir
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
### search for rar-files and unpack
###

foreach ($file in get-childitem $SrcDir -include *.rar -recurse)
{
	Write "############" >> $Logfile
	#Write $file >> $Logfile
	
	### split paths
	$path = split-path $file
	
	### save release name
	$SrcDirSlash = [string]::join("", $SrcDir)
	$SrcDirSlash = $SrcDirSlash+"\"
	$relname = $path.Replace($SrcDirSlash, "")
	$relname = $relname.Replace("\", " ")
	$relname = $relname.Replace(" Subs", "")
	Write "release name: "$relname >> $Logfile
	
	### save short release name
	$shortname = split-path $file -leaf
	$shortname = $shortname.Replace(".rar", "")
	$shortname = $shortname.Replace("-subs", "")
	Write "short release name: "$shortname >> $Logfile
		
	
	### unpack
	#   only first partial archives. Not "part(0)01.rar".
	if ( $file -notmatch "^.*part[0-9]{2,3}.rar$" ) {
		$outparam = "-o"+$DstDir
		Write "unpack ..." >> $Logfile		
		& $zip e "$file" $outparam -y
	}
	elseif (  $file -match "^.*part0?01.rar$" ) {
		$outparam = "-o"+$DstDir
		Write "unpack ..." >> $Logfile		
		& $zip e "$file" $outparam -y
	}
	else {
		Write "skip partial archive ..."
	}
	
	

	
	### rename	
	#   replace short release name with release name
	Write "renaming files ..." >> $Logfile
	get-childitem $DstDir"\"$shortname* | foreach { rename-item $_ $_.Name.Replace(”$shortname-“, “$relname.”) }
	get-childitem $DstDir"\"$shortname* | foreach { rename-item $_ $_.Name.Replace(”$shortname“, “$relname”) }
	
	Write "" >> $Logfile
}

$time = Get-Date -uformat "%Y-%m-%d %H:%M:%S" 
Write "" >> $Logfile
Write "Done:" >> $Logfile
Write $time >> $Logfile
