# ggplot2 default gray style
# https://github.com/tidyverse/ggplot2/blob/master/R/theme-defaults.r

$baseSize = 11.0
$baseLineSize = $baseSize / 22
$baseRectSize = $baseSize / 22
$halfLine = $baseSize / 2

$config = @{

  "unit" = "pt"

  "PlotModel.DefaultFontSize" = $baseSize
  "PlotModel.DefaultColors" = 'E24A33', '348ABD', '988ED5', '777777', 'FBC15E', '8EBA42', 'FFB5B8'
  "PlotModel.PlotAreaBackground" = "#E5E5E5"
  "PlotModel.TitleFontSize" = $baseSize * 1.2
  "PlotModel.SubtitleFontSize" = $baseSize * 0.9
  "PlotModel.PlotAreaBorderThickness" = 0

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
  "*Axis.TitleFontSize" = $baseSize
  "*Axis.TitleColor" = "#4D4D4D"

  # Series
  "*Series.StrokeThickness" = "1px"
  "*Series.Color" = "#348ABD"
  "*Series.MarkerType" = "Diamond"
  "*Series.MarkerSize" = "3px"

}

Add-OxyStyle ggplot $config
