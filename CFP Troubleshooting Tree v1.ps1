##CFP Troubleshooting Tree ##
##Written by SrA Logan Houston and SSgt Patrick Bennett 378 ECS/CFP ##
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

#Main Menu
Function Display-TroubleTree {
Clear-Host
""| Out-File -filepath $Filepath
Write-Host "Comm Focal Point Troubleshooting Tree" -ForegroundColor Cyan
Write-host "Developed by SSgt Patrick Bennett and SrA Logan Houston" -ForegroundColor Cyan
Write-host "1. Account(customer is not able to log in or needs access to sharedrive, distro, or org box access"
Write-host "2. Equipment (customer is asking for equipment)"
Write-host "3. Phone Book (Customer is looking for a number or dialing instructions)"
Write-host "4. Email (Customer states they are having issues related to email)"
Write-Host "5. Outage (customer calls stating whole office is experencing issues)"
Write-Host "6. SIPR Token (Customer wants to check the status of SIPR token request)"
Write-Host "7. Other (Customer has an issue that doesnt match the options availible and you don't know how to help them)"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "How may I help you today?"
switch ($select){
        1 {"Account Issue" | Out-File -filepath $Filepath -Append
        Choose-Network}
        2 {"Equipment Issue" | Out-File -filepath $Filepath -Append
        Choose-Equipment}
        3 {"Directed Customer to Phone Book Link"
        Read-Host "Inform customer to check the Phone book icon on their desktop for dialing instructions, check the GAL to find someone's number, or check the wing sharepoint for the numbers of organizations. Press ENTER to close this window"}
        4 {"Email-Issue"| Out-File -filepath $Filepath -Append
        Choose-Email}
        5 {"Outage" | Out-File -filepath $Filepath -Append
        Choose-Power}
        6 {"SIPR Token Issue" | Out-File -filepath $Filepath -Append
        Choose-2842}
        7 {Read-Host "Inform customer that you are unsure how to best help them over the phone and that they should send an email to the org box with as much details as possilbe so that we can better help them. Press ENTER to type a brief description of the issue for the log"
        Read-Host "Briefly Describe the Issue" | Out-File -filepath $Filepath -Append}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}

#Choose Network Classification
Function Choose-Network {
Clear-Host
Write-host "1. NIPR" -ForegroundColor Green
Write-host "2. SIPR" -ForegroundColor Red
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Which network?"
switch ($select){
        1 {"Network: NIPR"| Out-File -filepath $Filepath -Append
        Choose-Network2}
        2 {"Network: SIPR"| Out-File -filepath $Filepath -Append
        Choose-Network2}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Choose login or Access

Function Choose-Network2 {
Clear-Host
Write-host "1. Login"
Write-host "2. Access"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Is this for log in issues or for sharedrive, distrobution group, or org box access?"
switch ($select){
        1 {"Login Issue" | Out-File -filepath $Filepath -Append
        Choose-Login}
        2 {"Access Request"| Out-File -filepath $Filepath -Append
        Read-Host "Inform Customer to submit a ticket using the trouble ticket templates under the Comm Support Icon on their desktop. Press ENTER to close this window"}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}


#Are others having issues logging in as well
Function Choose-Login {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Are others having issues logging in as well?"
switch ($select){
        1 {"Outage" | Out-File -filepath $Filepath -Append
        Choose-Outage2}
        2 {"Single User" | Out-File -filepath $Filepath -Append
        Choose-Login2}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Are you able to log into other machines.
Function Choose-Login2 {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Are you able to log into other machines?"
switch ($select){
        1 {"Computer Issue" | Out-File -filepath $Filepath -Append
        Choose-Computer}
        2 {"Account Status" | Out-File -filepath $Filepath -Append
        Account-Status}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
Function Choose-Computer {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Are you able to log into other machines?"
switch ($select){
        1 {"User is able to log in to other machines" | Out-File -filepath $Filepath -Append
        Check-Link2}
        2 {"User is not able to log in to other machines" | Out-File -filepath $Filepath -Append
        Check-Link2}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Check for link lights
Function Check-Link2 {
Clear-Host
Write-host "1. Yes" -ForegroundColor Green
Write-host "2. No" -ForegroundColor Red
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Are the link lights turned on? They can be found on the network connection at the back of the computer"
switch ($select){
        1 {"Requested customer submit Connection Issue ticket" | Out-File -filepath $Filepath -Append
        Read-Host "Inform the the customer to submit ticket using the connection issue template and state whether only yourself or everyone cant login. Please press ENTER to close this window."}
        2 {"Requested customer submit Connection Issue ticket" | Out-File -filepath $Filepath -Append
        Read-Host "Inform the the customer to submit ticket using the connection issue template and state whether only yourself or everyone cant login. Please press ENTER to close this window."}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Have you logged in before
Function Account-Status {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Have you Logged in before?"
switch ($select){
        1 {"Verified/Corrected account information on ARS" | Out-File -filepath $Filepath -Append
        Write-Host "Check ARS for account, ensure User logon name is correct NIPR DODID+PIV@MIL and SIPR DODID.dutystatus@smil.mil"}
        2 {Account-Paperwork}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Was account paperwork submitted
Function Account-Paperwork {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Was account paperwork submitted?"
switch ($select){
        1 {"Checked for account paperwork status" | Out-File -filepath $Filepath -Append
        Read-Host "Check account paperwork first, then Check ARS for account, ensure User logon name is correct NIPR DODID+PIV@MIL and SIPR DODID.dutystatus@smil.mil. Press ENTER to close this window."}
        2 {"Requested customer submit account creation paperwork" | Out-File -filepath $Filepath -Append
        Read-Host "Inform customer to submit paperwork using the templates in NIPR or SIPR access folder under Comm Support Icon. Press ENTER to close this window."}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#What Type of equipment
Function Choose-Equipment {
Clear-Host
Write-host "1. Periphreals such as keyboards, mice, or KVM"
Write-host "2. New device such as printer, computer, scanner"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "What Type of equipment"
switch ($select){
        1 {"Trasferred customer to BECO" | Out-File -filepath $Filepath -Append
        Read-Host "Transfer customer to BECO"}
        2 {Choose-Newcomputer}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#New equipment
Function Choose-Newcomputer {
Clear-Host
Write-host "1. Replacement Equipment"
Write-host "2. New Requirement"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Is this for a new requirement or replacement?"
switch ($select){
        1 {"Replacement Equipment - directed customer to their unit ITEC manager or Resource Advisor"| Out-File -filepath $Filepath -Append
        Read-Host "Inform user to contact their ITEC account manager or Resource Advisor to submit a request. Press ENTER to close this window"}
        2 {"New Equipment- instructed customer to submit 3215"| Out-File -filepath $Filepath -Append
        Read-Host "Inform user to submit a 3215 to Plans and Requirements using the template under the Comm Support Icon on their desktop. Press ENTER to close this window"}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#SIPR Token
Function Choose-2842 {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Have you submitted a 2842?"
switch ($select){
        1 {"Verified customer's 2842 status in TA folder and remedy" | Out-File -filepath $Filepath -Append
        Read-Host "Check status by checking TA folder and check Remedy for ticket. Press ENTER to close this window"}
        2 {"Instructed customer to complete and submit 2842 SIPR token request" | Out-File -filepath $Filepath -Append
        Read-Host "Inform customer to submit 2842 using template under comm support icon in SIPR access folder. Submit to 378 ECS/CFP Org Box. Press ENTER to close this window"}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Email Issue
Function Choose-Email {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Is anyone else in your work area experiencing this as well?"
switch ($select){
        1 {"Possible Outage"| Out-File -filepath $Filepath -Append
        Check-Web}
        2 {"Single User"| Out-File -filepath $Filepath -Append
        Choose-Email2}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Just your machine email? make another tree for check OWA
Function Choose-Email2 {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Do you have this issue on other machines?"
switch ($select){
        1 {"Checked if user has correct email in ARS, recreated account if needed"| Out-File -filepath $Filepath -Append
        read-host "Check account in ARS to confirm email was created and customer is using correct email address. Press ENTER to close this window"}
        2 {"Guided user through recreating outlook profile"| Out-File -filepath $Filepath -Append
        read-host "Recreate outlook profile Press ENTER to close this window"}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Check for power
Function Choose-Power {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Does your building have power?"
switch ($select){
        1 {"Building has power." | Out-File -filepath $Filepath -Append
        Choose-Outage}
        2 {"Building does not have power." | Out-File -filepath $Filepath -Append
        Read-Host "Advise customer we are unable to troubleshoot network issues until power is back on. The number for CE is located on the fourth page of the phonebook on your desktop. Press ENTER to close this window."}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}

#Customer reporting an outage
Function Choose-Outage {
Clear-Host
Write-host "1. NIPR" -ForegroundColor Green
Write-host "2. SIPR" -ForegroundColor Red
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Which Network is this on?"
switch ($select){
        1 {"NIPR"| Out-File -filepath $Filepath -Append
        Check-Link}
        2 {"SIPR" | Out-File -filepath $Filepath -Append
        Check-Link}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Check for link lights
Function Check-Link {
Clear-Host
Write-host "1. Yes" -ForegroundColor Green
Write-host "2. No" -ForegroundColor Red
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Are the link lights turned on? They can be found on the network connection at the back of the computer"
switch ($select){
        1 {"Link lights are on"| Out-File -filepath $Filepath -Append
        Choose-Outage2}
        2 {"Link Lights are off" | Out-File -filepath $Filepath -Append
        Choose-Outage2}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}



#outage part 2
Function Choose-Outage2 {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Is the issue occuring when logging in?"
switch ($select){
        1 {"Issue is affecting Log-in" | Out-File -filepath $Filepath -Append
        Check-Phones}
        2 {"Issue is not affecting Log-in" | Out-File -filepath $Filepath -Append
        Check-Email}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Check phones for outage
Function Check-Phones {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Are the phones down as well for the attached network?"
switch ($select){
        1 {"Issue is affecting phones" | Out-File -filepath $Filepath -Append
        read-host "Gather building # and contact info inform them you will create a ticket and notify the back shops. Press ENTER to type in information for log"
        read-host "Type in Building number and Customer Contact information" | Out-File -filepath $Filepath -Append}
        2 {"Issue is not affecting phones" | Out-File -filepath $Filepath -Append
        read-host "Gather building # and contact info inform them you will create a ticket and notify the back shops. Press ENTER to type in information for log"
        read-host "Type in Building number and Customer Contact information" | Out-File -filepath $Filepath -Append}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Check web access for outage
Function Check-Web {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Can you surf the web?"
switch ($select){
        1 {"Issue is affecting internet connectivity" | Out-File -filepath $Filepath -Append
        Check-Sharedrive}
        2 {"Issue is not affecting internet connectivity" | Out-File -filepath $Filepath -Append
        Check-Sharedrive}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Check email access for outage
Function Check-Email {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Can you access your email?"
switch ($select){
        1 {"Issue is affecting Email access"| Out-File -filepath $Filepath -Append
        Check-Web}
        2 {"Issue is not affecting Email Access" | Out-File -filepath $Filepath -Append
        Check-Web}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Check sharedrive for outage
Function Check-Sharedrive {
Clear-Host
Write-host "1. Yes"
Write-host "2. No"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "Can you access your sharedrive?"
switch ($select){
        1 {"Issue is affecting share drive access" | Out-File -filepath $Filepath -Append
        Check-KnownIssue}
        2 {"Issue is not affecting share drive access" | Out-File -filepath $Filepath -Append
        Check-KnownIssue}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
#Check if outage is a known issue
Function Check-KnownIssue {
Clear-Host
Write-host "1. Issue is part of a larger outage/known issue"
Write-host "2. NOT part of a larger outage/known issue"
Write-Host "H. Return to main menu" -ForegroundColor Yellow
Write-Host "Q. Exit This Tool" -ForegroundColor Yellow
$select = read-host "After Information has been provided, confirm that it isn't part of a bigger outage"
switch ($select){
        1 {read-host "Inform the customer that it is part of a known issue, a ticket has been already created and is being worked. Press ENTER to type in a reference ticket number for the log"
        Read-Host "Type in reference ticket number for known issue" | Out-File -filepath $Filepath -Append}
        2 {"New Outage" | Out-File -filepath $Filepath -Append
        read-host "Gather building # and contact info inform them you will create a ticket and notify the back shops. Press ENTER to type in information for log"
        read-host "Type in Building number and Customer Contact information" | Out-File -filepath $Filepath -Append}
        H {Display-TroubleTree}
        Q {return}
        Default {
            Write-Host "$select is an invalid Option." -ForegroundColor Red
            Read-Host "Press enter to return to the menu"
            Display-TroubleTree
        }
    }
}
Write-Host "Comm Focal Point, This is (Rank, Name) May I have your Squadron, Rank, and Name please?"
$DateDay = Get-Date -Format "dd MM yyy"
$DateTime = Get-Date -Format "HHmm"
$Customer = Read-Host "Input customer SQ, Rank, and Name"
$FileName = "$customer" + " " +"$DateTime" + ".txt"
$Filepath = "C:\Users\$env:USERNAME\Desktop\Call Logs\$DateDay\$FileName"
$test1 = Test-Path "C:\Users\$env:USERNAME\Desktop\Call Logs"
if ($test1 -eq $true) {}
Else {New-Item -Path "C:\Users\$env:USERNAME\Desktop\" -Name "Call Logs" -ItemType "directory"}
$test2 = Test-Path "C:\Users\$env:USERNAME\Desktop\Call Logs\$DateDay"
if ($test2 -eq $true) {}
Else {New-Item -Path "C:\Users\$env:USERNAME\Desktop\Call Logs" -Name "$DateDay" -ItemType "directory"}
New-Item -Path $Filepath
Display-TroubleTree