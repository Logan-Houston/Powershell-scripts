#Written by A1C Logan Houston 366 CS/SCOO#
Function Get-Folder($initialDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

$Drive = Write-Host "Please Select the Folder to Check" | Get-Folder
$TargetGroup = Read-Host 'Enter the group name you want to check'

Write-host "Report will be saved to C:\Temp\Permissions.csv"
$test = test-path -path "C:\Temp" 
if ($test -eq $true) {}
Else {New-Item -Path "c:\" -Name "Temp" -ItemType "directory"}

Get-Childitem "$Drive" -Recurse | Get-ACL | ?{$_.Access.IdentityReference -Match "$TargetGroup"} |Select Path, Owner, AccessToString | Export-CSV -path C:\Temp\Permissions.csv

Write-host "Completed"
