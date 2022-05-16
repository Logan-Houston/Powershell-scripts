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
#Sends a custom message to the specified computer. Message must be in quotation marks, and requires workstation admin privilages.
$Credentials = Get-Credential -Message "Please provide .CSA credentials"
$Computer = Read-Host "Type in the name of the computer you want to message"
$MSG = Read-Host "Type in the message you want to display in quotation marks"
Invoke-command -Credential $Credentials -computer $Computer -ArgumentList $MSG { 
Param( $MSG)
msg */Server:localhost "$MSG"}
Read-Host "Message sent to $Computer, Press ENTER to close this window"