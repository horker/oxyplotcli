Set-StrictMode -Version 3

$AXIS_CLASSES = @(
  "OxyPlot.Axes.AngleAxis"
  "OxyPlot.Axes.CategoryAxis"
  "OxyPlot.Axes.DateTimeAxis"
  "OxyPlot.Axes.LinearAxis"
  "OxyPlot.Axes.LinearColorAxis"
  "OxyPlot.Axes.LogarithmicAxis"
  "OxyPlot.Axes.MagnitudeAxis"
  "OxyPlot.Axes.RangeColorAxis"
  "OxyPlot.Axes.TimeSpanAxis"

  "OxyPlot.Annotations.ImageAnnotation"
  "OxyPlot.Annotations.ArrowAnnotation"
  "OxyPlot.Annotations.TextAnnotation"
  "OxyPlot.Annotations.FunctionAnnotation"
  "OxyPlot.Annotations.LineAnnotation"
  "OxyPlot.Annotations.PolylineAnnotation"
  "OxyPlot.Annotations.EllipseAnnotation"
  "OxyPlot.Annotations.PointAnnotation"
  "OxyPlot.Annotations.PolygonAnnotation"
  "OxyPlot.Annotations.RectangleAnnotation"
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
