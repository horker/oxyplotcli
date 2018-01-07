
$data = (
  [pscustomobject]@{ A = 1.5; B = -3 },
  [pscustomobject]@{ A = 2;   B = -2 },
  [pscustomobject]@{ A = 3;   B = -1.5 }
)

$dataA = 1.5, 2, 3
$dataB = -3, -2, -1.5

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
}
