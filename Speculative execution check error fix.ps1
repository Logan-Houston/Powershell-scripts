###WRITTEN BY A1C LOGAN HOUSTON 366CS###

#THIS PART IS FOR DOING ALL THE COMPUTERS IN A LIST
$Computers = Get-Content "list of computers"
$total = $computers.count 
$x = 0
foreach ($Computer in $Computers) {
$percentage = ($x / $total)*100
write-progress -Activity "Progress" -Status $Computer -PercentComplete $percentage
#Get-Service -ComputerName $Computer -ServiceName WinRM | Start-Service
Invoke-Command -Computername $Computer -ScriptBlock {

#sets to reccomended settings per CVE
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 8 /f

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 72 /f

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f
} ## End of script block
$x++
} ## end of FOREACH loop