#script to removed vda that are previously in maintenance mode to windows updates


$host_name = $env:COMPUTERNAME
$in_file = "c:\temp\$host_name-vdas.txt"

$vdas = Get-Content $in_file

Foreach ($vda in $vdas)
{

   $sdm_vda_exceptions = "tor-hv-50c","tor-hv-50d","tor-hv-51c","tor-hv-51d","tor-hv-17a","tor-hv-17b","tor-hv-18a","tor-hv-18b"

    $ddc = "unknown"

    if ($sdm_vda_exceptions -contains $vda) {
        $ddc = "xa715-dc-sdm01"
    } elseif ($vda -match "tor") {
        $ddc = "xa715-dc-tor01"
    } elseif ($vda -match "cgy") {
        $ddc = "xa715-dc-cgy01"   
    }
	
	
$vdastatus = Invoke-Command  	-ComputerName $ddc `
								-ScriptBlock { `
								Param ($vda_name); Add-PSSnapin Citrix.Broker.Admin.V2; Get-Brokermachine  -MachineName "cdsasp\$vda_name" ` 
                        } `
                        -ArgumentList $vda
						
	$vdastatus2 = ($vdastatus | select InMaintenancemode).InMaintenanceMode
					
	if ($vdastatus2 -eq $True)
	{
	write-host $vda $vmstatus2 "is in maintenance mode pre windows updates."
	
	
	
	(Get-Content -Path "c:\temp\$host_name-vdas.txt" | Where-Object {$_ -ne $vda}) | Out-File "c:\temp\$host_name-vdas.txt"
	
		}
		
}




