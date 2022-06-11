#Application checker V1.0
##Written by SrA Logan Houston 378 ECS SCOS
<#MIT License

Copyright (c) 2022 Logan-Houston

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE
#>

#Custom function to get folder path using windows explorer
Add-Type -AssemblyName System.Windows.Forms
function Select-File {

    [CmdletBinding()]

    param(
        [Parameter(ParameterSetName="Single")]
        [Parameter(ParameterSetName="Multi")]
        [Parameter(ParameterSetName="Save")]
        [string]$StartingFolder = [environment]::getfolderpath("mydocuments"),

        [Parameter(ParameterSetName="Single")]
        [Parameter(ParameterSetName="Multi")]
        [Parameter(ParameterSetName="Save")]
        [string]$NameFilter = "All Files (*.*)|*.*",

        [Parameter(ParameterSetName="Single")]
        [Parameter(ParameterSetName="Multi")]
        [Parameter(ParameterSetName="Save")]
        [switch]$AllowAnyExtension,

        [Parameter(Mandatory=$true,ParameterSetName="Save")]
        [switch]$Save,

        [Parameter(Mandatory=$true,ParameterSetName="Multi")]
        [Alias("Multi")]
        [switch]$AllowMulti
    )

    if ($Save) {
        $Dialog = New-Object -TypeName System.Windows.Forms.SaveFileDialog
    } else {
        $Dialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
        if ($AllowMulti) {
            $Dialog.Multiselect = $true
        }
    }
    if ($AllowAnyExtension) {
        $NameFilter = $NameFilter + "|All Files (*.*)|*.*"
    }
    $Dialog.Filter = $NameFilter
    $Dialog.InitialDirectory = $StartingFolder
    [void]($Dialog.ShowDialog())
    $Dialog.FileNames
}

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
#gets list of computers to scan
$File = Write-host "Please select .txt or .csv file with list of computers" -ForegroundColor Cyan | Select-File

#file path to save results
$path = Write-host "Please select location to save results. This window may pop-up behind powershell" -ForegroundColor Cyan | Get-Folder
$path = "$path\Results.csv"

#asks the user for the application name
$Application = read-host "Application Name: "

#gets the list of computers to uninstall  from the file selected above
$computers = Get-Content $File
$count = $computers.count
$x = 0

foreach ($comp in $computers){
$Percentage = ($x /$count)*100
Write-Progress -Activity "Scanning, Please wait..." -Status $comp -PercentComplete $percentage
#Checks if computer is on
    $ping = Test-Connection -ComputerName $comp -Count 1 -Quiet
    If( $ping -eq $true){

       #searches for the Windows Management Interface Object for the specificed application 
        $Installation1 = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue | Where {$_.DisplayName -like "*$Application*"}) -ne $null
        $Installation2 = (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue | Where {$_.DisplayName -like "*$Application*"}) -ne $null
   
        #returns a completion or error message 
        if ((-Not $Installation1) -or (-Not $Installation2))
                {$NotInstalled = $comp}
            Else
                 {$Installed = $comp}
    }
Else
    {$Connection = $comp}

$properties = [PSCustomObject] @{'Installed' = $Installed;
                                'Not Installed' = $NotInstalled
                                'Connection error' = $Connection
                                }
$properties | Export-csv -Path $path -NoTypeInformation -Append
Clear-Variable -Name "Installed" -ErrorAction SilentlyContinue
Clear-Variable -Name "NotInstalled" -ErrorAction SilentlyContinue
Clear-Variable -Name "Connection" -ErrorAction SilentlyContinue
$x++
}

#Pauses to allow the user to review the results before closing the window
Write-Host "Scan Complete. Check results at $path" -ForegroundColor Green