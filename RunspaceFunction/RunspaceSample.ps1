##sample script showing usage of runspaces
#gets some basic info about all servers in domain

#List of WMI objects to access
#win32_operatingsystem
#win32_SystemDriver
#win32_logicaldisk
#win32_share


$arr = get-adcomputer -filter *

$SB = {
    param($ComputerName)

    $return = "" | Select-Object OS,Driver,Disk,share

    $return.OS = Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName
    $return.Driver = Get-WmiObject Win32_SystemDriver -ComputerName $ComputerName
    $return.Disk = Get-WmiObject Win32_logicalDisk -ComputerName $ComputerName
    $return.share = Get-WmiObject win32_share -ComputerName $PSCommandPath

    return $return

}

process-paralell $arr $SB