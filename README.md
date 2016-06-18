# About

This script can be used to batch unpack downloaded releases from a source directory to a target directory and rename the files from a short release name to the actual release name.

# Reqirements

* [Microsoft PowerShell](https://msdn.microsoft.com/powershell)
* [7-zip](http://www.7-zip.org/download.html)

# Install

Copy or clone this repository
```git clone https://github.com/CWempe/UnpackScript.git```

Open PowerShell as Administrator.
Change directory (`cd`) to the new folder.
Execute `./setup.ps1`.
This will set the necessary ExecutionPolicy ([see](http://technet.microsoft.com/de-DE/library/hh847748.aspx)) and create a shortcut in the SendTo directory.

# Using

You wil be able to right click in any folder with packed releases and open the script via "Send to ..." in the context menu.
Once you set the target folder the script will begin to upnack and rename the files.
