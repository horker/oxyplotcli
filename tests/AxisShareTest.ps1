powershell -c @'
Import-Module $HOME\work\oxyplot\cs\WpfWindowCmdlets\bin\Debug\WpfWindowCmdlets.dll
Import-Module $HOME\work\oxyplot\cs\OxyPlotCliHelpers\bin\Debug\OxyPlotCliHelpers.dll
Import-Module $HOME\work\oxyplot\OxyPlotCli

$series = oxyscatter -x 1, 2, 3 -y 4, 5, 6
$a1 = New-OxyLinearAxis -Position bottom -TickStyle inside
$a2 = New-OxyLinearAxis -Position left -tickStyle inside
$model1 = New-OxyPlotModel -Series $series -Axis $a1, $a2

$series2 = oxyline -x 3,4,5 -y 9, 10, 5
$a21 = New-OxyLinearAxis -Position bottom
$a22 = New-OxyLinearAxis -Position left
$model2 = New-OxyPlotModel -Series $series2 -Axis $a21, $a22

Add-OxyAxisShare $a1, $a21 -Multiplier 1, 3 -Offset 1, 0

$w = New-WpfWindow
$views = Add-OxyPlotViewInGrid $w -columns 2 -PlotModel $model1, $model2

Read-Host "Push enter key"
'@
