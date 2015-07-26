function get-info($computerName){
    $return = "" | Select-Object OS,Driver,Disk,Share
        
    $return.OS = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer.name
    $return.Driver = Get-WmiObject Win32_SystemDriver -ComputerName $Computer.name
    $return.Disk = Get-WmiObject Win32_logicalDisk -ComputerName $Computer.name
    $return.share = Get-WmiObject win32_share -ComputerName $Computer.name

    return $Return
}