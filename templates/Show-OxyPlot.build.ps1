Set-StrictMode -Version 3

$TEMPLATE = "$PSScriptRoot\..\templates\Show-OxyPlot.template.ps1"
$TOOL1 = "$PSScriptRoot\..\tools\Insert-PropertyList.ps1"
$TOOL2 = "$PSScriptRoot\..\tools\Insert-Help.ps1"

$OUTPUTS = @(
  "Show-OxyPlot"
  "Save-OxyPlot"
  "New-OxyPlotModel"
)

$Document = [xml](Get-Content -Encoding utf8 $PSScriptRoot\..\lib\OxyPlot.Core.1.0.0\lib\net40\OxyPlot.XML)

$AxesClasses =
  [OxyPlot.Axes.Axis].Assembly.DefinedTypes |
  where { $_.Name -match "Axis$" -and !$_.IsAbstract }

$AxesClassNames = $AxesClasses | foreach { $_.FullName }

$AxesProperties =
  $AxesClasses |
  foreach { $_.GetProperties() } |
  where { $_.CanWrite } |
  Sort Name -Unique

foreach ($output in $OUTPUTS) {
  task "build_$output" `
    -Inputs $TEMPLATE, $TOOL1, $TOOL2 `
    -Outputs "$PSScriptRoot\..\OxyPlotCli\$output.ps1" `
    -Data $output `
    -Jobs {
      $output = $Task.Data
      Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

task . @($OUTPUTS -replace "^", "build_")
