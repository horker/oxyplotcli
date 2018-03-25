Set-StrictMode -Version 3

function Add-OxyObjectToPlotModel {
  [cmdletbinding()]
  param(
    [object]$Object,
    [OxyPlot.PlotModel]$PlotModel,
    [string]$Style = "default",
    [switch]$NoRefresh
  )

  if ($Object -is [OxyPlot.Axes.Axis]) {
    $PlotModel.Axes.Add($Object)
    if (!$NoRefresh) {
      $PlotModel.InvalidatePlot($false)
    }
    return
  }

  if ($Object -is [OxyPlot.Annotations.Annotation]) {
    $PlotModel.Annotations.Add($Object)
    if (!$NoRefresh) {
      $PlotModel.InvalidatePlot($false)
    }
    return
  }

  if ($Object -isnot [OxyPlot.Series.Series]) {
    Write-Error "Object is not a series, axis, nor annotation"
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
        if ($null -ne $Object._Info.CategoryTitle) {
          $ax.Title = $Object._Info.CategoryTitle
        }
        else {
          $ax.Title = $Object._Info.XAxisTitle
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
      $ax.Title = $Object._Info.YAxisTitle
    }

    $ax.Position = "Bottom"
    $ax.PositionTier = $axTier

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
        if ($null -ne $Object._Info.CategoryTitle) {
          $ay.Title = $Object._Info.CategoryTitle
        }
        else {
          $ay.Title = $Object._Info.YAxisTitle
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
      $ay.Title = $Object._Info.YAxisTitle
    }

    $ay.Position = "Left"
    $ay.PositionTier = $ayTier

    $axisKey = $Object.YAxisKey
    if ($axisKey -eq "" -or $axisKey -eq $null) {
      $axisKey = [Guid]::NewGuid().ToString()
      $Object.YAxisKey = $axisKey
    }
    $ay.Key = $axisKey

    Apply-OxyStyle $ay $Style $MyInvocation
    $PlotModel.Axes.Add($ay)
  }

  if ($Object -is [OxyPlot.Series.HeatMapSeries] -and $null -eq $Object.ColorAxis -and $null -eq $Object.ColorAxisKey) {
    $colorAxis = New-Object OxyPlot.Axes.LinearColorAxis
    $colorAxis.Position = "Right"

    $axisKey = [Guid]::NewGuid().ToString()
    $colorAxis.Key = $axisKey
    $Object.ColorAxisKey = $axisKey

    Apply-OxyStyle $colorAxis $Style $MyInvocation
    $PlotModel.Axes.Add($colorAxis)
  }

  $PlotModel.Series.Add($Object)

  Apply-OxyStyleEvent $PlotModel $Style "BeforeRendering" $MyInvocation

  if (!$NoRefresh) {
    $PlotModel.InvalidatePlot($true)
  }
}
