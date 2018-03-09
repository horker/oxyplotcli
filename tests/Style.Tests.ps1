Set-StrictMode -Version 3

Describe "Add-OxyStyle" {

  It "can add a style" {
    Add-OxyStyle TestStyle @{
      "LineSeries.FontSize" = 10
    }

    $style = Get-OxyStyle TestStyle
    $style.Count | Should -Be 1
    $style["OxyPlot.Series.LineSeries"] | Should -BeOfType [hashtable]
    $style["OxyPlot.Series.LineSeries"].Count | Should -Be 1
    $style["OxyPlot.Series.LineSeries"]["FontSize"] | Should -Be 10.0
  }

  It "can use wildcards" {
    Add-OxyStyle TestStyle @{
      "*ColumnSeries.FontSize" = 10
    }

    $style = Get-OxyStyle TestStyle
    $style.Count | Should -Be 2
    $style["OxyPlot.Series.ColumnSeries"] | Should -BeOfType [hashtable]
    $style["OxyPlot.Series.ErrorColumnSeries"] | Should -BeOfType [hashtable]

    $style["OxyPlot.Series.ColumnSeries"].Count | Should -Be 1
    $style["OxyPlot.Series.ErrorColumnSeries"]["FontSize"] | Should -Be 10.0
  }

  It "can specify units" {
    Add-OxyStyle TestStyle @{
      "ColumnSeries.FontSize" = "10.0in"
    }

    $style = Get-OxyStyle TestStyle
    $style["OxyPlot.Series.ColumnSeries"]["FontSize"] | Should -Be (10 * 96)
  }

  It "can specify default units" {
    Add-OxyStyle TestStyle @{
      "[Unit]" = "pt"
      "ColumnSeries.FontSize" = 10
    }

    $style = Get-OxyStyle TestStyle
    $dif = [math]::Abs($style["OxyPlot.Series.ColumnSeries"]["FontSize"] - 10.0 * 96 / 72)
    $dif | Should -BeLessThan 1e-10
  }

}

Describe "Apply-OxyStyle" {

  It "can apply a style to a series object" {
    Add-OxyStyle TestStyle @{
      "ColumnSeries.FontSize" = 100.0
    }

    $s1 = New-OxyColumnSeries -Style TestStyle
    $s1.FontSize | Should -Be 100.0

    $s2 = New-OxyColumnSeries
    $s2.FontSize | Should -Not -Be 100.0

    $s3 = New-OxyBarSeries -Style TestStyle
    $s3.FontSize | Should -Not -Be 100.0
  }

  It "can apply a style to an axis object" {
    Add-OxyStyle TestStyle @{
      "LinearAxis.Minimum" = -10
    }

    $a1 = New-OxyLinearAxis -Style TestStyle
    $a1.Minimum | Should -Be -10

    $a2 = New-OxyLinearAxis
    $a2.Minimum | Should -Not -Be -10
  }

  It "will be overwritten by explicit parameters" {
    Add-OxyStyle TestStyle @{
      "ColumnSeries.FontSize" = 100.0
    }

    $s = New-OxyColumnSeries -Style TestStyle -FontSize 20
    $s.FontSize | Should -Be 20
  }

}

Describe "Local style" {

  It "will be applied every time" {
    $local = $null
    if ((Test-OxyStyleName local)) {
      $local = Get-OxyStyle local
    }

    Add-OxyStyle local @{
      "PlotModel.DefaultFont" = "Times New Roman"
    }

    $m = New-OxyPlotModel -Style empty
    $m.DefaultFont | Should -Be "Times New Roman"

    if ($null -ne $local) {
      Set-OxyStyle local $local
    }
    else {
      Remove-OxyStyle local
    }
  }

}
