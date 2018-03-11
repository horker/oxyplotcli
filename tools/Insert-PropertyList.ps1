[cmdletbinding()]
param(
  [string]$OutputType,
  [string]$ClassName,
  [Reflection.PropertyInfo[]]$Properties,
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

if ($ClassName -ne "") {
  $Properties = (Invoke-Expression "[$ClassName]").Assembly.GetType($ClassName).GetProperties() | where { $_.CanWrite }
}

foreach ($p in $Properties) {
  $name = $p.Name
  $class = $p.PropertyType

  switch -wildcard ($class.FullName) {
    "System.Double" {
      $results.Add("$indent[object]`$$Prefix$name,")
    }
    "OxyPlot.OxyColor" {
      $results.Add("$indent$colorValidateAttribute[string]`$$Prefix$name,")
    }
    "OxyPlot.OxyPalette" {
      $results.Add("$indent[object[]]`$$Prefix$name,")
    }
    "OxyPlot.OxyThickness" {
      $results.Add("$indent[double[]]`$$Prefix$name,")
    }
    "System.Double``[,``]" {
      $results.Add("$indent[object]`$$Prefix$name,")
    }
    "System.Collections.Generic.IList*" {
      $elementType = Get-GeneralTypeName $class.GenericTypeArguments[0].FullName
      $results.Add("$indent[$($elementType)[]]`$$Prefix$name,")
    }
    "OxyPlot.ElementCollection*" {
      $elementType = Get-GeneralTypeName $class.GenericTypeArguments[0].FullName
      $results.Add("$indent[$($elementType)[]]`$$Prefix$name,")
    }
    default {
      $results.Add("$indent[$($class.FullName)]`$$Prefix$name,")
    }
  }
}

$results | foreach { $_ + "`r`n" }
