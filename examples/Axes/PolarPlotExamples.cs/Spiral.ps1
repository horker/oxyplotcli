$plotModel = New-OxyPlotModel `
  -Title "Ploar plot" `
  -Subtitle "Archimedean spiral with equation r(θ) = θ for 0 < θ < 6π" `
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
   -FractionUnitSymbol "π" `
   -Minimum 0 `
   -Maximum (2 * [Math]::PI)

$axis2 = New-OxyMagnitudeAxis `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Solid

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$series = New-OxyFunctionSeries -Fx { $t } -Fy { $t } -T0 0 -T1 ([Math]::PI * 6) -Dt 0.01

$plotModel.Series.Add($series)

$plotModel
