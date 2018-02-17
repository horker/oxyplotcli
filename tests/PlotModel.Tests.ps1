Set-StrictMode -Version 3

Import-Module $PSScriptRoot\..\OxyPlotCli -Force

Describe "New-OxyPlotModel" {

  It "can accept an array of Series objects" {
    $s1 = New-OxyLineSeries -X 1,2,3 -Y 4,5,6
    $s2 = New-OxyLineSeries -X 1,2,3 -Y 4,5,6
    $m = New-OxyPlotModel -Series $s1, $s2
    $m.Series.Count | Should -Be 2
    $m.Series[0] | Should -Be $s1
  }

  It "can create axis objects through -Ax/-Ay style options" {
    $m = New-OxyPlotModel -AxType log -AxMinimum -10
    $m.Axes.Count | Should -Be 1
    $m.Axes[0] | Should -BeOfType [OxyPlot.Axes.LogarithmicAxis]
    $m.Axes[0].Minimum | Should -Be -10
  }

}
