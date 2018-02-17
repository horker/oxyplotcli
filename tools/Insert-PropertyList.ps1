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
      switch -regex ($class) {
        "^OxyPlot\.OxyColor$" {
          $results.Add("$indent$colorValidateAttribute[string]`$$Prefix$name,")
        }
        "^OxyPlot\.OxyThickness$" {
          $results.Add("$indent[double[]]`$$Prefix$name,")
        }
        "^OxyPlot\.ElementCollection\[" {
          $m = ([regex]"^OxyPlot\.ElementCollection\[(.+)\]$").Match($class)
          $results.Add("$indent[$($m.Groups[1].Value)[]]`$$Prefix$name,")
        }
        default {
          $results.Add("$indent[$class]`$$Prefix$name,")
        }
      }
    }
    "assign" {
      switch -regex ($class) {
        "^OxyPlot\.OxyColor$" {
          $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$Prefix$name')) { `$$VariableName.$name = New-OxyColor `$$Prefix$name }")
        }
        "^OxyPlot\.OxyThickness$" {
          $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$Prefix$name')) { `$$VariableName.$name = New-OxyThickness `$$Prefix$name }")
        }
        "^OxyPlot\.ElementCollection\[" {
          $m = ([regex]"^OxyPlot\.ElementCollection\[.+\.(.+)\]$").Match($class)
          $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$Prefix$name')) { Add-ToCollection `$$VariableName.$($m.Groups[1].Value) `$$Prefix$name }")
        }
        default{
          $results.Add("$($indent)if (`$PSBoundParameters.ContainsKey('$Prefix$name')) { `$$VariableName.$name = `$$Prefix$name }")
        }
      }
    }
  }
}

$results | foreach { $_ + "`r`n" }
