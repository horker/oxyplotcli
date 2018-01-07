Set-StrictMode -Version 3

$data = (
  [pscustomobject]@{ A = 1.5; B = -3 },
  [pscustomobject]@{ A = 2;   B = -2 },
  [pscustomobject]@{ A = 3;   B = -1.5 }
)

$dataA = 1.5, 2, 3
$dataB = -3, -2, -1.5
$dataSize = 10, 20, 30
$dataLabel = "foo", "bar", "baz"

Describe "New-OxyLineSeries" {

  BeforeEach {
    $s = $data | New-OxyLineSeries -XName A -YName B
  }

  it "takes a series of points through pipeline" {
    $s | Should -BeOfType [OxyPlot.Series.LineSeries]
    $s.Points.Count | Should -Be 3
    $s.Points[0].X | Should -Be 1.5
    $s.Points[2].Y | Should -Be -1.5
  }

  it "takes a series of points by parameters" {
    $s2 = New-OxyLineSeries -X $dataA -Y $dataB
    $s2.Points | Should -Be $s.Points
  }

  it "takes a series of points by parameters (-Data)" {
    $s2 = New-OxyLineSeries -XName A -YName B -Data $data
    $s2.Points | Should -Be $s.Points
  }

  it "accepts object properties as parameters" {
    $s2 = New-OxyLineSeries -X $dataA -Y $dataB -Smooth $true -LineStyle dash
    $s2.Smooth | Should -Be $true
    $s2.LineStyle | Should -Be "dash"
  }
}

Describe "OxyColor parameter" {

  it "accepts a color name" {
    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color white
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#ffffff"))

    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color transparent
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#00000000"))

    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color red
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#ff0000"))
  }

  it "accepts in a hexadecimal style" {
    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color "#8090a0"
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#8090a0"))

    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color 8090a0
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#8090a0"))
  }

  it "raises an error for invalid parameter" {
    { $s = New-OxyLineSeries -X $dataA -Y $dataB -Color xxxx } | Should -Throw "Cannot validate"
  }
}

Describe "Other series creation cmdlets" {
  it "accepts a series of points" {
    $s = New-OxyTwoColorLineSeries -X $dataA -Y $dataB
    $s | Should -BeOfType [OxyPlot.Series.TwoColorLineSeries]
    $s.Points[0].X | Should -Be 1.5

    $s = New-OxyScatterSeries -X $dataA -Y $dataB -Size $dataSize -Value $dataSize
    $s | Should -BeOfType [OxyPlot.Series.ScatterSeries]
    $s.Points[0].X | Should -Be 1.5

    $s = New-OxyScatterErrorSeries -X $dataA -Y $dataB -ErrorX $dataB -ErrorY $dataA -Size $dataSize -Value $dataSize
    $s | Should -BeOfType [OxyPlot.Series.ScatterErrorSeries]
    $s.Points[0].X | Should -Be 1.5

    $s = New-OxyCandleStickSeries -High $dataA -Low $dataA -Open $dataA -Close $dataA
    $s | Should -BeOfType [OxyPlot.Series.CandleStickSeries]
    $s.Items[0].High | Should -Be 1.5

    $s = New-OxyPieSeries -Label $dataLabel -Value $dataA
    $s | Should -BeOfType [OxyPlot.Series.PieSeries]
    $s.Slices[0].Value | Should -Be 1.5
  }
}
