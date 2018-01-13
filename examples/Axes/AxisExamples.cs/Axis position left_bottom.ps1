$plotModel = New-OxyPlotModel

$axis1 = New-OxyLinearAxis `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot `
  -Title "Left"

$axis2 = New-OxyLinearAxis `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot `
  -Position Bottom `
  -Title "Bottom"

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$plotModel
