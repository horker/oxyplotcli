[cmdletbinding()]
param(
  [string]$OutputType,
  [string]$ClassName,
  [string]$VariableName,
  [string]$OptionHashName,
  [int]$IndentWidth
)

Set-StrictMode -version 3

. $PSScriptRoot\..\scripts\Misc.ps1

$colorNames = Get-OxyColorList

$colorValidateAttribute = "[ValidatePattern('$($colorNames -join "|")|(#?[0-9a-f]{1,8})')]"

$obj = New-Object $ClassName

$indent = " " * $IndentWidth

$props =
  $obj |
  get-member |
  where { $_.MemberType -match "Property" -and $_.Definition -match "set;" }

$results = New-Object Collections.Generic.List[string]

foreach ($p in $props) {
  [void]($p.Definition -match "^([^\s]+)\s+([^\s]+)")
  $class = $matches[1]
  $name = $p.Name

  switch ($OutputType) {
    "param" {
      if ($class -eq "OxyPlot.OxyColor") {
        $results.Add("$indent$colorValidateAttribute[string]`$$name,")
      }
      elseif ($class -eq "OxyPlot.OxyThickness") {
        $results.Add("$indent[double[]]`$$name,")
      }
      else {
        $results.Add("$indent[$class]`$$name,")
      }
    }
    "assign" {
      if ($class -eq "OxyPlot.OxyColor") {
        $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$name')) { `$$VariableName.$name = New-OxyColor `$$name }")
      }
      elseif ($class -eq "OxyPlot.OxyThickness") {
        $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$name')) { `$$VariableName.$name = New-OxyThickness `$$name }")
      }
      else {
        $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$name')) { `$$VariableName.$name = `$$name }")
      }
    }
  }
}

if ($OutputType -eq "assign") {
  $results.Add("$($indent)foreach (`$key in `$$OptionHashName.Keys) {")
  $results.Add("$($indent)  `$$VariableName.`$key = `$$OptionHashName[`$key]")
  $results.Add("$($indent)}")
}

$results | foreach { $_ + "`r`n" }
