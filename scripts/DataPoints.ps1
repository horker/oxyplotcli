Set-StrictMode -Version 3

############################################################
# DataPoint

function New-OxyDataPoint {
  [cmdletbinding()]
  param(
    [object]$X,
    [object]$Y
  )

  $X = Convert-ParameterValue double $X
  $Y = Convert-ParameterValue double $Y
  New-Object OxyPlot.DataPoint $X, $Y
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

  $X = Convert-ParameterValue double $X
  $Y = Convert-ParameterValue double $Y
  $p = New-Object OxyPlot.DataPoint $X, $Y
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
    [object]$Size,
    [object]$Value,
    [string]$Tag
  )

  $X = Convert-ParameterValue double $X
  $Y = Convert-ParameterValue double $Y
  $Size = Convert-ParameterValue double $Size
  $Value = Convert-ParameterValue double $Value

  $p = New-Object OxyPlot.Series.ScatterPoint $X, $Y, $Size, $Value, $Tag
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
    [object]$Size,
    [object]$Value,
    [object]$Tag
  )

  $X = Convert-ParameterValue double $X
  $Y = Convert-ParameterValue double $Y
  $ErrorX = Convert-ParameterValue double $ErrorX
  $ErrorY = Convert-ParameterValue double $ErrorY
  $Size = Convert-ParameterValue double $Size
  $Value = Convert-ParameterValue double $Value

  $p = New-Object OxyPlot.Series.ScatterErrorPoint $X, $Y, $ErrorX, $ErrorY, $Size, $Value, $Tag
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
    [object]$High,
    [object]$Low,
    [object]$Open,
    [object]$Close
  )

  $X = Convert-ParameterValue double $X
  $High = Convert-ParameterValue double $High
  $Low = Convert-ParameterValue double $Low
  $Open = Convert-ParameterValue double $Open
  $Close = Convert-ParameterValue double $Close

  $p = New-Object OxyPlot.Series.HighLowItem $X, $High, $Low, $Open, $Close
  $series.Items.Add($p)
}

############################################################
# PieSeries

function Add-OxyPieSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.PieSeries]$series,
    [string]$Label,
    [object]$Value,
    [string]$Fill,
    [object]$IsExploded
  )

  $Value = Convert-ParameterValue double $Value
  $IsExploded = Convert-ParameterValue bool $Value

  $slice = New-Object OxyPlot.Series.PieSlice $Label, $Value
  if ($null -ne $Fill -and $Fill.Length -gt 0) {
    $slice.Fill = New-OxyColor $Fill
  }
  $slice.IsExploded = $IsExploded

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

  $Value = Convert-ParameterValue double $Value

  $p = New-Object OxyPlot.Series.BarItem $Value, $CategoryIndex
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

  $Value = Convert-ParameterValue double $Value

  $p = New-Object OxyPlot.Series.ColumnItem $Value, $CategoryIndex
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

  $Value = Convert-ParameterValue double $Value
  $Error = Convert-ParameterValue double $Error

  $p = New-Object OxyPlot.Series.ErrorColumnItem $Value, $Error, $CategoryIndex
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

  $Start = Convert-ParameterValue double $Start
  $End = Convert-ParameterValue double $End

  $p = New-Object OxyPlot.Series.IntervalBarItem $Start, $End, $Title
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

  $X0 = Convert-ParameterValue double $X0
  $Y0 = Convert-ParameterValue double $Y0
  $X1 = Convert-ParameterValue double $X1
  $Y1 = Convert-ParameterValue double $Y1

  $p = New-Object OxyPlot.Series.RectangleBarItem $X0, $Y0, $X1, $Y1
  $Series.Items.Add($p)
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

  $Minimum = Convert-ParameterValue double $Minimum
  $Maximum = Convert-ParameterValue double $Maximum
  $BaseValue = Convert-ParameterValue double $BaseValue
  $MinimumColor = Convert-ParameterValue OxyPlot.OxyColor $MinimumColor
  $MaximumColor = Convert-ParameterValue OxyPlot.OxyColor $MaximumColor

  $p = New-Object OxyPlot.Series.TornadoBarItem
  $p.Minimum = $Minimum
  $p.Maximum = $Maximum
  $p.BaseValue = $BaseValue
  $p.MinimumColor = $MinimumColor
  $p.MaximumColor = $MaximumColor
  $series.Items.Add($p)
}

############################################################
# CandleStickAndVolumeSeries

function Add-OxyCandleStickAndVolumeSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.XYAxisSeries]$series,
    [object]$X,
    [object]$Open,
    [object]$High,
    [object]$Low,
    [object]$Close,
    [object]$BuyVolume,
    [object]$SellVolume
  )

  $X = Convert-ParameterValue double $X
  $Open = Convert-ParameterValue double $Open
  $High = Convert-ParameterValue double $High
  $Low = Convert-ParameterValue double $Low
  $Close = Convert-ParameterValue double $Close
  $BuyVolume = Convert-ParameterValue double $BuyVolume
  $SellVolume = Convert-ParameterValue double $SellVolume

  $p = New-Object OxyPlot.Series.OhlcvItem $X, $Open, $High, $Low, $Close, $BuyVolume, $SellVolume
  $series.Items.Add($p)
}

############################################################
# BoxPlotSeries

function Add-OxyBoxPlotSeriesPoint {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.BoxPlotSeries]$series,
    [object]$X,
    [object]$LowerWhisker,
    [object]$BoxBottom,
    [object]$Median,
    [object]$BoxTop,
    [object]$UpperWhistker,
    [object[]]$Outlier
  )

  $X = Convert-ParameterValue double $X
  $LowerWhisker = Convert-ParameterValue double $LowerWhisker
  $BoxBottom = Convert-ParameterValue double $BoxBottom
  $Median = Convert-ParameterValue double $Median
  $BoxTop = Convert-ParameterValue double $BoxTop
  $UpperWhistker = Convert-ParameterValue double $UpperWhistker

  $p = New-Object OxyPlot.Series.BoxPlotItem $X, $LowerWhisker, $BoxBottom, $Median, $BoxTop, $UpperWhistker

  if ($null -ne $Outlier -and $Outlier.Count -gt 0) {
    $Outlier = $Outlier | foreach {
      Convert-ParameterValue double $_
    }
    $p.Outliers.AddRange([double[]]$Outlier)
  }

  $series.Items.Add($p)
}

############################################################
# BoxPlotSeries (Raw Value)

function Add-OxyBoxPlotSeriesRawPoint {
  [cmdletbinding()]
  param(
    [Horker.OxyPlotCli.Series.BoxPlotSeries]$series,
    [object]$X,
    [object]$Value
  )

  $X = Convert-ParameterValue double $X
  $Value = Convert-ParameterValue double $Value

  $p = New-Object Horker.OxyPlotCli.Series.BoxPlotRawItem $X, $Value

  $series.RawItems.Add($p)
}

############################################################
# HistogramSeries

function Add-OxyHistogramSeriesRawPoint {
  [cmdletbinding()]
  param(
    [Horker.OxyPlotCli.Series.HistogramSeries]$series,
    [object]$Value
  )

  $Value = Convert-ParameterValue double $Value

  $series.RawValues.Add($Value)
}
