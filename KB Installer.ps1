##KB Remote Installer Script v 1.0 ##
##Written by A1C Logan Houston 366CS/SCOO ##

#Custom function to get file path using windows explorer
Add-Type -AssemblyName System.Windows.Forms
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

#Custom function to get folder path using windows explorer
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

#Variables to designate the computers to target and the folder with the Patch
$File = Write-host "Please select .txt or .csv file with list of computers" -ForegroundColor Cyan | Select-File
$Patch = Write-host "Please select .MSU file of the KB you want to patch" -ForegroundColor Cyan | Select-File
$Computers = get-content $File
$PatchName = split-path $Patch -leaf
$Cab = (Get-Item $Patch).BaseName + ".cab"

#creates a log saved at C:\temp\Script.log
$test = test-path -path "C:\Temp" 
if ($test -eq $true) {}
Else {New-Item -Path "C:\" -Name "Temp" -ItemType "directory"}
Start-Transcript -Path "C:\temp\$Patchname Install.log"
Write-Host "Creating Log File at C:\temp\$Patchname Install.log"


Foreach($Computer in $Computers){
    #Checks if computer is on
    $Ping = Test-Connection -ComputerName $Computer -count 1 -quiet

    If($Ping -eq $true){
        Write-host $computer "Online!" -ForegroundColor Green
        #Turns on WinRM
       Get-service -ComputerName $Computer -Servicename WinRM |Start-Service
       #Checks if Temp folder exists, if not creates it
       $Temp = test-path -Path \\$Computer\C$\Temp
       If($Temp -eq $True){}
       Else{Invoke-command -ScriptBlock {New-Item -path C:\ -Name "Temp" -ItemType directory}}
       #Copies the Patch we designated to the Temp folder
       cp $Patch \\$Computer\C$\Temp  
        
       Write-host $Computer "Patch Copied" -ForegroundColor Green
       #expands the .msu then starts the install command on the remote computer as a job
       expand -F:* \\$Computer\C$\Temp\$Patchname \\$Computer\C$\Temp
       Invoke-Command -ComputerName $Computer -ScriptBlock {
       Add-WindowsPackage -online -PackagePath C:\Temp\$Using:Cab -Quiet -NoRestart} -asjob
       

       Write-host $computer "Installation Started" -ForegroundColor Green
       }#End of IF
       Else{Write-host $Computer "Offline" -ForegroundColor Yellow}
    }#End of Foreach
    
    Write-Host "Wrapping up installs..." -ForegroundColor Cyan
    Get-Job | Wait-job

    Stop-Transcript