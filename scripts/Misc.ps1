Set-StrictMode -Version 3

############################################################
# Show-OxyPlot helpers

function Get-AxisObject {
  param(
    [Reflection.TypeInfo]$DataType
  )

  if ($DataType -eq [DateTime]) {
    $type = "OxyPlot.Axes.DateTimeAxis"
  }
  elseif ($DataType -is [TimeSpan]) {
    $type = "OxyPlot.Axes.TimeSpanAxis"
  }
  else {
    $type = "OxyPlot.Axes.LinearAxis"
  }

  New-Object $type
}

$script:ResultsOfAreAxesRequired = @{}

[OxyPlot.Series.Series].Assembly.GetTypes() |
  where { $_.Name -Match "Series$" -And !$_.IsAbstract } |
  foreach {
    $m = [OxyPlot.Series.Series].GetMethod(
      "AreAxesRequired",
      [Reflection.BindingFlags]::InvokeMethod -bor [Reflection.BindingFlags]::Instance -bor [Reflection.BindingFlags]::NonPublic)
  },
  {
    $name = $_.FullName
    $ResultsOfAreAxesRequired[$name] = $m.Invoke((new-Object $name), $null)
  }

function Test-AxesRequired {
  param(
    [OxyPlot.Series.Series]$series
  )

  $ResultsOfAreAxesRequired[$series.GetType().FullName]
}

$script:AxisTypes = [OxyPlot.Axes.Axis].Assembly.GetTypes() |
  where { $_.Name -Match "Axis$" -And !$_.IsAbstract } |
  foreach { $_.FullName } |
  Sort

function Get-AxisByPartialTypeName {
  param(
    [string]$PartialName
  )

  foreach ($t in $AxisTypes) {
    if ($t -Match [regex]::Escape($PartialName)) {
      return New-Object $t
    }
  }

  $null
}

function Get-RequiredCategoryAxis {
  param(
    [OxyPlot.Series.Series]$Series
  )

  if ($Series -is [OxyPlot.Series.ColumnSeries] -or
      $Series -is [OxyPlot.Series.ErrorColumnSeries]) {
    return "x"
  }

  if ($Series -is [OxyPlot.Series.BarSeries] -or
      $Series -is [OxyPlot.Series.IntervalBarSeries] -or
      $Series -is [OxyPlot.Series.LinearBarSeries] -or
      $Series -is [OxyPlot.Series.TornadoBarSeries]) {
    return "y"
  }

  return $null
}


############################################################
# PlotModel cmdlets

function Get-OxyPlotModel {
  [cmdletbinding(DefaultParameterSetName="Index")]
  param(
    [Parameter(ParameterSetName="Index")]
    [int]$Index = -1,
    [Parameter(ParameterSetName="Window")]
    [Windows.Window]$Window
  )

  if ($PSCmdlet.ParameterSetName -eq "Index") {
    $Window = Get-OxyWindow $Index
  }

  Invoke-WpfWindowAction $Window {
    foreach ($view in $Window.Content.Children) {
      if ($view -is [OxyPlot.Wpf.PlotView]) {
        $view.Model
      }
    }
  }
}

function Update-OxyPlotModel {
  [cmdletbinding()]
  param(
    [OxyPlot.PlotModel]$PlotModel,
    [switch]$UpdateData = $false
  )
  $PlotModel.InvalidatePlot($UpdateData)
}

############################################################
# Sequence generator

function New-OxySequence {
  [cmdletbinding()]
  param(
    [double]$Begin,
    [double]$End,
    [double]$Step,
    [switch]$Exclusive = $false
  )

  if ($Exclusive) {
    for ($i = $Begin; $i -lt $End; $i += $Step) {
      $i
    }
  }
  else {
    for ($i = $Begin; $i -le $End; $i += $Step) {
      $i
    }
  }
}

############################################################
# OxyColor

