# ggplot2 default gray style
# https://github.com/tidyverse/ggplot2/blob/master/R/theme-defaults.r

Set-StrictMode -Version 3

$baseSize = 11.0
$baseLineSize = $baseSize / 22
$baseRectSize = $baseSize / 22
$halfLine = $baseSize / 2

$config = @{

  "[Unit]" = "pt"

  # Default
  "PlotModel.DefaultFontSize" = $baseSize

  "PlotModel.DefaultColors" = @()

  # PlotArea
  "PlotModel.PlotAreaBackground" = "#E5E5E5"
  "PlotModel.PlotAreaBorderThickness" = 0
  "PlotModel.TitleFontSize" = $baseSize * 1.2
  "PlotModel.SubtitleFontSize" = $baseSize * 0.9

  # Legend
  "PlotModel.LegendPosition" = "RightMiddle"
  "PlotModel.LegendPlacement" = "Outside"

  "PlotModel.LegendBorder" = "gray"
  "PlotModel.LegendBorderThickness" = "1px"

  "PlotModel.LegendTitleFontSize" = $baseSize
  "PlotModel.LegendTitleFontWeight" = "800px"
  "PlotModel.LegendFontSize" = $baseSize
  "PlotModel.LegendLineSpacing" = $baseLineSize

  # Axis: Tick
  "*Axis.TickStyle" = "Outside"
  "*Axis.TicklineColor" = "#4D4D4D"
  "*Axis.TextColor" = "#4D4D4D"
  "*Axis.FontSize" = $baseSize * 0.8

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
  "*Axis.TitleFontSize" = $baseSize * 1.2
  "*Axis.TitleColor" = "#4D4D4D"
  "*Axis.AxisTitleDistance" = $baseSize * 2

  # *Series
  "*Series.StrokeThickness" = "1px"
  "*Series.StrokeColor" = "Automatic"
  "*Series.FillColor" = "Automatic"

  # Scatter*Series
  "Scatter*Series.MarkerType" = "Diamond"
  "Scatter*Series.MarkerSize" = "3px"

  # Event hook
  "[BeforeRendering]" = {
    param($m)
    $n = $m.Series.Count
    if ($n -le 1) {
      $m.DefaultColors = [OxyPlot.OxyColor[]]@(New-OxyColor black)
    }
    else {
      $m.DefaultColors = Get-OxyHuePalette -N $n
    }
  }

}

Add-OxyStyle ggplot $config
