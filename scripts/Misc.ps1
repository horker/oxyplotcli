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
    [string]$ColorName
  )

  $code = $script:colorHash[$ColorName.ToLower()]
  if ($code) {
    $ColorName = $code
  }
  elseif ($ColorName -notmatch "^#") {
    $ColorName = "#" + $ColorName
  }

  [OxyPlot.OxyColor]::Parse($ColorName)
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
