##This function takes 2 arguments, an array, and a scriptblock that will be executed on every member of the array



Function proccess-parallel($arr, $SB){
    #Create the Runspace Pool
    $RunspacePool = [RunspaceFactory]::CreateRunspacePool()

    #Open the pool
    $RunspacePool.Open()

    foreach ($obj in $arr){

        #Create a powershell object
        $Powershell = [PowerShell]::Create()

        #Specify the runspace to use
        $Powershell.RunspacePool = $RunspacePool

        #Add the script block to the processing
        $Powershell.AddScript($SB)

        #Add the current object as the parameter to the script block
        $Powershell.AddParameter($obj)

        #create a collection to hold the runspaces
        [Collections.ArrayList]$RunspaceCollection = [PSCustomObject]@{
            #put the running powershell process into the runspace property, this also starts the job
            Runspace = $Powershell.BeginInvoke()

            #assign the Powershell process itself to the powershell property
            Powershell = $Powershell
        }
    }

    $return = @()

    #While loop waits for 
    While($RunspaceCollection){
        #iterate through all runspaces in the collection, checking for results
        ForEach($Runspace in $RunspaceCollection.ToArray()){
            #check if the runspace is commpleted
            if($Runspace.RunSpace.IsCompleted){
                #if the runspace is completed, end invoking and assign the results to the $return variable
                $return += $Runspace.Powershell.EndInvoke($Runspace.RunSpace)

                #dispose of the powershell object
                $Runspace.Powershell.dispose()

                $RunspaceCollection.Remove($Runspace)
            }
        }
    }

    Return $return
}