$script:colorNames = ([OxyPlot.OxyColors] | Get-Member -Static -MemberType Property).Name

$script:colorHash = @{}
foreach ($n in $script:colorNames) {
  $script:colorHash[$n.ToLower()] = [OxyPlot.OxyColors]::"$n"
}

function Get-OxyColorList {
  [cmdletbinding()]
  param()
  $script:colorNames
}

function New-OxyColor {
  [cmdletbinding()]
  param(
    [string]$ColorName,
    [double]$Alpha = -1
  )

  if ($ColorName -eq "") {
    $ColorName = "Automatic"
  }
  elseif ($ColorName -match "^(\w+)-(\d+)$") {
    $ColorName = $matches[1]
    $Alpha = $matches[2] / 100.0
  }

  $code = $script:colorHash[$ColorName.ToLower()]
  if ($code) {
    $ColorName = $code
  }
  elseif ($ColorName -notmatch "^#") {
    $ColorName = "#" + $ColorName
  }

  $color = [OxyPlot.OxyColor]::Parse($ColorName)

  if ($Alpha -ne -1) {
    $color = [OxyPlot.OxyColor]::FromAColor([byte](255.0 * $Alpha), $color)
  }

  $color
}

############################################################
# OxyThickness

function New-OxyThickness {
  [cmdletbinding()]
  param(
    [double[]]$Thickness
  )

  switch ($Thickness.Length) {
    1 {
      New-Object OxyPlot.OxyThickness $Thickness[0]
    }
    2 {
      New-Object OxyPlot.OxyThickness $Thickness[0], $Thickness[1], $Thickness[0], $Thickness[1]
    }
    4 {
      New-Object OxyPlot.OxyThickness $Thickness[0], $Thickness[1], $Thickness[2], $Thickness[3]
    }
    default {
      Write-Error "Illegal thickness"
      return
    }
  }
}

############################################################
# Adding elements to a collection

function Add-ToCollection {
  param(
    [object]$Collection,
    [object[]]$Elements
  )

  foreach ($e in $Elements) {
    $Collection.Add($e)
  }
}

############################################################
# Two-dimension array

function New-OxyTwoDimensionArray {
  param(
    [object]$Data
  )

  if ($Data -is [double[,]]) {
    return ,$Data
  }

  if ($Data -isnot [object[]] -or $Data[0] -isnot [object[]]) {
    Write-Error "Not two-dimension array nor jagged array"
    return
  }

  $length1 = $Data[0].Length
  $length2 = $Data.Length

  $result = New-Object "double[,]" $length1, $length2

  for ($i = 0; $i -lt $length2; ++$i) {
    $row = [double[]]$Data[$i]
    if ($row -isnot [double[]]) {
      Write-Error "Not two-dimension array nor jagged array"
      return
    }
    for ($j = 0; $j -lt $row.Length; ++$j) {
      $result[$j, $i] = $row[$j]
    }
  }

  ,$result
}

############################################################
# OxyPlatte

function New-OxyPalette {
  [cmdletbinding(DefaultParameterSetName="Predefined")]
  param(
    [Parameter(Position=0, Mandatory=$true, ParameterSetName="Predefined")]
    [ValidateSet("BlackWhiteRed", "BlueWhiteRed", "Cool", "Gray", "Hot", "Hue", "HueDistinct", "Jet", "Rainbow")]
    [string]$Type,

    [Parameter(Position=1, Mandatory=$false, ParameterSetName="Predefined")]
    [int]$NumberOfColors = 100,

    [Parameter(Position=0, ParameterSetName="ColorSet")]
    [string[]]$Colors
  )

  if ($PSCmdlet.ParameterSetName -eq "Predefined") {
    [OxyPlot.OxyPalettes]::$Type($NumberOfColors)
  }
  else {
    $colors = $Colors | foreach { New-OxyColor $_ }
    New-Object OxyPlot.OxyPalette $colors
  }
}
