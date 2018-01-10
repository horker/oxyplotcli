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
    @{ Name = "X"; Class = "object"; Axis = "X" },
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

$DATAPOINTS.Bar = @{
  Cmdlet = "Add-OxyBarSeriesPoint"
  Element = @(
    @{ Name = "Value"; Class = "object" },
    @{ Name = "CategoryIndex"; Class = "int" }
  )
}

$DATAPOINTS.Column = @{
  Cmdlet = "Add-OxyColumnSeriesPoint"
  Element = @(
    @{ Name = "Value"; Class = "object" },
    @{ Name = "CategoryIndex"; Class = "int" }
  )
}

$DATAPOINTS.ErrorColumn = @{
  Cmdlet = "Add-OxyErrorColumnSeriesPoint"
  Element = @(
    @{ Name = "Value"; Class = "object" },
    @{ Name = "Error"; Class = "object" },
    @{ Name = "CategoryIndex"; Class = "int" }
  )
}

$DATAPOINTS.IntervalBar = @{
  Cmdlet = "Add-OxyIntervalBarSeriesPoint"
  Element = @(
    @{ Name = "Start"; Class = "object" },
    @{ Name = "End"; Class = "object" },
    @{ Name = "BarTitle"; PropertyName = "Title"; Class = "string" } # renamed from Title to avoid conflict against the Series.InternalBarSeries property
  )
}

$DATAPOINTS.RectangleBar = @{
  Cmdlet = "Add-OxyRectangleBarSeriesPoint"
  Element = @(
    @{ Name = "X0"; Class = "object" },
    @{ Name = "Y0"; Class = "object" },
    @{ Name = "X1"; Class = "object" },
    @{ Name = "Y1"; Class = "object" }
  )
}

#$DATAPOINTS.TornadoBar = @{
#  Cmdlet = "Add-OxyTornadoBarSeriesPoint"
#  Element = @(
#    @{ Name = "Minimum"; Class = "object" },
#    @{ Name = "Maximum"; Class = "object" },
#    @{ Name = "BaseValue"; Class = "object" },
#    @{ Name = "MinimumColor"; Class = "string" },
#    @{ Name = "MinimumColor"; Class = "string" }
#  )
#}

$DATAPOINTS.CandleStickAndVolume = @{
  Cmdlet = "Add-OxyCandleStickAndVolumeSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "object" },
    @{ Name = "Open"; Class = "double" },
    @{ Name = "High"; Class = "double" },
    @{ Name = "Low"; Class = "double" },
    @{ Name = "Close"; Class = "double" },
    @{ Name = "BuyVolume"; Class = "double" },
    @{ Name = "SellVolume"; Class = "double" }
  )
}

