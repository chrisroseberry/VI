# generate a list of VDAs running on the local Hyper-V host

$host_name = $env:COMPUTERNAME
$out_file = "c:\temp\$host_name-vdas.txt"

Remove-Item -Force -Path $out_file -ErrorAction SilentlyContinue

$vdas = Invoke-Command -ComputerName $host_name -ScriptBlock { get-vm | Where-Object { $_.state -eq "running" } }

foreach ($vda in $vdas) {
    if ($vda.Name -match $host_name) {
        Write-Output "$($vda.Name)"
        $vda.Name | Out-File -Append -FilePath $out_file
    }
}
