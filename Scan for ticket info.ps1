##Written by SrA Logan Houston 378 ECS/SCOS ##
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
#Right click this file and select "run with powershell" to get information about your computer for creating tickets
Write-Host "Scanning your computer please wait..." -ForegroundColor Cyan
$HostIP = (Get-NetIPConfiguration |Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}).IPv4Address.IPAddress
$Mac = Get-CimInstance win32_networkadapterconfiguration | select description, macaddress | where {$_.MACAddress -ne $null }  | where {$_.Description -Like "*Ethernet*"} 

Write-host "Your computer name is" $env:COMPUTERNAME -ForegroundColor Green
Write-host "Your IP Address is" $HostIP -ForegroundColor Green
Write-host "Your MAC Address is" $Mac.macaddress -ForegroundColor Green
Read-host "Press ENTER to close this window"