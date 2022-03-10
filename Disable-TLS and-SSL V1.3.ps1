###WRITTEN BY A1C LOGAN HOUSTON 366CS WITH CONTRIBUTIONS BY SRA BRANDON WARNER###
##CHANGELOG
#V1.0 Initial Release
#V1.1 Combined TLS 1.0, Weak Cipher, and Sweet32 fix into one script due to overlaps in function
#V1.2 Added Logging and Delayed start
#V1.3 Added Select-File function for improved usabillity 

#Select-File Function opens file browser to select a file and outputs file path
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
$File = Write-host "Please select .txt file with list of computers" -ForegroundColor Cyan | Select-File

#creates a log saved at C:\temp\Script.log
$test = test-path -path "C:\Temp" 
if ($test -eq $true) {}
Else {New-Item -Path "C:\" -Name "Temp" -ItemType "directory"}
Start-Transcript -Path C:\temp\Script.log
Write-Host "Creating Log File at C:\temp\Script.log"

#Script timing - User Defines hours, math defines Time To Start - SrA Warner 366CS
    $thyme = Read-Host 'How many hours before script start?'
    $thym2 = Read-Host 'How many minutes before script start?'
    $second1 = ([int]$thyme * 3600)
    $second2 = ([int]$thym2 * 60)
    $seconds = ($second1 + $second2)
    $epoch = Get-Date
    $tts = $epoch.AddSeconds($seconds)
    Write-Host "Script Will Launch at $tts"

Start-Sleep -Seconds $seconds

##THIS PART IS FOR DOING ALL THE COMPUTERS IN A LIST

$Computers = Get-Content $File
$total = $computers.count 
$x = 0
foreach ($Computer in $Computers) {
$percentage = ($x / $total)*100
write-progress -Activity "Progress" -Status $Computer -PercentComplete $percentage
#Get-Service -ComputerName $Computer -ServiceName WinRM | Start-Service
Invoke-Command -Computername $computer -ScriptBlock {

##THIS PART CREATES REGISTRY OBJECTS TO DISABLE WEAK PROTOCOLS AND ENABLE 1.2 BY DEFAULT
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -name 'Enabled' -value '1' -Type 'DWord' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -name 'DisabledByDefault' -value 0 -Type 'DWord' -Force | Out-Null
    
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -name 'Enabled' -value '1' -Type 'DWord' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -name 'DisabledByDefault' -value 0 -Type 'DWord' -Force | Out-Null
 
Write-Host "$Computer TLS 1.2 has been enabled."

New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server' -name 'Enabled' -value '0' -Type 'DWord' -Force | Out-Null
            
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server' -name 'DisabledByDefault' -value 1 -Type 'DWord' -Force | Out-Null
            
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client' -Force | Out-Null
            
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client' -name 'Enabled' -value '0' -Type 'DWord' -Force | Out-Null
            
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client' -name 'DisabledByDefault' -value 1 -Type 'DWord' -Force | Out-Null
Write-Host "$Computer SSL 2.0 has been disabled."

New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server' -name 'Enabled' -value '0' -Type 'DWord' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server' -name 'DisabledByDefault' -value 1 -Type 'DWord' -Force | Out-Null
    
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client' -name 'Enabled' -value '0' -Type 'DWord' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client' -name 'DisabledByDefault' -value 1 -Type 'DWord' -Force | Out-Null
Write-Host "$Computer SSL 3.0 has been disabled."

New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -name 'Enabled' -value '0' -Type 'DWord' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -name 'DisabledByDefault' -value 1 -Type 'DWord' -Force | Out-Null
    
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -name 'Enabled' -value '0' -Type 'DWord' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -name 'DisabledByDefault' -value 1 -Type 'DWord' -Force | Out-Null
Write-Host "$Computer TLS 1.0 has been disabled."

New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -name 'Enabled' -value '0' -Type 'DWord' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -name 'DisabledByDefault' -value 1 -Type 'DWord' -Force | Out-Null
    
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -name 'Enabled' -value '0' -Type 'DWord' -Force | Out-Null
    
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -name 'DisabledByDefault' -value 1 -Type 'DWord' -Force | Out-Null
Write-Host "$Computer TLS 1.1 has been disabled."

#THIS PART CREATES REGISTRY OBJECTS TO DISABLE WEAK CIPHER SUITES

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Null" -Force | Out-Null
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Null" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56" -Force | Out-Null
md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56" -Force | Out-Null
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40" -Force | Out-Null
md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128" -Force | Out-Null
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56" -Force | Out-Null
md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128" -Force | Out-Null
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128" -Force | Out-Null
md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128" -Force | Out-Null
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40" -Force | Out-Null
md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" -Force | Out-Null
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56" -Force | Out-Null
md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128" -Force | Out-Null
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64" -Force | Out-Null
md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128" -Force | Out-Null
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

#This cipher can still show up on scans, but it may also break RDP in some cases if you disable it. proceed with caution.

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168" -Force | Out-Null
md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168/168" -Force | Out-Null
New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null
New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168/168" -name "Enabled" -value 0 -Type "Dword" -Force | Out-Null

Disable-TlsCipherSuite -name "TLS_RSA_WITH_NULL_SHA"
Disable-TlsCipherSuite -name "TLS_RSA_WITH_3DES_EDE_CBC_SHA"
Disable-TlsCipherSuite -name "TLS_RSA_WITH_AES_128_CBC_SHA"
Disable-TlsCipherSuite -name "TLS_RSA_WITH_AES_256_CBC_SHA"
Disable-TlsCipherSuite -name "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"
Disable-TlsCipherSuite -name "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA"
Disable-TlsCipherSuite -name "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA"
Disable-TlsCipherSuite -name "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA"

Write-Host "$Computer Weak cipher suites disabled"
}
$x ++
}
Stop-Transcript