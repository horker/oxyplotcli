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

function ConvertTo-Bool {
  param(
    [object]$Value
  )

  if ($value -is [string]) {
    if ($value -eq "true" -or $value -eq "t" -or $value -eq "1") {
      return $true
    }
    if ($value -eq "false" -or $value -eq "f" -or $value -eq "0") {
      return $false
    }
  }
  [bool]$value
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

function Add-OxyLineSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.DataPointSeries]$series,
    [object]$X,
    [object]$Y
  )

  $p = New-Object OxyPlot.DataPoint (Convert-PlotValue $X), (Convert-PlotValue $Y)
  $series.Points.Add($p)
}

############################################################
# ScatterSeries

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

  if ($Size -eq 0) {
    $Size = 5
  }
  $p = New-Object OxyPlot.Series.ScatterPoint (Convert-PlotValue $X), (Convert-PlotValue $Y), $Size, $Value, $Tag
  $series.Points.Add($p)
}

############################################################
# ScatterErrorSeries

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

  if ($Size -eq 0) {
    $Size = 5
  }
  $p = New-Object OxyPlot.Series.ScatterErrorPoint (Convert-PlotValue $X), (Convert-PlotValue $Y), (Convert-PlotValue $ErrorX), (Convert-PlotValue $ErrorY), $Size, $Value, $Tag
  $series.Points.Add($p)
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
# CandleStickSeries

function Add-OxyCandleStickSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.XYAxisSeries]$series,
    [object]$X,
    [double]$High,
    [double]$Low,
    [double]$Open,
    [double]$Close
  )

  $p = New-Object OxyPlot.Series.HighLowItem (Convert-PlotValue $X), $High, $Low, $Open, $Close
  $series.Items.Add($p)
}

############################################################
# PieSeries

function Add-OxyPieSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.PieSeries]$series,
    [string]$Label,
    [double]$Value,
    [string]$Fill,
    [object]$IsExploded
  )

  $slice = New-Object OxyPlot.Series.PieSlice $Label, $Value
  if ($null -ne $Fill -and $Fill.Length -gt 0) {
    $slice.Fill = New-OxyColor $Fill
  }
  if ($null -ne $IsExploded) {
    $slice.IsExploded = ConvertTo-Bool $IsExploded
  }

  $series.Slices.Add($slice)
}

############################################################
# BarSeries

function Add-OxyBarSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.BarSeries]$Series,
    [object]$Value,
    [int]$CategoryIndex = -1
  )

  $p = New-Object OxyPlot.Series.BarItem (Convert-PlotValue $Value), $CategoryIndex
  $series.Items.Add($p)
}

############################################################
# ColumnSeries

function Add-OxyColumnSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.ColumnSeries]$Series,
    [object]$Value,
    [int]$CategoryIndex = -1
  )

  $p = New-Object OxyPlot.Series.ColumnItem (Convert-PlotValue $Value), $CategoryIndex
  $series.Items.Add($p)
}

############################################################
# ErrorColumnSeries

function Add-OxyErrorColumnSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.ErrorColumnSeries]$Series,
    [object]$Value,
    [object]$Error,
    [int]$CategoryIndex = 1
  )

  $p = New-Object OxyPlot.Series.ErrorColumnItem (Convert-PlotValue $Value), (Convert-PlotValue $Error), $CategoryIndex
  $series.Items.Add($p)
}

############################################################
# IntervalBarSeries

function Add-OxyIntervalBarSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.IntervalBarSeries]$Series,
    [object]$Start,
    [object]$End,
    [string]$Title
  )

  $p = New-Object OxyPlot.Series.IntervalBarItem (Convert-PlotValue $Start), (Convert-PlotValue $End), $Title
  $series.Items.Add($p)
}

############################################################
# RectangleBarSeries

function Add-OxyRectangleBarSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.RectangleBarSeries]$Series,
    [object]$X0,
    [object]$Y0,
    [object]$X1,
    [object]$Y1
  )

  $p = New-Object OxyPlot.Series.RectangleBarItem (Convert-PlotValue $X0), (Convert-PlotValue $Y0), (Convert-PlotValue $X1), (Convert-PlotValue $Y1)
  $series.Items.Add($p)
}

############################################################
# TornadoBarSeries

function Add-OxyTornadoBarSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.TornadoBarSeries]$Series,
    [object]$Minimum,
    [object]$Maximum,
    [object]$BaseValue,
    [string]$MinimumColor,
    [string]$MaximumColor
  )

  $p = New-Object OxyPlot.Series.TornadoBarItem
  $p.Minimum = (Convert-PlotValue $Minimum)
  $p.Maximum = (Convert-PlotValue $Maximum)
  $p.BaseValue = (Convert-PlotValue $BaseValue)
  $p.MinimumColor = New-OxyColor $MinimumColor
  $p.MaximumColor = New-OxyColor $MaximumColor
  $series.Items.Add($p)
}

############################################################
# CandleStickAndVolumeSeries

function Add-OxyCandleStickAndVolumeSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.XYAxisSeries]$series,
    [object]$X,
    [double]$Open,
    [double]$High,
    [double]$Low,
    [double]$Close,
    [double]$BuyVolume,
    [double]$SellVolume
  )

  $p = New-Object OxyPlot.Series.OhlcvItem (Convert-PlotValue $X), $Open, $High, $Low, $Close, $BuyVolume, $SellVolume
  $series.Items.Add($p)
}

############################################################
# BoxPlotSeries

function Add-OxyBoxPlotSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.BoxPlotSeries]$series,
    [object]$X,
    [double]$LowerWhisker,
    [double]$BoxBottom,
    [double]$Median,
    [double]$BoxTop,
    [double]$UpperWhistker
  )

  $p = New-Object OxyPlot.Series.BoxPlotItem (Convert-PlotValue $X), $LowerWhisker, $BoxBottom, $Median, $BoxTop, $UpperWhistker
  $series.Items.Add($p)
}

