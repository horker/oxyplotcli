$data = Import-Csv $PSScriptRoot\data2.csv

$data | New-OxyAreaSeries -XName X -YName Y -X2Name X2 -Y2Name Y2 | New-OxyPlotModel -Title "AreaSeries with corssing lines"
