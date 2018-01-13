$data = Import-Csv $PSScriptRoot\data.csv

$data | New-OxyAreaSeries -XName X -YName Y -X2Name X2 -Y2Name Y2 | New-OxyPlotModel -Title "AreaSeries with default style"
