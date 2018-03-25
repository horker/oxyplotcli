task . Load, Build, ImportLocal, Test

$TARGET_PATH =         "$PSScriptRoot\OxyPlotCli"
$TARGET_VENDOR_PATH =  "$TARGET_PATH\lib"
$TARGET_STYLE_PATH =   "$TARGET_PATH\styles"
$TARGET_DATASET_PATH = "$TARGET_PATH\datasets"

$VENDOR_PATH = "$PSScriptRoot\lib"

$OXYPLOT_CORE_FILE = Resolve-Path "$VENDOR_PATH\OxyPlot.Core.*\lib\net45\OxyPlot.dll"
$OXYPLOT_WPF_FILE = Resolve-Path "$VENDOR_PATH\OxyPlot.Wpf.*\lib\net45\OxyPlot.Wpf.dll"
$OXYPLOTCLI_FILE = "$PSScriptRoot\source\Horker.OxyPlotCli\bin\Release\Horker.OxyPlotCli.dll"

# Copy-Item without any exception
function Copy-ItemError {
  [cmdletbinding()]
  param(
    [string]$Source,
    [string]$Destination,
    [switch]$Recurse
  )

  try {
    Copy-Item -Recurse:$Recurse $Source $Destination
  }
  catch {
    Write-Error $_
  }
}

task InstallOxyPlot {
  Install-Package OxyPlot.Core -Destination $VENDOR_PATH
  Install-Package OxyPlot.Wpf -Destination $VENDOR_PATH

  $null = mkdir $VENDOR_PATH -force

  Copy-ItemError $OXYPLOT_CORE_FILE $TARGET_VENDOR_PATH
  Copy-ItemError $OXYPLOT_WPF_FILE $TARGET_VENDOR_PATH
}

# Load necessary modules for the build process
task Load {
  Import-Module HorkerTemplateEngine

  Add-Type -Path $OXYPLOT_CORE_FILE
  Add-Type -Path $OXYPLOT_WPF_FILE
  Add-Type -Path $OXYPLOTCLI_FILE
}

task Build {
  $ErrorActionPreference = "Continue"

  Copy-ItemError $OXYPLOTCLI_FILE $TARGET_PATH

  Copy-ItemError -Recurse "$PSScriptRoot\scripts\*" $TARGET_PATH

  $null = mkdir $TARGET_DATASET_PATH -force
  Copy-ItemError -Recurse "$PSScriptRoot\datasets\*" $TARGET_DATASET_PATH

  $null = mkdir $TARGET_STYLE_PATH -force
  Copy-ItemError -Recurse "$PSScriptRoot\styles\*" $TARGET_STYLE_PATH

  Invoke-Build -File "$PSScriptRoot\templates\template.build.ps1"
  Invoke-Build -File "$PSScriptRoot\templates\Axis.build.ps1"
  Invoke-Build -File "$PSScriptRoot\templates\Show-OxyPlot.build.ps1"
}

task ImportLocal {
  Import-Module .\OxyPlotCli -Force

  # for testing purpose
  Set-OxyDefaultStyle ggplot
}

task TouchTemplate {
  (Get-Item "$PSScriptRoot\templates\XYSeries.template.ps1").LastWriteTime = Get-Date
}

task Test {
  Invoke-Pester tests
}

task Clean {
  Remove-Item -Force "$TARGET_PATH\*.ps1"
  Remove-Item -Force $TARGET_STYLE_PATH
  Remove-Item -Force $TARGET_DATASET_PATH

  Remove-Item -Force "$TARGET_PATH\*.dll"
}
