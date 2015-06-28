Import-Module ActiveDirectory

$UserFile = import-csv "c:\data\users.csv"

foreach($user in $UserFile){
    $Password = $User.password | ConvertTo-SecureString -AsPlainText -Force
    $FullName = $User.First_Name+" "+$User.Last_Name

    New-ADUser -Name $FullName -DisplayName $FullName -GivenName $User.First_Name -Surname $User.Last_Name -UserPrincipalName $User.User_Name -SamAccountName $User.User_name -Path "OU=BasicUsers,DC=LAB,DC=Poshscript,DC=Com" -AccountPassword $Password -Enabled $True
}