#powershell -c @'
Import-Module $HOME\work\oxyplot\cs\WpfWindowCmdlets\bin\Debug\WpfWindowCmdlets.dll
Import-Module $HOME\work\oxyplot\cs\OxyPlotCliHelpers\bin\Debug\OxyPlotCliHelpers.dll
Import-Module $HOME\work\oxyplot\OxyPlotCli

$series = oxyscatter -x 1, 2, 3 -y 4, 5, 6
$a11 = New-OxyLinearAxis -Position bottom -TickStyle inside -Minimum -5 -Maximum 5
$a12 = New-OxyLinearAxis -Position left -TickStyle inside
$model1 = $series | New-OxyPlotModel -Axis $a11, $a12

$series2 = oxyline -x 3,4,5 -y 9, 10, 5
$a21 = New-OxyLinearAxis -Position bottom
$a22 = New-OxyLinearAxis -Position left
$model2 = $series2 | New-OxyPlotModel -Axis $a21, $a22

$series3 = oxyline -x 3,4,5 -y 9, 10, 5 -Smooth $true
$a31 = New-OxyLinearAxis -Position bottom
$a32 = New-OxyLinearAxis -Position left
$model3 = $series3 | New-OxyPlotModel -Axis $a31, $a32

Add-OxyAxisShare $a11, $a21, $a31 -Multiplier 1, 1, 3 -Offset 0, 0, 1

$w = New-WpfWindow
$views = Add-OxyPlotViewInGrid $w -columns 3 -PlotModel $model1, $model2, $model3

Read-Host "Push enter key"
#'@
