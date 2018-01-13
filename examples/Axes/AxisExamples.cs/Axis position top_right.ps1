$plotModel = New-OxyPlotModel

$axis1 = New-OxyLinearAxis `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot `
  -Position Right `
  -Title "Right"

$axis2 = New-OxyLinearAxis `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot `
  -Position Top `
  -Title "Top"

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$plotModel
