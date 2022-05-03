get-aduser -Filter *  -SearchBase "OU for User Accounts goes here" -Properties DisplayName, organization, OfficePhone, UserPrincipalName, mail | Export-Csv -Path C:\Users\logan.houston.1\Desktop\Test.csv


