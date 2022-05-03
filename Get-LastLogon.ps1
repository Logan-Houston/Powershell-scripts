##SDC Remote Installer Script v 1.0 ##
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

#Gets all computers from AD
$computers = Get-ADComputer -filter * -Properties * 
$total = $computers.count 
$x = 0

Write-Host "Scanning please be patient..." -ForegroundColor Cyan
#Gathers info from each computer and adds to hash table

foreach($computer in $computers) { 
$percentage = ($x / $total)*100
write-progress -Activity "Scanning, please be patient." -Status $Computer -PercentComplete $percentage
$date = (Get-Date).ToString("MM-dd-yyyy")
$path = "C:\Users\logan.houston.1\Desktop\'$date'_Test.csv"
$LastUser = Get-WinEvent  -Computername $computer.name -FilterHashtable @{Logname='Security';ID=4672} | Where-Object {-not(($_.Properties[0].Value -like  "S-1-5-18") -or ($_.Properties[0].Value -like  "S-1-5-19") -or ($_.Properties[0].Value -like  "S-1-5-20"))} | select -first 1 @{N='User';E={$_.Properties[1].Value}}
$computer | Select-Object @{Name="Computer";Expression={$_.Name}}, 
             @{Name="Lastlogon";Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}
$D1 = $computer.LastLogonDate
$D2 = get-date -format MM/dd/yyyy
$DaysSinceLogon = New-TimeSpan -start $d1 -End $d2

              # Create hashtable for properties
    $properties = [PSCustomObject] @{'Computer'=$Computer.Name;
                    'IP'=$computer.IPv4Address;
                    'LastLogon'=$computer.LastLogonDate;
                    'DaysSinceLogon'=$DaysSinceLogon.Days;
                    'LastUser'=$LastUser
                    'Enabled'=$computer.Enabled  
                   } #end $properties

    #Exports info to csv file
    $properties | Export-csv -Path $path -NoTypeInformation -append
    #Counter for progress bar
    $X++
}#End of foreach

