$plotModel = New-OxyPlotModel `
  -Title "Polar plot (reversed angle axis)" `
  -Subtitle "Archimedean spiral with equation r(É∆) = É∆ for 0 < É∆ < 6ÉŒ" `
  -PlotType Polar `
  -PlotAreaBorderThickness 0 `
  -PlotMargins 60, 20, 4, 40

$axis1 = New-OxyAngleAxis `
   -MajorStep ([Math]::PI / 4) `
   -MinorStep ([Math]::PI / 16) `
   -MajorGridlineStyle Solid `
   -MinorGridlineStyle Solid `
   -FormatAsFractions $true `
   -FractionUnit ([Math]::PI) `
   -FractionUnitSymbol "ÉŒ" `
   -Minimum 0 `
   -Maximum (2 * [Math]::PI) `
   -StartAngle 360 `
   -EndAngle 0

$axis2 = New-OxyMagnitudeAxis `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Solid

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$series = New-OxyFunctionSeries -Fx { $t } -Fy { $t } -T0 0 -T1 ([Math]::PI * 6) -Dt 0.01

$plotModel.Series.Add($series)

$plotModel
