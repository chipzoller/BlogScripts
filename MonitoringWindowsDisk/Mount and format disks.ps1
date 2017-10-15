Update-HostStorageCache
$disknum = (Get-Disk | Where partitionstyle -eq 'raw').Number
Foreach ($stuff in $disknum){
Initialize-Disk -Number $stuff -PartitionStyle MBR -PassThru |
New-Partition -AssignDriveLetter -UseMaximumSize |
Format-Volume -FileSystem NTFS -Confirm:$false
}
