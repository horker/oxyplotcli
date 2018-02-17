Set-StrictMode -version 3

Import-Module $PSScriptRoot\WpfWindowCmdlets.dll
Import-Module $PSScriptRoot\OxyPlotCliHelpers.dll

Get-ChildItem $PSScriptRoot\*.ps1 | foreach { . $_.FullName }

Get-Item function:\New-Oxy*Series  | where { $_ -match "^New-Oxy(\w+)Series(\w*)$" } | foreach {
  $fullName = $matches[0]
  $series = $matches[1]
  $lseries = $series.ToLower()
  $suffix = $matches[2]

  Set-Alias "oxy$lseries$suffix" $fullName
}

# Additional aliases

Set-Alias oxybox New-OxyBoxPlotSeries
Set-Alias oxycandle New-OxyCandleStickSeries
Set-Alias oxycandlev New-OxyCandleStickAndVolumeSeries
Set-Alias oxycol New-OxyColumnSeries
Set-Alias oxyecol New-OxyErrorColumnSeries
Set-Alias oxyfunc New-OxyFunctionSeries
Set-Alias oxyibar New-OxyIntervalBarSeries
Set-Alias oxylbar New-OxyLinearBarSeries
Set-Alias oxyrbar New-OxyRectangleBarSeries
Set-Alias oxyscat New-OxyScatterSeries
Set-Alias oxyscate New-OxyScatterErrorSeries
Set-Alias oxystair New-OxyStairStepSeries
Set-Alias oxy3cline New-OxyThreeColorLineSeries
Set-Alias oxytornado New-OxyTornadoBarSeries
Set-Alias oxy2carea New-OxyTwoColorAreaSeries
Set-Alias oxy2cline New-OxyTwoColorLineSeries
