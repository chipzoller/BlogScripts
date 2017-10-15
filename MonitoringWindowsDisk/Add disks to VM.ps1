Connect-VIServer vcenter.domain.com -User myuser@domain.com -Password 'VMware1!'
$vm = Get-VM -Name myvmname
ForEach ($HardDisk in (1..22))
    { 
    New-HardDisk -VM $vm -CapacityGB 1 -StorageFormat Thin | New-ScsiController
    } 
