Set-StrictMode -Version 3

Describe "Double Paramter" {

  It "accepts [Double] paramters in various formats" {
    $m = New-OxyPlotModel -DefaultFontSize ([double]11.1)
    $m.DefaultFontSize | Should -Be 11.1

    $m = New-OxyPlotModel -DefaultFontSize "11.1"
    $m.DefaultFontSize | Should -Be 11.1

    $m = New-OxyPlotModel -DefaultFontSize "11.1px"
    $m.DefaultFontSize | Should -Be 11.1

    $m = New-OxyPlotModel -DefaultFontSize "11.1pt"
    $m.DefaultFontSize | Should -Be (11.1 * (96.0 / 72))

    $m = New-OxyPlotModel -DefaultFontSize "2017/01/01"
    $m.DefaultFontSize | Should -Be ([OxyPlot.Axes.DateTimeAxis]::ToDouble([datetime]"2017/1/1"))

    $m = New-OxyPlotModel -DefaultFontSize "+00:00:03"
    $m.DefaultFontSize | Should -Be ([OxyPlot.Axes.TimeSpanAxis]::ToDouble([TimeSpan]::Parse("00:00:03")))

    $m = New-OxyPlotModel -DefaultFontSize "-01:02:03"
    $m.DefaultFontSize | Should -Be ([OxyPlot.Axes.TimeSpanAxis]::ToDouble([TimeSpan]::Parse("-01:02:03")))
  }

}

Describe "OxyColor parameter" {

  It "accepts a color name" {
    $s = New-OxyLineSeries -Color white
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#ffffff"))

    $s = New-OxyLineSeries -Color transparent
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#00ffffff"))

    $s = New-OxyLineSeries -Color RED
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#ff0000"))
  }

  It "accepts in a hexadecimal style" {
    $s = New-OxyLineSeries -Color "#8090a0"
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#8090a0"))

    $s = New-OxyLineSeries -Color 8090a0
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#8090a0"))
  }

  It "raises an error for invalid parameter" {
    { $s = New-OxyLineSeries -Color xxxx } | Should -Throw "xxxx"
  }

}

Describe "OxyPalette parameter" {

  It "accepts a type" {
    $a = New-OxyLinearColorAxis -Palette hue
    $a.Palette | Should -BeOfType [OxyPlot.OxyPalette]
    $a.Palette.Colors.Count | Should -Be 100
  }

  It "accepts a type and the number of colors" {
    $a = New-OxyLinearColorAxis -Palette "hot", 500
    $a.Palette | Should -BeOfType [OxyPlot.OxyPalette]
    $a.Palette.Colors.Count | Should -Be 500
  }

}

Describe "OxyThickness parameter" {

  It "accepts one value of thickness" {
    $p = New-OxyPlotModel -PlotMargins 0.1
    $p.PlotMargins | Should -BeOfType [OxyPlot.OxyThickness]
    $p.PlotMargins | Should -Be (New-Object OxyPlot.OxyThickness 0.1)
  }

  It "accepts two values of thickness" {
    $p = New-OxyPlotModel -PlotMargins 0.1, 0.2
    $p.PlotMargins | Should -BeOfType [OxyPlot.OxyThickness]
    $p.PlotMargins | Should -Be (New-Object OxyPlot.OxyThickness 0.1, 0.2, 0.1, 0.2)
  }

  It "doesn't accept three values of thickness" {
    { New-OxyPlotModel -PlotMargins 0.1, 0.2, 0.3 } | Should -Throw "Illegal thickness"
  }

  It "accepts four values of thickness" {
    $p = New-OxyPlotModel -PlotMargins 0.1, 0.2, 0.3, 0.4
    $p.PlotMargins | Should -BeOfType [OxyPlot.OxyThickness]
    $p.PlotMargins | Should -Be (New-Object OxyPlot.OxyThickness 0.1, 0.2, 0.3, 0.4)
  }

}

Describe "Data[,] parameter" {

  It "can accept a two-dimension array as data points" {
    $data = New-Object "double[,]" 1, 2
    $data[0, 0] = 0.0
    $data[0, 1] = 0.1
    $s = New-OxyHeatMapSeries -Data $data
    $s.Data | Should -Be $data
  }

  It "can accept a jagged array as data points" {
    $data = @(1, 2), @(3, 4), @(5, 6)
    $s = New-OxyHeatMapSeries -Data $data
    $s.Data.Rank | Should -Be 2
    $s.Data.GetLength(0) | Should -Be 2
    $s.Data.GetLength(1) | Should -Be 3
    $s.Data[0,0] | Should -Be 1
    $s.Data[1,1] | Should -Be 4
    $s.Data[1,2] | Should -Be 6
  }
}

Describe "OxyColor collection parameter" {

  It "can accept an array of color name strings" {
    $m = New-OxyPlotModel -DefaultColors @("red", "blue")
    $m.DefaultColors.Count | Should -Be 2
    $m.DefaultColors[0] | Should -Be ([OxyPlot.OxyColors]::Red)
  }

}
