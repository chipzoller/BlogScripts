Add-PsSnapin VMware.VimAutomation.Core
Connect-VIServer -Server myvcenter.domain.com -User myuser@domain.com -Password myPassw0rd

Get-VM -Tag "MyTemplate" | Set-VM -ToTemplate -Confirm:$false
Disconnect-VIServer -Server myvcenter.domain.com -Confirm:$false