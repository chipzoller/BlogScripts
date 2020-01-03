Add-PsSnapin VMware.VimAutomation.Core
Connect-VIServer -Server myvcenter.domain.com -User myuser@sovsystems.com -Password myPassw0rd

Get-Folder -Name MyTemplates | Get-VM | Set-VM -ToTemplate -Confirm:$false
Disconnect-VIServer -Server myvcenter.domain.com -Confirm:$false