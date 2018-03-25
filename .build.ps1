task . Build, LocalImport, Test

# Copy-Item without any exception
function Copy-ItemError {
  [cmdletbinding()]
  param(
    [string]$Source,
    [string]$Destination
  )

  try {
    Copy-Item $Source $Destination
  }
  catch {
    Write-Error $_
  }
}

task SetupOxyPlot {
  Install-Package OxyPlot.Core -Destination lib
  Install-Package OxyPlot.Wpf -Destination lib

  $null = mkdir "$PSScriptRoot\OxyPlotCli\lib" -force

  (Get-Item "$PSScriptRoot\lib\OxyPlot.Core.*\lib\net45\OxyPlot.dll").CopyTo("$PSScriptRoot\OxyPlotCli\lib\OxyPlot.dll")
  (Get-Item "$PSScriptRoot\lib\OxyPlot.Wpf.*\lib\net45\OxyPlot.Wpf.dll").CopyTo("$PSScriptRoot\OxyPlotCli\lib\OxyPlot.Wpf.dll")
}

task Build {

  . {
    $ErrorActionPreference = "Continue"
    Copy-ItemError "$PSScriptRoot\cs\WpfWindowCmdlets\bin\Release\WpfWindowCmdlets.dll" "$PSScriptRoot\OxyPlotCli"
    Copy-ItemError "$PSScriptRoot\cs\OxyPlotCliHelpers\bin\Release\OxyPlotCliHelpers.dll" "$PSScriptRoot\OxyPlotCli"
  }

  Add-Type -Path "$PSScriptRoot\OxyPlotCli\lib\OxyPlot.dll"
  Add-Type -Path "$PSScriptRoot\OxyPlotCli\lib\OxyPlot.Wpf.dll"
  Add-Type -Path "$PSScriptRoot\OxyPlotCli\WpfWindowCmdlets.dll"
  Add-Type -Path "$PSScriptRoot\OxyPlotCli\OxyPlotCliHelpers.dll"

  Copy-Item -Recurse "$PSScriptRoot\scripts\*" "$PSScriptRoot\OxyPlotCli"

  $null = mkdir "$PSScriptRoot\OxyPlotCli\datasets" -force
  Copy-Item -Recurse "$PSScriptRoot\datasets\*" "$PSScriptRoot\OxyPlotCli\datasets"

  $null = mkdir "$PSScriptRoot\OxyPlotCli\styles" -force
  Copy-Item -Recurse "$PSScriptRoot\styles\*" "$PSScriptRoot\OxyPlotCli\styles"

  . "$PSScriptRoot\scripts\Parameter.ps1"

  Import-Module HorkerTemplateEngine
  Invoke-Build -File "$PSScriptRoot\templates\template.build.ps1"
  Invoke-Build -File "$PSScriptRoot\templates\Axis.build.ps1"
  Invoke-Build -File "$PSScriptRoot\templates\Show-OxyPlot.build.ps1"

}

task LocalImport {
  Import-Module .\OxyPlotCli -Force

  # for testing purpose
  Set-OxyDefaultStyle ggplot
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

task Clean {
  Remove-Item -Force "$PSScriptRoot\OxyPlotCli\*.ps1"
}
