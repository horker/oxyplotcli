Set-StrictMode -Version 3

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

  if ($Series.PSObject.Properties -Contains "_Info") {
    return @()
  }

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
    [Parameter(ParameterSetName="PlotModel", ValueFromPipeline=$true)]
    [OxyPlot.PlotModel]$PlotModel,
    [Parameter(ParameterSetName="Series", ValueFromPipeline=$true)]
    [OxyPlot.Series.Series]$Series,
    [string]$StyleName,
    [OxyPlot.Axes.Axis[]]$Axes,
    [switch]$Reuse
  )

begin {
  $model = $null
}

process {
  if ($model -eq $null) {
    if ($PSCmdlet.ParameterSetName -eq "Series") {
      $model = New-Object OxyPlot.PlotModel
    }
    else {
      $model = $PlotModel
    }
  }
  if ($Series -ne $null) {
    $model.Series.Add($Series)
  }
}

end {
  foreach ($a in $Axes) {
    $model.Axes.Add($a)
  }

  if ($model.Axes.Count -eq 0) {
    $s = $model.Series[0]
    $Axes = New-DefaultAxes $s
    foreach ($a in $Axes) {
      $model.Axes.Add($a)
    }
  }

  if ($Reuse) {
    $w = Get-OxyWindow
  }
  else {
    $w = New-OxyWindow -Title $MyInvocation.Line
  }

  Invoke-WpfWindowAction $w {
    $w.Activate()

    $view = New-Object OxyPlot.Wpf.PlotView
    $view.Model = $model

    $g = New-Object Windows.Controls.Grid
    $g.Children.Add($view)
    $w.Content = $g
  }
}
}
