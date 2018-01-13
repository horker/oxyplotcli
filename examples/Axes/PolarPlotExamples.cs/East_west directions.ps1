$model = New-OxyPlotModel `
  -Title "East/west directions" `
  -PlotType Polar `
  -PlotAreaBorderThickness 0 `
  -PlotMargins (60, 20, 4, 40)

$axis1 = New-OxyAngleAxis `
  -Minimum 0 `
  -Maximum 360 `
  -MajorStep 30 `
  -MinorStep 30 `
  -StartAngle -90 `
  -EndAngle 270 `
  -LabelFormatter {
    param($angle)
    if ($angle -gt 0 -and $angle -lt 180) {
      return [string]$angle + "E"
    }
    if ($angle -gt 180) {
      return [string](360 - $angle) + "W";
    }
    [string]$angle
  } `
  -MajorGridlineStyle Dot `
  -MinorGridlineStyle None

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
