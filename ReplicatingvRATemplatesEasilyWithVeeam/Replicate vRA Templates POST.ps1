Param(
  [string]$SourcevCenter,
  [string]$DestinationvCenter,
  [string]$FolderName
)

$username = 'user@domain.com'
$password = 'Password'

Connect-VIServer -Server $SourcevCenter -User $username -Password $password
Connect-VIServer -Server $DestinationvCenter -User $username -Password $password
foreach ($vm in (Get-Folder -Name $foldername -Server $DestinationvCenter | Get-VM)){
    #Check to ensure VMtools is registering as installed or else customization will fail.
    if($vm.Guest.ExtensionData.ToolsVersionStatus -eq "guestToolsNotInstalled"){
           Write-Output "Starting $vm."
           Start-VM $vm 1> $null
           do {
            Start-Sleep -Seconds 5
            #Refresh vm variable.
            $vm = Get-VM -Name $vm.Name
            $toolsStatus = $vm.ExtensionData.Guest.ToolsStatus
            } until ($toolsStatus -eq "toolsOK")
           Write-Output "Stopping $vm."
           Stop-VMGuest $vm -Confirm:$false 1> $null
           do {
            Start-Sleep -Seconds 5
            #Refresh vm variable.
            $vm = Get-VM -Name $vm.Name
            $powerstate = $vm.PowerState
            } until ($powerstate -eq "PoweredOff")
           Write-Output "Converting $vm to template."
           $vm | Set-VM -ToTemplate -Confirm:$false 1> $null
           }
        else{Write-Output "$vm has OK tools status. Converting to template."
            $vm | Set-VM -ToTemplate -Confirm:$false 1> $null
            }
        }
Write-Output "Converting VMs to templates at source."
Get-Folder -Name $foldername -Server $SourcevCenter | Get-VM | Set-VM -ToTemplate -Confirm:$false 1> $null
Disconnect-VIServer -Server $DestinationvCenter -Confirm:$false
Disconnect-VIServer -Server $SourcevCenter -Confirm:$false