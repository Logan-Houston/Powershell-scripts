get-aduser -Filter *  -SearchBase "OU=Users,OU=PSAB,DC=psab,DC=centaf,DC=ds,DC=af,DC=mil" -Properties DisplayName, organization, OfficePhone, UserPrincipalName, mail | Export-Csv -Path C:\Users\logan.houston.1\Desktop\Test.csv


