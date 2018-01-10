Set-StrictMode -Version 3

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
