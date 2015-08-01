Function get-info($computerName){
    $return = "" | Select-Object Name,OS,Arc
    $WMIOS = Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName
    
    $return.Name = $WMIOS.PSComputerName
    $return.OS = $WMIOS.Name
    $return.Arc = $WMIOS.OSArchitecture   
    

    return $Return
}

Function Load-Dialog($Window){

    try{
        Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms
    }
    catch{
        Throw "Failed to load the Presentation Assembly"
    }

    $Global:xamGUI = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $window))

    $window.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $xamGUI.FindName($_.Name) -Scope Global}
}

$xml = [xml] @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"        
        Title="MainWindow" Height="120" Width="525">
    <Grid>
        <TextBox Name="txtInputFile" HorizontalAlignment="Left" Height="41" Margin="10,10,0,0" TextWrapping="Wrap" Text="Input File" VerticalAlignment="Top" Width="328" FontSize="16"/>
        <Button Name="btnSelectFile" Content="Select File" HorizontalAlignment="Left" Margin="354,10,0,0" VerticalAlignment="Top" Width="112" Height="41"/>
        <Button Name="btnGenerate" Content="Generate Report" HorizontalAlignment="Left" Margin="10,56,0,0" VerticalAlignment="Top" Width="500"/>

    </Grid>
</Window>


"@



Load-Dialog $xml

$btnSelectFile.add_click({
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialogResult = $dialog.ShowDialog()
    if($dialogResult -eq "OK"){
        $txtInputFile.Text = $dialog.filename
    }
})

$btnGenerate.add_click({
    $Computers = get-content $txtInputFile.Text
    $results = @()
    Foreach($computer in $computers){
        $results += get-info $Computer
    }
    $results | export-csv "results_$(get-date -f MM-dd-yyyy).csv"
})

$xamGui.ShowDialog() | Out-Null