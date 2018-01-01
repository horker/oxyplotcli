Set-StrictMode -version 3

############################################################
# Helper cmdlet to generate sequences

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
# OxyPlot.DataPoint

function Convert-PlotValue {
  param(
    [object]$Value
  )
  if ($value -is [DateTime]) {
    $value = [OxyPlot.Axes.DateTimeAxis]::ToDouble($value)
  }
  elseif ($value -is [TimeSpan]) {
    $value = [OxyPlot.Axes.TimeSpanAxis]::ToDouble($value)
  }
  [double]$value
}

function New-OxyDataPoint {
  [cmdletbinding()]
  param(
    [object]$X,
    [object]$Y
  )

  New-Object OxyPlot.DataPoint (Convert-PlotValue $X), (Convert-PlotValue $Y)
}

function New-OxyDataPointList {
  [cmdletbinding()]
  param(
    [object[]]$X,
    [object[]]$Y
  )

  $result = New-Object Collections.Generic.List[OxyPlot.DataPoint]

  if ($null -eq $X -or $null -eq $Y) {
    ,$result
    return
  }

  if ($X.Count -ne $Y.Count) {
    Write-Error "Data lengths should be equal"
    return
  }

  $count = $X.Count
  for ([int]$i = 0; $i -lt $count; ++$i) {
    $xi = Convert-PlotValue $X[$i]
    $yi = Convert-PlotValue $Y[$i]
    $p = New-Object OxyPlot.DataPoint $xi, $yi
    $result.Add($p)
  }

  ,$result
}

function Get-DataPointFromXYData {
  param(
    $Param,
    [string]$XName,
    [string]$YName,
    [string]$DataName
  )

  if ($Param.ContainsKey($DataName)) {
    $x = $Param[$XName]
    $xFieldName = $x[0]
    $y = $Param[$YName]
    $yFiledName = $y[0]
    if ($xFieldName -isnot [string] -or $x.Length -ne 1 -or $yFieldName -isnot [string] -or $y.Length -ne 1) {
      Write-Error "When '$DataName' is specified '$XName' and '$YName' should be strings"
      return
    }

    $data = $Param[$DataName]
    $x = $data | foreach { $_.$xFieldName }
    $y = $data | foreach { $_.$yFieldName }
  }
  else {
    $x = $Param[$XName]
    $y = $Param[$YName]
  }

  New-OxyDataPointList $x $y
}

############################################################

function Get-BarItemFromValueData {
  param(
    $Param,
    [string]$ValueName,
    [string]$DataName,
    [string]$ClassName
  )

  if ($Param.ContainsKey($DataName)) {
    $value = $Param[$ValueName]
    $valueFieldName = $value[0]
    if ($valueFieldName -isnot [string] -or $value.Length -ne 1) {
      Write-Error "When '$DataName' is specified '$ValueName' should be a string"
      return
    }

    $data = $Param[$DataName]
    $values = $data | foreach { $_.$valueFieldName }
  }
  else {
    $values = $Param[$ValueName]
  }

  $result = New-Object Collections.Generic.List[$ClassName]
  $count = $values.Count
  for ([int]$i = 0; $i -lt $count; ++$i) {
    $v = Convert-PlotValue $values[$i]
    $p = New-Object $ClassName $v, $i
    $result.Add($p)
  }

  ,$result
}

function Get-LabelFromLabelData {
  param(
    $Param,
    [string]$LabelName,
    [string]$DataName
  )

  if ($Param.ContainsKey($DataName)) {
    $labels = $Param[$LabelName]
    $fieldName = $labels[0]
    if ($fieldName -isnot [string] -or $labels.Length -ne 1) {
      Write-Error "When '$DataName' is specified '$LabelName' should be a string"
      return
    }

    $data = $Param[$DataName]
    $labels = $data | foreach { $_.$fieldName }
  }
  else {
    $labels = $Param[$LabelName]
  }

  $result = New-Object Collections.Generic.List[string]
  foreach ($l in $labels) {
    $result.Add($l)
  }

  ,$result
}

############################################################
# OxyPlot.OxyColor helper

$script:colors = Import-Csv (Join-Path $PSScriptRoot "colors.tsv") -Delimiter "`t"
$script:colorHash = @{}
$colors | foreach { $script:colorHash[$_.Name] = $_.Code }

function Get-OxyColorList {
  [cmdletbinding()]
  param()
  $script:colors
}

function New-OxyColor {
  [cmdletbinding()]
  param(
    [string]$ColorName
  )

  $code = $script:colorHash[$ColorName]
  if ($code) {
    $ColorName = $code
  }
  elseif ($ColorName -notmatch "^#") {
    $ColorName = "#" + $ColorName
  }

  [OxyPlot.OxyColor]::Parse($ColorName)
}
