#Remote Mass-Uninstaller V1.0
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

#Confirmation before starting the installation
Do{
#user selects the list of computers using file explorer
$File = Write-host "Please select .txt or .csv file with list of computers" -ForegroundColor Cyan | Select-File

#asks the user for the application name
$Application = read-host "Application Name: "

#gets the list of computers to uninstall  from the file selected above
$computers = Get-Content $File

$Confirmation = Read-Host -Prompt "You are about to uninstall $Application from $computers.count computers. Type CONFIRM to continue or press ENTER to return"
}
while ($Confirmation -ne "CONFIRM")

#searches for the Windows Management Interface Object for the specificed application then runs the uninstall method
foreach ($comp in $computers){
$app = Get-WmiObject -Class Win32_Product -computername $comp -Filter "Name LIKE '%$Application%'" | Out-Null
$appUninstall = $app.Uninstall()

#returns a completion or error message 
if ($appUninstall.returnvalue -eq 0)
        {Write-host "$Application successfully uninstalled from $comp" -ForegroundColor Green}
    Else
        {Write-Host "There was a problem uninstalling $Application from $comp" -ForegroundColor Red}
}
#Pauses to allow the user to review the results before closing the window
Read-Host "Review the results above or press ENTER to close this window"