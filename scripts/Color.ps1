# Source:
# https://github.com/hadley/scales/blob/master/R/pal-hue.r
#
# Equivalent to in R:
# library("scale")
# hue_pal()(4)

function Get-OxyHuePalette {
  [cmdletbinding()]
  param(
    [double]$HFrom = 15,
    [double]$HTo = 360 + 15,
    [double]$C = 100,
    [double]$L = 65,
    [double]$HStart = 0.0,
    [int]$Direction = 1,
    [int]$N
  )

  if (($HTo - $HFrom) % 360 -lt 1.0) {
    $HTo -= 360.0 / $N
  }

  # To be able to assign directly to PlotModel.DefaultColors,
  # return as List[OxyPlot.OxyColor]
  $result = New-Object Collections.Generic.List[OxyPlot.OxyColor]

  for ($i = 0; $i -lt $N; ++$i) {
    $h0 = $HFrom + ($HTo - $HFrom) / ($N-1) * $i * $Direction
    $h = ($h0 + $HStart) % 360
    $rgb = [OxyPlotCliHelpers.ColorConverter]::ConvertHclToRgb($h, $C, $L)
    $rgb.Fixup()
    $result.Add($rgb.ToString())
  }

  , $result
}
