Set-StrictMode -Version 3

$AXIS_CLASSES = @(
  "OxyPlot.Axes.AngleAxis",
  "OxyPlot.Axes.CategoryAxis",
  "OxyPlot.Axes.DateTimeAxis",
  "OxyPlot.Axes.LinearAxis",
  "OxyPlot.Axes.LinearColorAxis",
  "OxyPlot.Axes.LogarithmicAxis",
  "OxyPlot.Axes.MagnitudeAxis",
  "OxyPlot.Axes.RangeColorAxis",
  "OxyPlot.Axes.TimeSpanAxis"
)

$TEMPLATE = "$PSScriptRoot\Axis.template.ps1"

foreach ($c in $AXIS_CLASSES) {
  task "build_$c" `
    -Inputs $TEMPLATE `
    -Outputs ($c -replace "(.+)", "$PSScriptRoot\..\OxyPlotCli\`$1.ps1") `
    -Data $c `
    -Jobs {
      $ClassName = $Task.Data
      Get-Content $Inputs | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

task . @($AXIS_CLASSES -replace "^", "build_")
