$model = New-OxyPlotModel `
  -Title "Test #3" `
  -LegendPlacement Outside `
  -LegendPosition BottomCenter `
  -LegendOrientation Horizontal `
  -LegendBorderThickness 0 `
  -RenderingDecorator { param($rc) New-Object OxyPlot.XkcdRenderingDecorator($rc) }

$s1 = New-OxyColumnSeries `
  -Title "Series 1" `
  -IsStacked $false `
  -StrokeColor Black `
  -StrokeThickness 1 `
  -Value 25, 137, 18, 40 `
  -CategoryIndex 0, 1, 2, 3

$s2 =New-OxyColumnSeries `
  -Title "Series 2"  `
  -IsStacked $false  `
  -StrokeColor Black  `
  -StrokeThickness 1  `
  -Value 12, 14, 120, 20 `
  -CategoryIndex 0, 1, 2, 3

$categoryAxis = New-OxyCategoryAxis `
  -Position Bottom

$categoryAxis.Labels.Add("Category A")
$categoryAxis.Labels.Add("Category B")
$categoryAxis.Labels.Add("Category C")
$categoryAxis.Labels.Add("Category D")

$valueAxis = New-OxyLinearAxis -Position Left -MinimumPadding 0 -MaximumPadding 0.06 -AbsoluteMinimum 0

$model.Series.Add($s1)
$model.Series.Add($s2)
$model.Axes.Add($categoryAxis)
$model.Axes.Add($valueAxis)

$model
