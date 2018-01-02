Set-StrictMode -Version 3

function Convert-PlotValue {
  param(
    [object]$Value
  )
  if ($value -is [DateTime]) {
    $value = [OxyPlot.Axes.DateTimeAxis]::ToDouble($value)
  }
  elseif ($value -is [TimeSpan]) {
    $value = [OxyPlot.Axes.TimeSpanAxis]::ToDouble($value)
  }
  [double]$value
}

function New-OxyDataPoint {
  [cmdletbinding()]
  param(
    [object]$X,
    [object]$Y
  )

  New-Object OxyPlot.DataPoint (Convert-PlotValue $X), (Convert-PlotValue $Y)
}

############################################################
# LineSeries

function New-OxyLineSeriesPoint {
  [cmdletbinding()]
  param(
    [object]$X,
    [object]$Y
  )

  New-OxyDataPoint $X $Y
}

function Add-OxyLineSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.LineSeries]$series,
    [object]$X,
    [object]$Y
  )

  $series.Points.Add((New-OxyLineSeriesPoint $X $Y))
}

############################################################
# TwoColorLineSeries

function New-OxyTwoColorLineSeriesPoint {
  [cmdletbinding()]
  param(
    [object]$X,
    [object]$Y
  )

  New-OxyDataPoint $X $Y
}

function Add-OxyTwoColorLineSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.LineSeries]$series,
    [object]$X,
    [object]$Y
  )

  $series.Points.Add((New-OxyLineSeriesPoint $X $Y))
}

############################################################
# ScatterSeries

function New-OxyScatterSeriesPoint {
  [cmdletbinding()]
  param(
    [object]$X,
    [object]$Y,
    [double]$Size,
    [double]$Value,
    [object]$Tag
  )

  if ($Size -eq 0) {
    $Size = 5
  }
  New-Object OxyPlot.Series.ScatterPoint (Convert-PlotValue $X), (Convert-PlotValue $Y), $Size, $Value, $Tag
}

function Add-OxyScatterSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.ScatterSeries]$series,
    [object]$X,
    [object]$Y,
    [double]$Size,
    [double]$Value,
    [object]$Tag
  )

  $series.Points.Add((New-OxyScatterSeriesPoint $X $Y $Size $Value $Tag))
}

############################################################
# ScatterErrorSeries

function New-OxyScatterErrorSeriesPoint {
  [cmdletbinding()]
  param(
    [object]$X,
    [object]$Y,
    [object]$ErrorX,
    [object]$ErrorY,
    [double]$Size,
    [double]$Value,
    [object]$Tag
  )

  if ($Size -eq 0) {
    $Size = 5
  }
  New-Object OxyPlot.Series.ScatterErrorPoint (Convert-PlotValue $X), (Convert-PlotValue $Y), (Convert-PlotValue $ErrorX), (Convert-PlotValue $ErrorY), $Size, $Value, $Tag
}

function Add-OxyScatterErrorSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.ScatterErrorSeries]$series,
    [object]$X,
    [object]$Y,
    [object]$ErrorX,
    [object]$ErrorY,
    [double]$Size,
    [double]$Value,
    [object]$Tag
  )

  $series.Points.Add((New-OxyScatterErrorSeriesPoint $X $Y $ErrorX $ErrorY $Size $Value $Tag))
}

############################################################
# AreaSeries

function Add-OxyAreaSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.AreaSeries]$series,
    [object]$X,
    [object]$Y,
    [object]$X2,
    [object]$Y2
  )

  $series.Points.Add((New-OxyDataPoint $X $Y))
  if ($null -ne $X2 -and $null -ne $Y2) {
    $series.Points2.Add((New-OxyDataPoint $X2 $Y2))
  }
}

############################################################
# TwoColorAreaSeries

function Add-OxyTwoColorAreaSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.AreaSeries]$series,
    [object]$X,
    [object]$Y,
    [object]$X2,
    [object]$Y2
  )

  $series.Points.Add((New-OxyDataPoint $X $Y))
  if ($null -ne $X2 -and $null -ne $Y2) {
    $series.Points2.Add((New-OxyDataPoint $X2 $Y2))
  }
}

############################################################
# CandleStickSeries

function New-OxyCandleStickSeriesPoint {
  [cmdletbinding()]
  param(
    [object]$X,
    [double]$High,
    [double]$Low,
    [double]$Open,
    [double]$Close
  )

  New-Object OxyPlot.Series.HighLowItem (Convert-PlotValue $X), $High, $Low, $Open, $Close
}

function Add-OxyCandleStickSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.CandleStickSeries]$series,
    [object]$X,
    [double]$High,
    [double]$Low,
    [double]$Open,
    [double]$Close
  )

  $series.Items.Add((New-OxyCandleStickSeriesPoint $X $High $Low $Open $Close))
}

############################################################
# PieSeries

function New-OxyPieSeriesPoint {
  [cmdletbinding()]
  param(
    [string]$Label,
    [double]$Value
  )

  New-Object OxyPlot.Series.PieSlice $Label, $Value
}

function Add-OxyPieSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.PieSeries]$series,
    [string]$Label,
    [double]$Value
  )

  $series.Slices.Add((New-OxyPieSeriesPoint $Label $Value))
}

