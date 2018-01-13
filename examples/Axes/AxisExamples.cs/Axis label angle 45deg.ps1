$plotModel = New-OxyPlotModel -PlotMargins 60, 40, 60, 30

$axis1 = New-OxyLinearAxis `
  -Angle 45 `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot `
  -Title "Left"

$axis2 = New-OxyLinearAxis `
  -Angle 45 `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Dot `
  -Position Bottom `
  -Title "Bottom"

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$plotModel
