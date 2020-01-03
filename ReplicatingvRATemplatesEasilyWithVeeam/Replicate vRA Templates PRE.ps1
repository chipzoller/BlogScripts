Param(
  [string]$SourcevCenter,
  [string]$DestinationvCenter,
  [string]$FolderName
)

$username = 'user@domain.com'
$password = 'Password'

Connect-VIServer -Server $SourcevCenter -User $username -Password $password -Force
Connect-VIServer -Server $DestinationvCenter -User $username -Password $password -Force
Get-Folder -Name $FolderName -Server $DestinationvCenter | Get-Template | Set-Template -ToVM
Get-Folder -Name $FolderName -Server $SourcevCenter | Get-Template | Set-Template -ToVM
Disconnect-VIServer -Server $DestinationvCenter -Confirm:$false
Disconnect-VIServer -Server $SourcevCenter -Confirm:$false