[cmdletbinding()]
param(
  [string]$OutputType,
  [string]$ClassName,
  [string]$VariableName,
  [string]$OptionHashName,
  [int]$IndentWidth,
  [string]$Prefix = ""
)

Set-StrictMode -version 3

. $PSScriptRoot\..\scripts\Misc.ps1

$colorNames = Get-OxyColorList

$colorValidateAttribute = "[ValidatePattern('$($colorNames -join "|")|(#?[0-9a-f]{1,8})')]"

$indent = " " * $IndentWidth
$results = New-Object Collections.Generic.List[string]

############################################################

if ($OutputType -eq "assign") {
  $results.Add("$($indent)foreach (`$key in `$$OptionHashName.Keys) {")
  $results.Add("$($indent)  `$$VariableName.`$key = `$$OptionHashName[`$key]")
  $results.Add("$($indent)}")
}

############################################################

$props = (Invoke-Expression "[$ClassName]").Assembly.GetType($ClassName).GetProperties() | where { $_.CanWrite }

foreach ($p in $props) {
  $name = $p.Name
  $class = [string]$p.PropertyType

  switch ($OutputType) {
    "param" {
      if ($class -eq "OxyPlot.OxyColor") {
        $results.Add("$indent$colorValidateAttribute[string]`$$Prefix$name,")
      }
      elseif ($class -eq "OxyPlot.OxyThickness") {
        $results.Add("$indent[double[]]`$$Prefix$name,")
      }
      else {
        $results.Add("$indent[$class]`$$Prefix$name,")
      }
    }
    "assign" {
      if ($class -eq "OxyPlot.OxyColor") {
        $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$Prefix$name')) { `$$VariableName.$name = New-OxyColor `$$Prefix$name }")
      }
      elseif ($class -eq "OxyPlot.OxyThickness") {
        $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$Prefix$name')) { `$$VariableName.$name = New-OxyThickness `$$Prefix$name }")
      }
      else {
        $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$Prefix$name')) { `$$VariableName.$name = `$$Prefix$name }")
      }
    }
  }
}

$results | foreach { $_ + "`r`n" }
