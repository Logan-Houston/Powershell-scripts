#THIS PART IS FOR DOING ALL THE COMPUTERS IN A LIST
$Computers = Get-Content "filepath for CSV"
$total = $computers.count 
$x = 0
foreach ($Computer in $Computers) {
$percentage = ($x / $total)*100
write-progress -Activity "Progress" -Status $Computer -PercentComplete $percentage
Get-Service -ComputerName $Computer -ServiceName WinRM | Start-Service
Invoke-Command -Computername $Computer -ScriptBlock {

Stop-Service -Name Spooler -Force

Set-Service -Name Spooler -StartupType Disabled
}
$x++
}