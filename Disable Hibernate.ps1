#Written by A1C Logan Houston 366CS/SCOO#

#THIS PART IS FOR DOING ALL THE COMPUTERS IN A LIST
$Computers = Get-Content "filepath for CSV"
$total = $computers.count 
$x = 0
foreach ($Computer in $Computers) {
$percentage = ($x / $total)*100
write-progress -Activity "Progress" -Status $Computer -PercentComplete $percentage
Get-Service -ComputerName $computer -ServiceName WinRM | Start-Service
Invoke-Command -Computername $computer -ScriptBlock {

#Runs command line to change power configuration options and turn off all hibernation/sleep settings
cmd.exe /c "powercfg /change hibernate-timeout-ac 0"

cmd.exe /c "powercfg /change hibernate-timeout-dc 0"

cmd.exe /c "powercfg /change disk-timeout-ac 0"

cmd.exe /c "powercfg /change disk-timeout-dc 0"

cmd.exe /c "powercfg /change standby-timeout-ac 0"

cmd.exe /c "powercfg /change standby-timeout-dc 0"

cmd.exe /c "powercfg /change monitor-timeout-ac 0"

cmd.exe /c "powercfg /change monitor-timeout-dc 0"

cmd.exe /c "powercfg /hibernate off"
}
$x++
}