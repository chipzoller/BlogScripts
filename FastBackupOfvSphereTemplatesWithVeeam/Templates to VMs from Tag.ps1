Add-PsSnapin VMware.VimAutomation.Core
Connect-VIServer -Server myvcenter.domain.com -User myuser@domain.com -Password myPassw0rd

function Get-TemplateWithTag{
param(
$TagNameArray
)
    process{
    $AllTemplatesAndTag = get-template | foreach {($MyTemplate = $_)} | get-tagassignment | select-object @{name="Template";Expression={$MyTemplate}}, @{name="TagName";Expression={$_.tag.Name}},@{name="TagCategory";Expression={$_.tag.Category}}
 
    $AllTemplateWithDuplicate = $AllTemplatesAndTag | foreach-object{
            if ($TagNameArray -contains $_.TagName){
            $_.Template
            }
        }
   
    $AllTemplateWithoutDuplicate = $AllTemplateWithDuplicate | get-unique
    $AllTemplateWithoutDuplicate
    }
}
#####Begin working area#####
$TagNameArray = "MyTemplate"
Get-TemplateWithTag -TagNameArray $TagNameArray | Set-Template -ToVM
Disconnect-VIServer -Server myvcenter.domain.com -Confirm:$false