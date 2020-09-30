$Folder = "C:\Updates"
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.Name -like "WUInstall_*" -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)}  |
ForEach-Object {
   $_ | del -Force
}