$DATAPOINTS.BoxPlot = @{
  Cmdlet = "Add-OxyBoxPlotSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "object" },
    @{ Name = "LowerWhisker"; Class = "double" },
    @{ Name = "BoxBottom"; Class = "double" },
    @{ Name = "Median"; Class = "double" },
    @{ Name = "BoxTop"; Class = "double" },
    @{ Name = "UpperWhisker"; Class = "double" }
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

  @{
    ClassName = "OxyPlot.Series.BarSeries"
    SeriesElement = $DATAPOINTS.Bar
    LeftAxisType = "OxyPlot.Axes.CategoryAxis"
  },

  @{
    ClassName = "OxyPlot.Series.BoxPlotSeries"
    SeriesElement = $DATAPOINTS.BoxPlot
  },

  @{
    ClassName = "OxyPlot.Series.CandleStickAndVolumeSeries"
    SeriesElement = $DATAPOINTS.CandleStickAndVolume
    RightAxisType = "OxyPlot.Axes.LinearAxis"
  },

  @{
    ClassName = "OxyPlot.Series.CandleStickSeries"
    SeriesElement = $DATAPOINTS.CandleStick
  },

  @{
    ClassName = "OxyPlot.Series.ColumnSeries"
    SeriesElement = $DATAPOINTS.Column
    BottomAxisType = "OxyPlot.Axes.CategoryAxis"
  },

  # ContourSeries

  @{
    ClassName = "OxyPlot.Series.ErrorColumnSeries"
    SeriesElement = $DATAPOINTS.ErrorColumn
    BottomAxisType = "OxyPlot.Axes.CategoryAxis"
  },

  # FunctionSeries
  # HeapMapSeries

  @{
    ClassName = "OxyPlot.Series.HighLowSeries"
    SeriesElement = $DATAPOINTS.CandleStick
  },

  @{
    ClassName = "OxyPlot.Series.IntervalBarSeries"
    SeriesElement = $DATAPOINTS.IntervalBar
    LeftAxisType = "OxyPlot.Axes.CategoryAxis"
  },

  @{
    ClassName = "OxyPlot.Series.LinearBarSeries"
    SeriesElement = $DATAPOINTS.Line
    LeftAxisType = "OxyPlot.Axes.CategoryAxis"
  },

  @{
    ClassName = "OxyPlot.Series.LineSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.PieSeries"
    SeriesElement = $DATAPOINTS.Pie
    BottomAxisType = "none"
    LeftAxisType = "none"
  }

  # PolarHeapMapSeries

  @{
    ClassName = "OxyPlot.Series.RectangleBarSeries"
    SeriesElement = $DATAPOINTS.RectangleBar
    LeftAxisType = "OxyPlot.Axes.CategoryAxis"
  },

  @{
    ClassName = "OxyPlot.Series.ScatterErrorSeries"
    SeriesElement = $DATAPOINTS.ScatterError
  },

  @{
    ClassName = "OxyPlot.Series.ScatterSeries"
    SeriesElement = $DATAPOINTS.Scatter
  },

  @{
    ClassName = "OxyPlot.Series.StairStepSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.StemSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.ThreeColorLineSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.TwoColorAreaSeries"
    SeriesElement = $DATAPOINTS.Area
  },

  @{
    ClassName = "OxyPlot.Series.TwoColorLineSeries"
    SeriesElement = $DATAPOINTS.Line
  }

#  @{
#    ClassName = "OxyPlot.Series.TornadoBarSeries"
#    SeriesElement = $DATAPOINTS.TornadoBar
#  }

  @{
    ClassName = "OxyPlot.Series.VolumeSeries"
    SeriesElement = $DATAPOINTS.CandleStickAndVolume
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

      # AxisType
      $BottomAxisType = "linear"
      $LeftAxisType = "linear"
      $RightAxisType = "none"
      if ($Task.Data.PSObject.Properties.Name -Contains "BottomAxisType") {
        $BottomAxisType = $Task.Data.BottomAxisType
      }
      if ($Task.Data.PSObject.Properties.Name -Contains "LeftAxisType") {
        $LeftAxisType = $Task.Data.LeftAxisType
      }
      if ($Task.Data.PSObject.Properties.Name -Contains "RightAxisType") {
        $RightAxisType = $Task.Data.RightAxisType
      }
      Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

############################################################

$seriesCmdlets = $SERIES_TEMPLATES | foreach {
  $_.ClassName -replace "^(.+\.)*(.+)", 'New-Oxy$2'
} | Sort

$seriesAliases = $seriesCmdlets | foreach {
  ($_ -replace "^New-(.+)Series$", '$1').ToLower()
} | Sort

task "build_OxyPlotCli.psd1" `
  -Inputs "$PSScriptRoot\..\templates\OxyPlotCli.template.psd1", $thisFile `
  -Outputs "$PSScriptRoot\..\OxyPlotCli\OxyPlotCli.psd1" `
  -Jobs {
    Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
  }

############################################################

task . (@($TEMPLATES -replace "^", "build_") + @($SERIES_TEMPLATES.ClassName -replace "^", "build_") + @("build_OxyPlotCli.psd1"))
