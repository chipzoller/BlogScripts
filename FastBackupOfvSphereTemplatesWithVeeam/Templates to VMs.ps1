Add-PsSnapin VMware.VimAutomation.Core
Connect-VIServer -Server myvcenter.domain.com -User myuser@domain.com -Password myPassw0rd

Get-Folder -Name MyTemplates | Get-Template | Set-Template -ToVM
Disconnect-VIServer -Server myvcenter.domain.com -Confirm:$false