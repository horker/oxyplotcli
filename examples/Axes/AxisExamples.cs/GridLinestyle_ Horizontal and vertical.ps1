$plotModel = New-OxyPlotModel -Title "Horizontal and vertical gridlines"

$axis1 = New-OxyLinearAxis `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot

$axis2 = New-OxyLinearAxis `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot `
  -Position Bottom

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$plotModel
