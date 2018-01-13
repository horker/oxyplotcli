$data3 = Import-Csv $PSScriptRoot\data3.csv
$data4 = Import-Csv $PSScriptRoot\data4.csv


$areaSeries1 = $data3 | New-OxyAreaSeries `
  -XName X -YName Y -X2Name X2 -Y2Name Y2 `
  -Fill LightBlue `
  -DataFieldX2 Time `
  -DataFieldY2 Minimum `
  -Color Red `
  -StrokeThickness 0 `
  -MarkerFill Transparent `
  -DataFieldX Time `
  -DataFieldY Maximum


$lineSeries1 = $data4 | New-OxyLineSeries `
  -XName X -YName Y `
  -Color Blue `
  -MarkerFill Transparent `
  -DataFieldX Time `
  -DataFieldY Value

New-OxyPlotModel `
  -Series $areaSeries1, $lineSeries1 `
  -Title "LineSeries and AreaSeries"
