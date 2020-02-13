#Enter a path to your import CSV file
Import-Module ActiveDirectory
$ADUsers = Import-csv C:\scripts\newuser\newusers.csv

foreach ($User in $ADUsers)
{

       $OU          = "<OU Path>" # Speficy DN of the OU where you wish to create account
       $Username    = $User.username
       $Password    = $User.password
       $FullName    = $User.FullName
       $Firstname   = $User.firstname
       $Lastname    = $User.lastname
       $DisplayName = $User.DisplayName
       $Title       = $user.Title
       $Department  = $User.department
       $Manager     = $User.Manager # provide manager's AD Samaccount Name in the csv file
       $OfficePhone = $User.OfficePhone
       $MobilePhone = $User.MobilePhone
       $Company     = "<Organization's Name>" # Specify organization name
       $Country = "<Country Code>" # Specify county code e.g., US for USA, DE for Germany
       $GroupName1 = "<Group Name>" # Specify Group name if you want to add user in the any of the group
       $GroupName2 = "<Group Name>" # Specify Group name if you want to add user in the any of the group
       
       #Check if the user account already exists in AD
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #If user does exist, output a warning message
               Write-Warning "A user account $Username has already exist in Active Directory."
       }
       else
       {
              #If a user does not exist then create a new user account
          
        #Account will be created in the OU listed in the $OU variable in the CSV file; don’t forget to change the domain name in the"-UserPrincipalName" variable
              New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@qfz.gov.qa" `
            -Name $FullName `
            -GivenName $Firstname `
            -Surname $Lastname `
            -DisplayName $DisplayName `
            -Title $Title `
            -Department $Department `
            -Manager $Manager `
            -OfficePhone $OfficePhone `
            -MobilePhone $MobilePhone `
            -Company $Company `
            -City "Doha" `
            -Country $Country `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -Path $OU `
            -emailaddress "$username@qfz.gov.qa" `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) 
            
            write-host $userName 'has been created' -foregroundcolor DarkGreen
            
            #Adding newly created user to the security groups
            Add-ADGroupMember -Identity $GroupName1 -Members $userName
            write-host 'Account' $userName 'added' on $GroupName1 -foregroundcolor DarkGreen
            Add-ADGroupMember -Identity $GroupName2 -Members $userName
            write-host 'Account' $userName 'added' on $GroupName2 -foregroundcolor DarkGreen

                        }
}