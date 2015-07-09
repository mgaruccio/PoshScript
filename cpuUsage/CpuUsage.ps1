
Function get-cpuUsage{

    Param(
        [Parameter(Position=1)]
        $computerName = $env:COMPUTERNAME
      )

    $Processes = [diagnostics.process]::GetProcesses($computerName)


    $ProcNum = (Get-WmiObject win32_processor -Property numberoflogicalprocessors).numberoflogicalprocessors

    $arr1 = @()

    foreach ($process in $Processes){
        $arr1 += [PsCustomObject]@{
            name = $process.ProcessName
            cpu = $process.cpu
        }
    }

    Start-Sleep -Seconds 1

    $arr2 = @()

    foreach ($process in $Processes){
        $arr2 += [PsCustomObject]@{
            name = $process.ProcessName
            cpu = $process.cpu
        }
    }

    $return = @()


    for($i=0;$i -le $arr1.count;$i++){
        $return += [PSCustomObject]@{
            name = $arr1[$i].name
            time = ($arr2[$i].cpu - $arr1[$i].cpu) / $ProcNum * 100
        }
    }

    $return

}

get-cpuUsage