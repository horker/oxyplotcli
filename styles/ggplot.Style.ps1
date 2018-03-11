# ggplot2 default gray style
# https://github.com/tidyverse/ggplot2/blob/master/R/theme-defaults.r

Set-StrictMode -Version 3

$baseSize = 11.0
$baseLineSize = $baseSize / 22
$baseRectSize = $baseSize / 22
$halfLine = $baseSize / 2

$config = @{

  # Default
  "PlotModel.DefaultFontSize" = $baseSize, "pt"

  # PlotArea
  "PlotModel.PlotAreaBackground" = "#E5E5E5"
  "PlotModel.PlotAreaBorderThickness" = 0
  "PlotModel.TitleFontSize" = ($baseSize * 1.2), "pt"
  "PlotModel.SubtitleFontSize" = ($baseSize * 0.9), "pt"

  # Legend
  "PlotModel.LegendPosition" = "RightMiddle"
  "PlotModel.LegendPlacement" = "Outside"

  "PlotModel.LegendBorder" = "gray"
  "PlotModel.LegendBorderThickness" = "1px"

  "PlotModel.LegendTitleFontSize" = $baseSize, "pt"
  "PlotModel.LegendTitleFontWeight" = 800
  "PlotModel.LegendFontSize" = $baseSize, "pt"
  "PlotModel.LegendLineSpacing" = $baseLineSize, "pt"

  # Axis: Tick
  "*Axis.TickStyle" = "Outside"
  "*Axis.TicklineColor" = "#4D4D4D"
  "*Axis.TextColor" = "#4D4D4D"
  "*Axis.FontSize" = ($baseSize * 0.8), "pt"

  # Axis: MinorTick
  "*Axis.MinorTickSize" = 0

  # Axis: MajorGridline
  "*Axis.MajorGridlineStyle" = "Solid"
  "*Axis.MajorGridlineColor" = "White"
  "*Axis.MajorGridlineThickness" = "1px"

  # Axis: MinorGridline
  "*Axis.MinorGridlineStyle" = "Solid"
  "*Axis.MinorGridlineColor" = "#F0F0F0"
  "*Axis.MinorGridlineThickness" = "1px"

  # Axis: Title
  "*Axis.TitleFontSize" = ($baseSize * 1.2), "pt"
  "*Axis.TitleColor" = "#4D4D4D"
  "*Axis.AxisTitleDistance" = ($baseSize * 2), "pt"

  # *Series
  "*Series.StrokeThickness" = "1px"
  "*Series.StrokeColor" = "Automatic"
  "*Series.FillColor" = "Automatic"
  "*Series.FontSize" = $baseSize, "pt"

  # Scatter*Series
  "Scatter*Series.MarkerType" = "Diamond"
  "Scatter*Series.MarkerSize" = "3px"

  # PieSeries
  "PieSeries.StartAngle" = -90
  "PieSeries.Diameter" = 0.9
  "PieSeries.InnerDiameter" = 0.4
  "PieSeries.AreInsideLabelsAngled" = $true

  # Event hook
  "[BeforeRendering]" = {
    param($m)
    if ($m.DefaultColors.Count -eq 0 -or $m.Series.Count -gt 0) {
      $n = $m.Series.Count
      if ($n -eq 1) {
        if ($m.Series[0] -is [OxyPlot.Series.PieSeries]) {
          $m.DefaultColors = Get-OxyHuePalette -N $m.Series[0].Slices.Count
        }
        else {
          $m.DefaultColors = [OxyPlot.OxyColor[]]@(New-OxyColor black)
        }
      }
      else {
        $m.DefaultColors = Get-OxyHuePalette -N $n
      }
    }
  }

}

Add-OxyStyle ggplot $config
