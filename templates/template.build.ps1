Set-StrictMode -Version 3

$TEMPLATES = @(
  "PlotModel.template.ps1",
  "OxyWindow.template.ps1"
)

############################################################

$SERIES_TEMPLATES = @(
  @{
    ClassName = "OxyPlot.Series.LineSeries"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.TwoColorLineSeries"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.ScatterSeries"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" },
      @{ Name = "Size"; Class = "double" },
      @{ Name = "Value"; Class = "double" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.ScatterErrorSeries"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" },
      @{ Name = "ErrorX"; Class = "object"; Axis = "X2" },
      @{ Name = "ErrorY"; Class = "object"; Axis = "Y2" },
      @{ Name = "Size"; Class = "double" },
      @{ Name = "Value"; Class = "double" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.AreaSeries"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" },
      @{ Name = "X2"; Class = "object"; Axis = "X2" },
      @{ Name = "Y2"; Class = "object"; Axis = "Y2" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.TwoColorAreaSeries"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" },
      @{ Name = "X2"; Class = "object"; Axis = "X2" },
      @{ Name = "Y2"; Class = "object"; Axis = "Y2" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.CandleStickSeries"
    SeriesElement = @(
      @{ Name = "High"; Class = "double"; Axis = "Y2" },
      @{ Name = "Low"; Class = "double"; Axis = "Y2" },
      @{ Name = "Open"; Class = "double"; Axis = "Y2" },
      @{ Name = "Close"; Class = "double"; Axis = "Y" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.PieSeries"
    NoAxis = $true
    SeriesElement = @(
      @{ Name = "Label"; Class = "string" },
      @{ Name = "Value"; Class = "double" },
      @{ Name = "Fill"; Class = "string" },
      @{ Name = "IsExploded"; Class = "object" }
    )
  }
)

$SERIES_TEMPLATES = $SERIES_TEMPLATES | foreach {
  $_.SeriesElement = $_.SeriesElement | foreach {
    [PSCustomObject]$_
  }
  [PSCustomObject]$_
}

############################################################

task . (@($TEMPLATES -replace "^", "build_") + @($SERIES_TEMPLATES.ClassName -replace "^", "build_"))

############################################################

foreach ($t in $TEMPLATES) {
  task "build_$t" `
    -Inputs ($t -replace "^", "$PSScriptRoot\..\templates\") `
    -Outputs ($t -replace "^(.+)\.template\.ps1$", "$PSScriptRoot\..\OxyPlotCli\`$1.ps1") `
    -Jobs {
      Get-Content $Inputs | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

############################################################

Set-StrictMode -Off

$thisFile = "$PSScriptRoot\..\templates\template.build.ps1"
$defaultTemplate = "XYSeries.template.ps1"

foreach ($t in $SERIES_TEMPLATES) {
  $template = $t.Template
  if ($null -eq $template) {
    $template = $defaultTemplate
  }
  task "build_$($t.ClassName)" `
    -Inputs ($template -replace "^", "$PSScriptRoot\..\templates\"), $thisFile `
    -Outputs ($t.ClassName -replace "(.+)", "$PSScriptRoot\..\OxyPlotCli\`$1.ps1") `
    -Data $t `
    -Jobs {
      $ClassName = $Task.Data.ClassName
      $SeriesElement = $Task.Data.SeriesElement
      $NoAxis = $Task.Data.NoAxis
      Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
    }
}
