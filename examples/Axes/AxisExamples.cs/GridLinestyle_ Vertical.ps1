$plotModel = New-OxyPlotModel -Title "Vertical gridlines"

$axis1 = New-OxyLinearAxis
$axis2 = New-OxyLinearAxis `
  -Position Bottom `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$plotModel
