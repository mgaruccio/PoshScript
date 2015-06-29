##sample script showing usage of runspaces
#gets some basic info about all servers in domain


$arr = get-adcomputer -filter *

$arr = $arr | . {Process{$_.Name}}

$SB = {
    param($Computer)

    $return = "" | Select-Object OS,Driver,Disk,Share

    
    $return.OS = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer
    $return.Driver = Get-WmiObject Win32_SystemDriver -ComputerName $Computer
    $return.Disk = Get-WmiObject Win32_logicalDisk -ComputerName $Computer
    $return.share = Get-WmiObject win32_share -ComputerName $Computer
    

    #$return.OS = Get-WmiObject Win32_OperatingSystem -ComputerName "RDS1"

    return $Return

}

process-parallel $arr $SB