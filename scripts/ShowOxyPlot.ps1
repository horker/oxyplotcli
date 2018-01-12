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
    [string]$WindowAction = $OxyPlotCliWindowPreference,
    [OxyPlot.Axes.Axis[]]$Axes
  )

begin {
  if ($PSCmdlet.ParameterSetName -eq "PlotModel" -and $WindowAction -eq "Add") {
    Write-Error "When -PlotModel is given, -WindowAction should not be 'Add'"
    return
  }

  if ($PSCmdlet.ParameterSetName -eq "Series") {
    if ($WindowAction -ne "Add") {
      $PlotModel = New-Object OxyPlot.PlotModel
    }
    else {
      $PlotModel = (Get-OxyWindow).PlotModel
    }
  }
}

process {
  if ($null -ne $Series) {
    $PlotModel.Series.Add($Series)
  }
}

end {
  foreach ($a in $Axes) {
    $PlotModel.Axes.Add($a)
  }

  if ($PlotModel.Axes.Count -eq 0) {
    $s = $PlotModel.Series[0]
    $Axes = New-DefaultAxes $s
    foreach ($a in $Axes) {
      $PlotModel.Axes.Add($a)
    }
  }

  switch ($WindowAction) {
    "New" {
      $w = New-OxyWindow $PlotModel -Title $MyInvocation.Line
    }
    "Reuse" {
      $w = Get-OxyWindow
      $window = $w.Window
      $view = $w.PlotModel.PlotView
      Invoke-WpfWindowAction $window {
        $view.Model = $PlotModel
      }
    }
    "Add" {
      Update-OxyPlotModel $PlotModel
    }
  }
}
}
