Set-StrictMode -Version 3

$TEMPLATE = "$PSScriptRoot\..\templates\Show-OxyPlot.template.ps1"
$TOOL = "$PSScriptRoot\..\tools\Insert-PropertyList.ps1"

$OUTPUTS = @(
  "Show-OxyPlot"
  "Save-OxyPlot"
  "New-OxyPlotModel"
)

foreach ($output in $OUTPUTS) {
  task "build_$output" `
    -Inputs $TEMPLATE, $TOOL `
    -Outputs "$PSScriptRoot\..\OxyPlotCli\$output.ps1" `
    -Data $output `
    -Jobs {
      $output = $Task.Data
      Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

task . @($OUTPUTS -replace "^", "build_")
