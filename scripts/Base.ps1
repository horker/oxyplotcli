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
