$s = New-OxyAreaSeries -X 0, 10, 20 -Y 50, 140, 60 -ConstantY ([double]::NaN)
$s | New-OxyPlotModel `
  -Title "AreaSeries with constant baseline" `
  -Subtitle "Empty Points2, ConstantY2 = 0 (default)"
