#This script parses through the logs for a Phishing exercise and consolidates the pertinent information into an excel sheet for debriefing
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
#Gets the log file and filters out the relevant strings
$string = "200", "304"
$log = get-content -path "C:\Users\logan.houston.1\Desktop\u_ex220620.log" |select-string -Pattern $string | select-string -pattern "favicon.ico" -notmatch
#filters out the specific user's names
$username = $log -split " " 
$UniqueUsers = $username |Select-string -pattern "PSAB-N" | sort | Get-Unique
#loops through each user and counts how many times they appear in the original log
foreach($user in $UniqueUsers){
$actualName = $user -replace "(PSAB-N\\)"
$appears = $log | select-string -pattern $actualName
$appearscount = $appears.count
#gets proper naming from active directory
$Displayname = Get-ADUser -Filter "SamAccountName -like '$actualName'" -Properties * 

#organizes the data into a table and adds to a csv
$properties = [PSCustomObject] @{'First Name' = $Displayname.GivenName;
                                'Last Name' = $Displayname.Surname
                                'Organization' =$Displayname.Organization
                                'Rank' = $Displayname.PersonalTitle
                                'Number of Clicks' = $appearscount
                                }
$properties | Export-csv -Path "C:\Users\logan.houston.1\Desktop\ParsedResults.csv" -NoTypeInformation -Append
}