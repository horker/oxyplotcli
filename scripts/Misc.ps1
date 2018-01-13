Set-StrictMode -Version 3

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

  if ($ColorName -match "^(\w+)-(\d+)$") {
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
