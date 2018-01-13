$model = New-OxyPlotModel `
  -Title "Offset angle axis" `
  -PlotType Polar `
  -PlotAreaBorderThickness 0 `
  -PlotMargins (60, 20, 4, 40)


$angleAxis = New-OxyAngleAxis `
  -Minimum 0 `
  -Maximum ([Math]::PI * 2) `
  -MajorStep ([Math]::PI / 4) `
  -MinorStep ([Math]::PI / 16) `
  -StringFormat "0.00" `
  -StartAngle 30 `
  -EndAngle 390

$model.Axes.Add($angleAxis)
$model.Axes.Add((New-OxyMagnitudeAxis))

$series = New-OxyFunctionSeries -Fx { $t } -Fy { $t } -T0 0 -T1 ([Math]::PI * 6) -Dt 0.01

$model.Series.Add($series)

$model
