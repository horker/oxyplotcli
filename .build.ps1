
task . Build, LocalImport, Test

task SetupOxyPlot {
  Install-Package OxyPlot.Core -Destination lib
  Install-Package OxyPlot.Wpf -Destination lib

  $null = mkdir "$PSScriptRoot\OxyPlotCli\lib" -force

  (Get-Item "$PSScriptRoot\lib\OxyPlot.Core.*\lib\net40\OxyPlot.dll").CopyTo("$PSScriptRoot\OxyPlotCli\lib\OxyPlot.dll")
  (Get-Item "$PSScriptRoot\lib\OxyPlot.Wpf.*\lib\net40\OxyPlot.Wpf.dll").CopyTo("$PSScriptRoot\OxyPlotCli\lib\OxyPlot.Wpf.dll")
}

task Build {
  Copy-Item -Recurse -Force "$PSScriptRoot\scripts\*" "$PSScriptRoot\OxyPlotCli"

  Import-Module HorkerTemplateEngine
  Invoke-Build -File "$PSScriptRoot\templates\template.build.ps1"
}

task LocalImport {
  Import-Module .\OxyPlotCli -Force
}

task Install {
  $INSTALL_PATH = "$HOME\Documents\WindowsPowerShell\Modules\OxyPlotCli"
  if (Test-Path $INSTALL_PATH) {
    Remove-Item -Recurse -Force "$HOME\Documents\WindowsPowerShell\Modules\OxyPlotCli" -EA Continue
  }
  else {
    $null = mkdir $INSTALL_PATH
  }
  Copy-Item -Recurse -Force OxyPlotCli\* $INSTALL_PATH
}

task TouchTemplate {
  (Get-Item "$PSScriptRoot\templates\XYSeries.template.ps1").LastWriteTime = Get-Date
}

task Test {
  Invoke-Pester tests
}
