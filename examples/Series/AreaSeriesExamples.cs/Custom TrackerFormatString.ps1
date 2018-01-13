$data = Import-Csv $PSScriptRoot\data.csv

$data | New-OxyAreaSeries `
  -XName X -YName Y -X2Name X2 -Y2Name Y2 `
  -Title "X={2:0.0} Y={4:0.0}" `
  -TrackerFormatString "X={2:0.0} Y={4:0.0}" |

New-OxyPlotModel -Title "AreaSeries with custom TrackerFormatString"
