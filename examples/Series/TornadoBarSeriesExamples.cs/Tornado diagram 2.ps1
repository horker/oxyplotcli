$s = New-OxyTornadoBarSeries `
  -Title "TornadoBarSeries" `
  -BaseValue 7 `
  -Minimum 6, 4, 5, 4 `
  -Maximum 8, 8, 11, 12

$categoryAxis = New-OxyCategoryAxis -Position Left
$categoryAxis.Labels.Add("F/X rate")
$categoryAxis.Labels.Add("Inflation")
$categoryAxis.Labels.Add("Price")
$categoryAxis.Labels.Add("Conversion")

$valueAxis = New-OxyLinearAxis `
  -Position Bottom `
  -ExtraGridlines 7.0 `
  -MinimumPadding 0.1 `
  -MaximumPadding 0.1

$s | New-OxyPlotModel `
  -Title "Tornado diagram 2" `
  -LegendPlacement Outside `
  -Axes $categoryAxis, $valueAxis
