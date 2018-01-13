$model = New-OxyPlotModel `
  -Title "Semi-circle polar plot" `
  -PlotType Polar `
  -PlotAreaBorderThickness 0 `
  -PlotMargins (60, 20, 4, 40)

$axis1 = New-OxyAngleAxis `
  -Minimum 0 `
  -Maximum 180 `
  -MajorStep 45 `
  -MinorStep 9 `
  -StartAngle 0 `
  -EndAngle 180 `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Solid

$axis2 = New-OxyMagnitudeAxis `
   -Minimum 0 `
   -Maximum 1 `
   -MajorGridlineStyle Solid `
   -MinorGridlineStyle Solid

$model.Axes.Add($axis1)
$model.Axes.Add($axis2)

$series = New-OxyFunctionSeries -Fx { [Math]::Sin($t / 180 * [Math]::PI) } -Fy { $t } -T0 0 -T1 180 -Dt 0.01

$model.Series.Add($series)

$model
