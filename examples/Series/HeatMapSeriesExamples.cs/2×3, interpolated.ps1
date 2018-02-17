$data = @(
  @( 0, .1),
  @(.2, .3),
  @(.4, .2)
)

$s = New-OxyHeatMapSeries `
  -CoordinateDefinition Center `
  -X0 .5 `
  -X1 1.5 `
  -Y0 .5 `
  -Y1 2.5 `
  -Data $data `
  -Interpolate $true `
  -LabelFontSize .2

$linearColorAxis = New-OxyLinearColorAxis `
  -Position Right `
  -Palette Jet, 500 `
  -HighColor Gray `
  -LowColor Black

$s | New-OxyPlotModel `
  -Title "HeatMapSeries" `
  -Subtitle "2x3, interpolated" `
  -Axes $linearColorAxis
