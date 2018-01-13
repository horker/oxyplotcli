$points = New-Object OxyPlot.DataPoint[] 3
$points[0] = New-Object OxyPlot.DataPoint 0, 50
$points[1] = New-Object OxyPlot.DataPoint 10, 140
$points[2] = New-Object OxyPlot.DataPoint 20, 60

$s = New-OxyAreaSeries -ItemsSource $points -DataFieldX X -DataFieldY Y -ConstantY2 -20
$s | New-OxyPlotModel `
  -Title "AreaSeries with constant baseline" `
  -Subtitle "ItemsSource and DataField2 not set, ConstantY2 = -20"
