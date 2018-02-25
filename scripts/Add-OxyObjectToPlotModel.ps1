function Get-RequiredAxisType {
  param(
    [OxyPlot.Series.Series]$Series,
    [string]$Position
  )

  if ($Position -eq "x") {
    if ($Series -is [OxyPlot.Series.ColumnSeries] -or
        $Series -is [OxyPlot.Series.ErrorColumnSeries]) {
      return "category"
    }
  }
  else {
    if ($Series -is [OxyPlot.Series.BarSeries] -or
        $Series -is [OxyPlot.Series.IntervalBarSeries] -or
        $Series -is [OxyPlot.Series.LinearBarSeries] -or
        $Series -is [OxyPlot.Series.TornadoBarSeries]) {
      return "category"
    }
  }
  "linear"
}

function Add-OxyObjectToPlotModel {
  [cmdletbinding()]
  param(
    [object]$Object,
    [OxyPlot.PlotModel]$PlotModel,
    [string]$Style = "default"
  )

  if ($Object -is [OxyPlot.Axes.Axis]) {
    $PlotModel.Axes.Add($Object)
    $PlotModel.InvalidatePlot($false)
    return
  }

  if ($Object -is [OxyPlot.Annotations.Annotation]) {
    $PlotModel.Annotations.Add($Object)
    $PlotModel.InvalidatePlot($false)
    return
  }

  if ($Object -isnot [OxyPlot.Series.Series]) {
    Write-Error "Object is not a series, axis, nor annotation"
    return
  }

  if (!(Test-AxesRequired $Object)) {
    return
  }

  # Setting axes

  $axRequired = $true
  $ayRequired = $true
  $axTier = 0
  $ayTier = 0

  $xType = Get-RequiredAxisType $Object x
  $yType = Get-RequiredAxisType $Object y

  foreach ($a in $PlotModel.Axes) {
    if ($a.Position -eq "Bottom") {
      ++$axTier
      if (($xType -eq "linear" -and $a -isnot [OxyPlot.Axes.CategoryAxis]) -or
          ($xType -eq "category" -and $a -is [OxyPlot.Axes.CategoryAxis])) {
        $axRequired = $false
      }
    }
    if ($a.Position -eq "Left") {
      ++$ayTier
      if (($yType -eq "linear" -and $a -isnot [OxyPlot.Axes.CategoryAxis]) -or
          ($yType -eq "category" -and $a -is [OxyPlot.Axes.CategoryAxis])) {
        $ayRequired = $false
      }
    }
  }

  if ($axRequired) {
    if ($xType -eq "category") {
      $ax = New-Object OxyPlot.Axes.CategoryAxis
      if ($Object.PSObject.Properties.Name -Contains "_Info") {
        foreach ($n in $Object._Info.CategoryNames) {
          $ax.Labels.Add($n)
        }
      }
    }
    else {
      if ($Object.PSObject.Properties.Name -Contains "_Info") {
        $ax = Get-AxisObject $Object._Info.XDataType
      }
      else {
        $ax = New-Object OxyPlot.Axes.LinearAxes
      }
    }

    $ax.Position = "Bottom"
    $ax.PositionTier = $axTier

    if ($Object.PSObject.Properties.Name -Contains "_Info") {
      $ax.Title = $Object._Info.XAxisTitle
    }

    $axisKey = $Object.XAxisKey
    if ($axisKey -eq "" -or $axisKey -eq $null) {
      $axisKey = [Guid]::NewGuid().ToString()
      $Object.XAxisKey = $axisKey
    }
    $ax.Key = $axisKey

    Apply-OxyStyle $ax $Style $MyInvocation

    $PlotModel.Axes.Add($ax)
  }

  if ($ayRequired) {
    if ($yType -eq "category") {
      $ay = New-Object OxyPlot.Axes.CategoryAxis
      if ($Object.PSObject.Properties.Name -Contains "_Info") {
        foreach ($n in $Object._Info.CategoryNames) {
          $ay.Labels.Add($n)
        }
      }
    }
    else {
      if ($Object.PSObject.Properties.Name -Contains "_Info") {
        $ay = Get-AxisObject $Object._Info.XDataType
      }
      else {
        $ay = New-Object OxyPlot.Axes.LinearAxes
      }
    }

    $ay.Position = "Left"
    $ay.PositionTier = $ayTier
    if ($Object.PSObject.Properties.Name -Contains "_Info") {
      $ay.Title = $Object._Info.YAxisTitle
    }

    $axisKey = $Object.YAxisKey
    if ($axisKey -eq "" -or $axisKey -eq $null) {
      $axisKey = [Guid]::NewGuid().ToString()
      $Object.YAxisKey = $axisKey
    }
    $ay.Key = $axisKey

    Apply-OxyStyle $ay $Style $MyInvocation
    $PlotModel.Axes.Add($ay)
  }

  $PlotModel.Series.Add($Object)
  $PlotModel.InvalidatePlot($true)
}
