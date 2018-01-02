Set-StrictMode -Version 3

$TEMPLATES = @(
  "PlotModel.template.ps1",
  "Window.template.ps1"
)

$SERIES_TEMPLATES = @(
  [PSCustomObject]@{
    ClassName = "OxyPlot.Series.LineSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "LineSeries.ps1"
    SeriesElement = @(
      [PSCustomObject]@{ Name = "X"; Class = "object"; Axis = "X" },
      [PSCustomObject]@{ Name = "Y"; Class = "object"; Axis = "Y" }
    )
  },
  [PSCustomObject]@{
    ClassName = "OxyPlot.Series.ScatterSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "ScatterSeries.ps1"
    SeriesElement = @(
      [PSCustomObject]@{ Name = "X"; Class = "object"; Axis = "X" },
      [PSCustomObject]@{ Name = "Y"; Class = "object"; Axis = "Y" },
      [PSCustomObject]@{ Name = "Size"; Class = "double" },
      [PSCustomObject]@{ Name = "Value"; Class = "double" }
    )
  },
  [PSCustomObject]@{
    ClassName = "OxyPlot.Series.ScatterErrorSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "ScatterErrorSeries.ps1"
    SeriesElement = @(
      [PSCustomObject]@{ Name = "X"; Class = "object"; Axis = "X" },
      [PSCustomObject]@{ Name = "Y"; Class = "object"; Axis = "Y" },
      [PSCustomObject]@{ Name = "ErrorX"; Class = "object"; Axis = "X2" },
      [PSCustomObject]@{ Name = "ErrorY"; Class = "object"; Axis = "Y2" },
      [PSCustomObject]@{ Name = "Size"; Class = "double" },
      [PSCustomObject]@{ Name = "Value"; Class = "double" }
    )
  },
  [PSCustomObject]@{
    ClassName = "OxyPlot.Series.AreaSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "AreaSeries.ps1"
    SeriesElement = @(
      [PSCustomObject]@{ Name = "X"; Class = "object"; Axis = "X" },
      [PSCustomObject]@{ Name = "Y"; Class = "object"; Axis = "Y" },
      [PSCustomObject]@{ Name = "X2"; Class = "object"; Axis = "X2" },
      [PSCustomObject]@{ Name = "Y2"; Class = "object"; Axis = "Y2" }
    )
  },
  [PSCustomObject]@{
    ClassName = "OxyPlot.Series.CandleStickSeries"
    Template = "XYSeries.template.ps1"
    OutFile = "CandleStickSeries.ps1"
    SeriesElement = @(
      [PSCustomObject]@{ Name = "X"; Class = "object"; Axis = "X" },
      [PSCustomObject]@{ Name = "High"; Class = "double"; Axis = "Y2" },
      [PSCustomObject]@{ Name = "Low"; Class = "double"; Axis = "Y2" },
      [PSCustomObject]@{ Name = "Open"; Class = "double"; Axis = "Y2" },
      [PSCustomObject]@{ Name = "Close"; Class = "double"; Axis = "Y" }
    )
  }
)

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
         Get-Content $_ | Invoke-TemplateEngine | Set-Content $2
      }
    }
}
