Function Generate-messagebox(){
    
    [cmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=1)]
          [string]$message,
        [Parameter(Mandatory=$False,Position=2)]
          [string]$header = "Information",
        [Parameter(Mandatory=$False,Position=3)]
          [string]$buttonType = "OK",
        [Parameter(Mandatory=$False,Position=4)]
          [string]$icon = "None",
        [Parameter(Mandatory=$False,Position=5)]
          [int32]$timeout = 0
    )

    [int32]$type = 0
    [int32]$iconInt = 0

    if($buttonType){
        Switch($buttonType){
            OK {$type = 0}
            OKCancel {$type = 1}
            AbortRetryIgnore {$type = 2}
            YesNoCancel {$type = 3}
            YesNo {$type = 4}
            RetryCancel {$type = 5}
            Default {Throw "ButtonType is not set to an acceptable value"}
        }
    }
    if($icon){
        Switch($icon){
            None {$iconInt = 0}
            Stop {$iconInt = 16}
            Question {$iconInt = 32}
            Exclamation {$iconInt = 48}
            Information {$iconInt = 64}
            Default {Throw "IconType is not set to an acceptable value"}
        }
    }

    $INT = $Type+$iconInt


    $wshell = New-Object -ComObject Wscript.Shell
    return $wshell.Popup($message, $timeout, $header, $INT)
}