Set-StrictMode -Version 3

Import-Module $PSScriptRoot\..\OxyPlotCli -Force

Describe "axis creation cmdlets" {

  It "can create an AngleAxis object" {
    $a = New-OxyAngleAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.AngleAxis]
    $a.Position | Should -Be "Top"
  }

  It "can create a CategoryAxis Object" {
    $a = New-OxyCategoryAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.CategoryAxis]
    $a.Position | Should -Be "Top"
  }

  It "can create a DateTimeAxis object" {
    $a = New-OxyDateTimeAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.DateTimeAxis]
    $a.Position | Should -Be "Top"
  }

  It "can create a LinearAxis object" {
    $a = New-OxyLinearAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.LinearAxis]
    $a.Position | Should -Be "Top"
  }

  It "can create a LinearColorAxis object" {
    $a = New-OxyLinearColorAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.LinearColorAxis]
    $a.Position | Should -Be "Top"
  }

  It "can create a LogarithmicAxis object" {
    $a = New-OxyLogarithmicAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.LogarithmicAxis]]
    $a.Position | Should -Be "Top"
  }

  It "can create a MagnitudeAxis object" {
    $a = New-OxyMagnitudeAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.MagnitudeAxis]]
    $a.Position | Should -Be "Top"
  }

  It "can create a RangeColorAxis" {
    $a = New-OxyRangeColorAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.RangeColorAxis]
    $a.Position | Should -Be "Top"
  }

  It "can create a TimeSpanAxis" {
    $a = New-OxyTimeSpanAxis -Position top
    $a | Should -BeOfType [OxyPlot.Axes.TimeSpanAxis]
    $a.Position | Should -Be "Top"
  }
}
