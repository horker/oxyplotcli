Set-StrictMode -Version 3

$global:OxyPlotCliWindowPreference = "New"

############################################################

function Get-AxisObject {
  param(
    [string]$AxisType,
    [Reflection.TypeInfo]$DataType
  )

  if ($AxisType -eq "none") {
    return $null
  }

  if ($AxisType -eq "linear") {
    if ($DataType -eq [DateTime]) { $AxisType = "OxyPlot.Axes.DateTimeAxis" }
    elseif ($DataType -is [TimeSpan]) { $AxisType = "OxyPlot.Axes.TimeSpanAxis" }
    else { $AxisType = "OxyPlot.Axes.LinearAxis" }
  }

  New-Object $AxisType
}

function New-DefaultAxes {
  param(
    [OxyPlot.Series.Series]$Series
  )

  $result = @()

  # bottom axis
  $axis = Get-AxisObject $Series._Info.BottomAxisType $Series._Info.XDataType
  if ($axis) {
    $axis.Position = "Bottom"
    if ($Series._Info.XAxisTitle) {
      $axis.Title = $Series._Info.XAxisTitle
    }
    $result = @($axis)
  }

  # left axis
  $axis = Get-AxisObject $Series._Info.LeftAxisType $Series._Info.YDataType
  if ($axis) {
    $axis.Position = "Left"
    if ($Series._Info.YAxisTitle) {
      $axis.Title = $Series._Info.YAxisTitle
    }
    $result = $result + $axis
  }

  # right axis
  $axis = Get-AxisObject $Series._Info.RightAxisType ([double])
  if ($axis) {
    $axis.Position = "Right"
    $result = $result + $axis
  }

  $result
}

############################################################

function Show-OxyPlot {
  [cmdletbinding()]
  param(
    [Parameter(ValueFromPipeline=$true)]
    [OxyPlot.Series.Series]$Series,
    [string]$StyleName,
    [string]$WindowAction = $OxyPlotCliWindowPreference,
    [OxyPlot.Axes.Axis[]]$Axes
  )

begin {
  if ($WindowAction -ne "Add") {
    $model = New-Object OxyPlot.PlotModel
  }
  else {
    $model = (Get-OxyWindow).PlotModel
  }

  foreach ($a in $Axes) {
    $model.Axes.Add($a)
  }
}

process {
  $model.Series.Add($Series)

  if ($model.Axes.Count -eq 0) {
    $Axes = New-DefaultAxes $Series
    foreach ($a in $Axes) {
      $model.Axes.Add($a)
    }
  }
}

end {
  switch ($WindowAction) {
    "New" {
      $w = New-OxyWindow $model -Title $MyInvocation.Line
    }
    "Reuse" {
      $w = Get-OxyWindow
      $window = $w.Window
      $view = $w.PlotModel.PlotView
      Invoke-WpfWindowAction $window {
        $view.Model = $model
      }
    }
    "Add" {
      Update-OxyPlotModel $model
    }
  }
}
}
