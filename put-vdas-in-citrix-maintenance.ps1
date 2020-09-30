# put VDAs into Citrix maintenance mode running on local Hyper-V host

$host_name = $env:COMPUTERNAME
$in_file = "c:\temp\$host_name-vdas.txt"

$vdas = Get-Content $in_file

foreach ($vda in $vdas) {

    # figure out which DDC to use

    $sdm_vda_exceptions = "tor-hv-50c","tor-hv-50d","tor-hv-51c","tor-hv-51d","tor-hv-17a","tor-hv-17b","tor-hv-18a","tor-hv-18b"

    $ddc = "unknown"

    if ($sdm_vda_exceptions -contains $vda) {
        $ddc = "xa715-dc-sdm01"
    } elseif ($vda -match "tor") {
        $ddc = "xa715-dc-tor01"
    } elseif ($vda -match "cgy") {
        $ddc = "xa715-dc-cgy01"   
    }


    # wrap error handling around this code
    try {
        Write-Output "Set Citrix Maintenance mode on cdsasp\$vda using $ddc"
        Invoke-Command  -ComputerName $ddc `
                        -ScriptBlock { `
                            Param ($vda_name); Add-PSSnapin Citrix.Broker.Admin.V2; Set-BrokerMachineMaintenanceMode -InputObject "cdsasp\$vda_name" $true `
                        } `
                        -ArgumentList $vda
    }
    catch {
        Write-Output "`t Error setting maintnance mode on $vda ($($Error[0].Exception.Message))"
        exit 1
    }
}
