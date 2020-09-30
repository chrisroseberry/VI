# creates c:\temp directory if does not already exist

if (-not (Test-Path -Path "C:\temp" -Verbose -ErrorAction SilentlyContinue)) {
    New-Item -Path C:\ -Name "temp" -ItemType "directory" -Verbose
} else {
    Write-Output "C:\temp already exists"
}
