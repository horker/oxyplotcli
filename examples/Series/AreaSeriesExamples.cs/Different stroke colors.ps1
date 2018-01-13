$data = Import-Csv $PSScriptRoot\data.csv

$data | New-OxyAreaSeries -XName X -YName Y -X2Name X2 -Y2Name Y2 -Color Red -Color2 Blue | New-OxyPlotModel -Title "AreaSeries with different stroke colors"
