Set-StrictMode -Version 3

############################################################
# Template files

$TEMPLATES = @(
  "PlotModel.template.ps1",
  "OxyWindow.template.ps1"
)

############################################################
# Data point definitions

$DATAPOINTS = @{}

$DATAPOINTS.Line = @{
  Cmdlet = "Add-OxyLineSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "object"; Axis = "X" },
    @{ Name = "Y"; Class = "object"; Axis = "Y" }
  )
}

$DATAPOINTS.Scatter = @{
  Cmdlet = "Add-OxyScatterSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "object"; Axis = "X" },
    @{ Name = "Y"; Class = "object"; Axis = "Y" },
    @{ Name = "Size"; Class = "double" },
    @{ Name = "Value"; Class = "double" }
  )
}

$DATAPOINTS.ScatterError = @{
  Cmdlet = "Add-OxyScatterErrorSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "object"; Axis = "X" },
    @{ Name = "Y"; Class = "object"; Axis = "Y" },
    @{ Name = "ErrorX"; Class = "object"; Axis = "X2" },
    @{ Name = "ErrorY"; Class = "object"; Axis = "Y2" },
    @{ Name = "Size"; Class = "double" },
    @{ Name = "Value"; Class = "double" }
  )
}

$DATAPOINTS.Area = @{
  Cmdlet = "Add-OxyAreaSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "object"; Axis = "X" },
    @{ Name = "Y"; Class = "object"; Axis = "Y" },
    @{ Name = "X2"; Class = "object"; Axis = "X2" },
    @{ Name = "Y2"; Class = "object"; Axis = "Y2" }
  )
}

$DATAPOINTS.CandleStick = @{
  Cmdlet = "Add-OxyCandleStickSeriesPoint"
  Element = @(
    @{ Name = "High"; Class = "double"; Axis = "Y2" },
    @{ Name = "Low"; Class = "double"; Axis = "Y2" },
    @{ Name = "Open"; Class = "double"; Axis = "Y2" },
    @{ Name = "Close"; Class = "double"; Axis = "Y" }
  )
}

$DATAPOINTS.Pie = @{
  Cmdlet = "Add-OxyPieSeriesPoint"
  Element = @(
    @{ Name = "Label"; Class = "string" },
    @{ Name = "Value"; Class = "double" },
    @{ Name = "Fill"; Class = "string" },
    @{ Name = "IsExploded"; Class = "object" }
  )
}

([string[]]$DATAPOINTS.Keys) | foreach {
  $value = [PsCustomObject]$DATAPOINTS.$_
  $value.Element = @($value.Element | foreach { [PSCustomObject]$_ })
  $DATAPOINTS.$_ = $value
}

############################################################
# Series template definitions

$SERIES_TEMPLATES = @(
  @{
    ClassName = "OxyPlot.Series.AreaSeries"
    SeriesElement = $DATAPOINTS.Area
  },

  # BarSeries
  # BoxPlotSeries
  # CandleStickAndVolumeSeries

  @{
    ClassName = "OxyPlot.Series.CandleStickSeries"
    SeriesElement = $DATAPOINTS.CandleStick
  },

  # ColumnSeries
  # ContourSeries
  # ErrorColumnSeries
  # FunctionSeries
  # HeapMapSeries
  # HighLowSeries
  # IntervalBarSeries

  @{
    ClassName = "OxyPlot.Series.LinearBarSeries"
    SeriesElement = $DATAPOINTS.Line
  },
  @{
    ClassName = "OxyPlot.Series.LineSeries"
    SeriesElement = $DATAPOINTS.Line
  },
  @{
    ClassName = "OxyPlot.Series.PieSeries"
    SeriesElement = $DATAPOINTS.Pie
    NoAxis = $true
  }

  # PolarHeapMapSeries
  # RectangleBarSeries

  @{
    ClassName = "OxyPlot.Series.ScatterErrorSeries"
    SeriesElement = $DATAPOINTS.ScatterError
  },
  @{
    ClassName = "OxyPlot.Series.ScatterSeries"
    SeriesElement = $DATAPOINTS.Scatter
  },

  # StairStepSeries
  # StemSeries
  # ThreeColorLineSeries
  # TornadoBarSeries

  @{
    ClassName = "OxyPlot.Series.TwoColorAreaSeries"
    SeriesElement = $DATAPOINTS.Area
  },
  @{
    ClassName = "OxyPlot.Series.TwoColorLineSeries"
    SeriesElement = $DATAPOINTS.Line
  }
)

$SERIES_TEMPLATES = $SERIES_TEMPLATES | foreach {
  [PSCustomObject]$_
}

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

$thisFile = "$PSScriptRoot\..\templates\template.build.ps1"
$defaultTemplate = "XYSeries.template.ps1"

foreach ($t in $SERIES_TEMPLATES) {
  $template = $defaultTemplate
  if ($t.PSObject.Properties.Name -Contains "Template") {
    $template = $t.Template
  }
  task "build_$($t.ClassName)" `
    -Inputs ($template -replace "^", "$PSScriptRoot\..\templates\"), $thisFile `
    -Outputs ($t.ClassName -replace "(.+)", "$PSScriptRoot\..\OxyPlotCli\`$1.ps1") `
    -Data $t `
    -Jobs {
      $ClassName = $Task.Data.ClassName
      $SeriesElement = $Task.Data.SeriesElement
      $NoAxis = $false
      if ($Task.Data.PSObject.Properties.Name -Contains "NoAxis") {
        $NoAxis = $Task.Data.NoAxis
      }
      Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

############################################################

$seriesCmdlets = $SERIES_TEMPLATES | foreach {
  $_.ClassName -replace "^(.+\.)*(.+)", '"New-Oxy$2"'
} | Sort

task "build_OxyPlotCli.psd1" `
  -Inputs "$PSScriptRoot\..\templates\OxyPlotCli.template.psd1", $thisFile `
  -Outputs "$PSScriptRoot\..\OxyPlotCli\OxyPlotCli.psd1" `
  -Jobs {
    Get-Content $Inputs[0] | Invoke-TemplateEngine -processorfile temp.ps1 | Set-Content $Outputs
  }

############################################################

task . (@($TEMPLATES -replace "^", "build_") + @($SERIES_TEMPLATES.ClassName -replace "^", "build_") + @("build_OxyPlotCli.psd1"))
