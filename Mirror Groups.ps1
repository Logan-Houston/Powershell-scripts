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

#This script requires RSAT tools to be installed to function
#Asks user for the names of the customers to copy to/from
$Read1 = read-host "Please enter Last First of the person you want to copy the groups FROM"
$Read2 = read-host "Please enter Last First of the person you want to copy the groups TO"
#adds a wildcard so that the user doen't need the FQN of the customer
$user1 = $read1 + "*"
$user2 = $read2 + "*"
#Gets the group membership of the first user and adds to the second user
$Groups1 = Get-ADUser -Filter 'name -like $User1'  -SearchBase "User Account OU Goes Here" -Properties Memberof | Select Memberof
Get-aduser -Filter 'Name -Like $User2' |Add-ADPrincipalGroupMembership -MemberOf $Groups1
