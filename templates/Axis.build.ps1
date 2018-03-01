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
$TOOL1 = "$PSScriptRoot\..\tools\Insert-PropertyList.ps1"
$TOOL2 = "$PSScriptRoot\..\tools\Insert-Help.ps1"

$Document = [xml](Get-Content -Encoding utf8 $PSScriptRoot\..\lib\OxyPlot.Core.1.0.0\lib\net40\OxyPlot.XML)

foreach ($c in $AXIS_CLASSES) {
  task "build_$c" `
    -Inputs $TEMPLATE, $TOOL1, $TOOL2 `
    -Outputs ($c -replace "(.+)", "$PSScriptRoot\..\OxyPlotCli\`$1.ps1") `
    -Data $c `
    -Jobs {
      $ClassName = $Task.Data
      Get-Content $TEMPLATE | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

task . @($AXIS_CLASSES -replace "^", "build_")
