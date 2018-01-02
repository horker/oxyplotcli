Set-StrictMode -Version 3

$TEMPLATES = @(
  "PlotModel.template.ps1",
  "Window.template.ps1"
)

$SERIES_TEMPLATES = @(
  @{
    ClassName = "OxyPlot.Series.LineSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "LineSeries.ps1"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.TwoColorLineSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "TwoColorLineSeries.ps1"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.ScatterSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "ScatterSeries.ps1"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" },
      @{ Name = "Size"; Class = "double" },
      @{ Name = "Value"; Class = "double" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.ScatterErrorSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "ScatterErrorSeries.ps1"
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
    Template = "XYSeries.template.ps1"
    OutFile = "AreaSeries.ps1"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" },
      @{ Name = "X2"; Class = "object"; Axis = "X2" },
      @{ Name = "Y2"; Class = "object"; Axis = "Y2" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.TwoColorAreaSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "TwoColorAreaSeries.ps1"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "Y"; Class = "object"; Axis = "Y" },
      @{ Name = "X2"; Class = "object"; Axis = "X2" },
      @{ Name = "Y2"; Class = "object"; Axis = "Y2" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.CandleStickSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "CandleStickSeries.ps1"
    SeriesElement = @(
      @{ Name = "X"; Class = "object"; Axis = "X" },
      @{ Name = "High"; Class = "double"; Axis = "Y2" },
      @{ Name = "Low"; Class = "double"; Axis = "Y2" },
      @{ Name = "Open"; Class = "double"; Axis = "Y2" },
      @{ Name = "Close"; Class = "double"; Axis = "Y" }
    )
  },
  @{
    ClassName = "OxyPlot.Series.PieSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "PieSeries.ps1"
    NoAxis = $true
    SeriesElement = @(
      @{ Name = "Label"; Class = "string"; Axis = "" },
      @{ Name = "Value"; Class = "double"; Axis = "" }
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

foreach ($t in $TEMPLATES) {
  task "build_$t" `
    -Inputs ($t -replace "^", "$PSScriptRoot\..\templates\") `
    -Outputs ($t -replace "^(.+)\.template\.ps1$", "$PSScriptRoot\..\OxyPlotCli\`$1.ps1") `
    -Partial `
    -Jobs {
       process {
         Get-Content $_ | Invoke-TemplateEngine | Set-Content $2
      }
    }
}

Set-StrictMode -Off

foreach ($t in $SERIES_TEMPLATES) {
  task "build_$($t.ClassName)" `
    -Inputs ($t.Template -replace "^", "$PSScriptRoot\..\templates\") `
    -Outputs ($t.OutFile -replace "^", "$PSScriptRoot\..\OxyPlotCli\") `
    -Data $t `
    -Partial `
    -Jobs {
       process {
         $ClassName = $Task.Data.ClassName
         $SeriesElement = $Task.Data.SeriesElement
         $NoAxis = $Task.Data.NoAxis
         Get-Content $_ | Invoke-TemplateEngine | Set-Content $2
      }
    }
}
