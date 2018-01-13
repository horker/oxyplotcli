$plotModel = New-OxyPlotModel -Title "Color major and minor ticks differently"

$axis1 = New-OxyLinearAxis `
  -Position Left `
  -MajorGridlineThickness 3 `
  -MinorGridlineThickness 3 `
  -TicklineColor Blue `
  -MinorTicklineColor Gray

$axis2 = New-OxyLinearAxis `
  -Position Bottom `
  -MajorGridlineThickness 3 `
  -MinorGridlineThickness 3 `
  -TicklineColor Blue `
  -MinorTicklineColor Gray

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$plotModel
