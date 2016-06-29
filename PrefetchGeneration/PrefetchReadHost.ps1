# Powershell Script that will generate the Default Prefetch to placed in the BigFix Action Script

function Generate-Prefetch () {

########################################################################
# Get URL Download Link and Trim any White Space 
########################################################################
$DownloadURL = Read-Host 'URL? '
$DownloadURL = $DownloadURL.Trim()

########################################################################
# Get URL Download Link File Name and Store as Variable
########################################################################
$FileName = $DownloadURL -replace ".*/"

########################################################################
# Set Temp $FileLocation on Local Machine
########################################################################
$FileLocation = "C:\Windows\Temp\$FileName"

########################################################################
# Remove Any Possible Existing Versions of File
########################################################################
Remove-Item -Force $FileLocation -ErrorAction SilentlyContinue

########################################################################
# Download File specified in $DownloadURL to Temp $FileLocation
# Using .NET for download in case Powershell is not on latest Install
########################################################################
$WebLink = New-Object System.Net.WebClient
$WebLink.DownloadFile($DownloadURL,$FileLocation)

########################################################################
# Get Sha1 Value of $FullPathFileName
########################################################################
$Sha1Hash = (Get-FileHash -Path "$FileLocation" -Algorithm sha1).hash.ToLower()

########################################################################
# Get Sha256 Value of $FullPathFileName
########################################################################
$Sha256Hash = (Get-FileHash -Path "$FileLocation" -Algorithm sha256).hash.ToLower()

########################################################################
# Get File Size Value of $FullPathFileName
########################################################################
$FileSize = (Get-Item -Path "$FileLocation").length

########################################################################
# Get Prefetch for BigFix Content
########################################################################
$PrefetchText = "prefetch $FileName sha1:$Sha1Hash size:$FileSize $DownloadURL sha256:$Sha256Hash"

########################################################################
# Remove Downloaded File
########################################################################
Remove-Item -Force $FileLocation -ErrorAction SilentlyContinue

########################################################################
# Return the Prefetch Text
########################################################################
return $PrefetchText

}

Generate-Prefetch