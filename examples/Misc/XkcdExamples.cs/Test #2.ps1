$model = New-OxyPlotModel `
  -Title "Test #2" `
  -RenderingDecorator { param($rc) New-Object OxyPlot.XkcdRenderingDecorator($rc) } `
  -Axes (New-OxyLinearAxis -Position Left -Minimum 0 -Maximum 8 -Title "INTENSITY"),
        (New-OxyLinearAxis -Position Bottom -Title "TIME")

$s1 = New-OxyLineSeries -Color Cyan -StrokeThickness 4
$s2 = New-OxyLineSeries -Color White -StrokeThickness 14
$s3 = New-OxyLineSeries -Color Red -StrokeThickness 4

$n = 257
$x0 = 1
$x1 = 9

for ($i = 0; $i -lt $n; $i++) {
  $x = $x0 + (($x1 - $x0) * $i / ($n - 1))
  $y1 = 1.5 + (10.0 * ([Math]::Sin($x) * [Math]::Sin($x) / [Math]::Sqrt($x)) * [Math]::Exp(-0.5 * ($x - 5.0) * ($x - 5.0)))
  $y2 = 3.0 + (10.0 * ([Math]::Sin($x) * [Math]::Sin($x) / [Math]::Sqrt($x)) * [Math]::Exp(-0.5 * ($x - 7.0) * ($x - 7.0)))
  $s1.Points.Add((New-OxyDataPoint $x $y1))
  $s2.Points.Add((New-OxyDataPoint $x $y2))
  $s3.Points.Add((New-OxyDataPoint $x $y2))
}

$model.Series.Add($s1)
$model.Series.Add($s2)
$model.Series.Add($s3)

$model
