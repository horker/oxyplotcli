Set-StrictMode -Version 3

$global:OxyPlotCliWindowPreference = "New"

############################################################

function New-AxisAccordingToDataType {
  param(
    [Reflection.TypeInfo]$Type,
    [string]$Title,
    [OxyPlot.Axes.AxisPosition]$Position
  )

  if ($Type -eq [DateTime]) { $axisType = "OxyPlot.Axes.DateTimeAxis" }
  elseif ($Type -is [TimeSpan]) { $axisType = "OxyPlot.Axes.TimeSpanAxis" }
  else { $axisType = "OxyPlot.Axes.LinearAxis" }

  $axis = New-Object $axisType

  $axis.Position = $Position

  if ($null -ne $Title) {
    $axis.Title = $Title
  }

  $axis
}

############################################################

function Show-OxyPlot {
  [cmdletbinding()]
  param(
    [Parameter(ValueFromPipeline=$true)]
    [OxyPlot.Series.Series]$Series,
    [string]$StyleName,
    [string]$WindowAction = $OxyPlotCliWindowPreference,
    [OxyPlot.Axes.Axis]$XAxis,
    [OxyPlot.Axes.Axis]$YAxis
  )

begin {
  if ($WindowAction -ne "Add") {
    $model = New-Object OxyPlot.PlotModel
  }
  else {
    $model = (Get-OxyWindow).PlotModel
  }

  if ($null -ne $XAxis) {
    $model.Axes.Add($XAxis)
  }
  if ($null -ne $YAxis) {
    $model.Axes.Add($YAxis)
  }
}

process {
  $model.Series.Add($Series)

  if ($WindowAction -ne "Add" -and $null -eq $XAxis -and $series.PSObject.Properties.Name -Contains "_Info") {
    $XAxis = New-AxisAccordingToDataType $series._Info.XDataType $series._Info.XAxisTitle Bottom
  }

  if ($WindowAction -ne "Add" -and $null -eq $YAxis -and $series.PSObject.Properties.Name -Contains "_Info") {
    $YAxis = New-AxisAccordingToDataType $series._Info.YDataType $series._Info.YAxisTitle Left
  }
}

end {
  if ($null -ne $XAxis) {
    $model.Axes.Add($XAxis)
  }
  if ($null -ne $YAxis) {
    $model.Axes.Add($YAxis)
  }

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
