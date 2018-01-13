$plotModel = New-OxyPlotModel -Title "PositionAtZeroCrossing = true"

$axis1 = New-OxyLinearAxis `
  -Maximum 50 `
  -Minimum -30 `
  -PositionAtZeroCrossing $true `
  -AxislineStyle Solid `
  -TickStyle Crossing

$axis2 = New-OxyLinearAxis `
  -Maximum 70 `
  -Minimum -50 `
  -PositionAtZeroCrossing $true `
  -AxislineStyle Solid `
  -TickStyle Crossing `
  -Position Bottom

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$plotModel

