Function Get-Info{
    param(
        [Parameter(Mandatory=$True,Position=1)]
          [string]$FilePath
    )
    BEGIN{
        if(test-path $FilePath){
            $ServerList = Get-Content $FilePath
            $i = 0
        }
        else{
            return "Could not find file "+$FilePath
        }
    }
    PROCESS{
        write-host $ServerList[$i]
    }
    END{

    }
}