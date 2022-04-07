##SDC Remote Installer Script v 1.0 ##
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

#Variables to designate the computers to target and the folder with the SDC
$File = Write-host "Please select .txt or .csv file with list of computers" -ForegroundColor Cyan | Select-File
$Folder = Write-host "Please select folder of SDC you want to install" -ForegroundColor Cyan | Get-Folder
$Computers = get-content $file
$Foldername = split-path $folder -leaf

#creates a log saved at C:\temp\Script.log
$test = test-path -path "C:\Temp" 
if ($test -eq $true) {}
Else {New-Item -Path "C:\" -Name "Temp" -ItemType "directory"}
Start-Transcript -Path "C:\temp\$Foldername Install.log"
Write-Host "Creating Log File at C:\temp\$Foldername Install.log"


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
       Else {New-Item -path \\$Computer\C$ -Name "Temp" -ItemType directory}

       #Copies the entire SDC folder we designated to the Temp folder
       Robocopy $Folder "\\$Computer\C$\Temp" /s /r:1 | Out-Null
        
       Write-host $Computer "SDC Copied" -ForegroundColor Green
       #Starts the install command on the remote computer as a job
       Invoke-Command -ComputerName $Computer -ScriptBlock {Start-Process -wait -filepath "C:\Temp\$Foldername\Install.cmd"} -asjob
       Write-host $Computer "Installation Started" -ForegroundColor Green
       }#End of IF
       Else{Write-host $Computer "Offline" -ForegroundColor Yellow}
    }#End of Foreach
    
    Write-Host "Wrapping up installs..." -ForegroundColor Cyan
    Get-Job | Wait-job

    Stop-Transcript
