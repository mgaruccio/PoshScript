
Function get-cpuUsage{

    Param(
          $ComputerName = $env:COMPUTERNAME,
          $ID
      )

    
    if($ID){
        $proc = [diagnostics.process]::GetProcessById($ID) 
    }
    else{
        $Processes = [diagnostics.process]::GetProcesses($ComputerName)
    }


    $ProcNum = (Get-WmiObject win32_processor -Property numberoflogicalprocessors -ComputerName $ComputerName).numberoflogicalprocessors

    $arr1 = @()
    $arr2 = @()
    $return = @()


    if($proc){
        $arr1 += [PsCustomObject]@{
            name = $proc.ProcessName
            cpu = $proc.cpu
        }
    }
    else{
        ForEach ($process in $Processes){
            $arr1 += [PsCustomObject]@{
                name = $process.ProcessName
                cpu = $process.cpu
            }
        }
    }
    $process = $null
    Start-Sleep -Seconds 1   

    if($proc){
        $arr2 += [PsCustomObject]@{
            name = $proc.ProcessName
            cpu = $proc.cpu
        }
    }
    else{
        ForEach ($process in $Processes){
            $arr2 += [PsCustomObject]@{
                name = $process.ProcessName
                cpu = $process.cpu
            }
        }
    }

    for($i=0;$i -le $arr1.count;$i++){
        $return += [PSCustomObject]@{
            name = $arr1[$i].name
            time = (($arr2[$i].cpu - $arr1[$i].cpu)) / $ProcNum * 100
        }
    }

    if($id){
        $return[0]
    }
    else{
        $return
    }
}

get-cpuUsage


