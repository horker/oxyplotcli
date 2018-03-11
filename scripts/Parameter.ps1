Set-StrictMode -Version 3

$TypeMapping = @{
  "System.Double" = "object"
  "double" = "object"
  "OxyPlot.OxyColor" = "string"
  "OxyPlot.OxyPalette" = "object[]"
  "OxyPlot.OxyThickness" = "double[]"
  "System.Double[,]" = "double[]"
  "double[,]" = "double[]"
  "System.Boolean" = "object"
  "bool" = "object"
}

function Get-GeneralTypeName {
  param(
    [string]$TargetTypeName
  )

  $newTypeName = $TypeMapping[$TargetTypeName]
  if ($null -eq $newTypeName) {
    return $TargetTypeName
  }
  $newTypeName
}

function Convert-Unit {
  param(
    [double]$Value,
    [string]$Unit
  )

  switch ($Unit) {
    "px" { $result = $Value }
    "in" { $result = $Value * 96.0 }
    "cm" { $result = $Value * (96.0 / 2.54) }
    "pt" { $result = $Value * (96.0 / 72) }
    default {
      Write-Error "Unknown unit: '$Unit'"
      return
    }
  }

  $result
}

function Convert-ParameterValue {
  param(
    [string]$TargetTypeName,
    [object]$Value
  )

  switch ($TargetTypeName) {
    { $_ -eq "System.Double" -or $_ -eq "double" } {
      if ($null -eq $Value) {
        $Value = [double]::NaN
        break
      }
      switch ($Value.GetType().FullName) {
        "System.String" {
          try {
            # Try to parse as [Double] (with an optional unit)
            $unit = $null
            if ($Value -match "^(.+)(px|in|cm|pt)\s*$") {
              $Value = $matches[1]
              $unit = $matches[2]
            }

            $Value = [Double]::Parse($Value, "Any")

            if ($unit -ne $null) {
              $Value = Convert-Unit $Value $unit
            }
          }
          catch [FormatException] {
            try {
              # Try to parse as [DateTime]
              $Value = [OxyPlot.Axes.DateTimeAxis]::ToDouble([DateTime]::Parse($Value))
            }
            catch [FormatException] {
              # Try to parse as [TimeSpan]

              # Remove a leading plus
              # You can place a plus to force the value to be interpreted as a TimeSpan.
              $Value = $Value -replace "^\s*\+", ""

              $Value = [OxyPlot.Axes.TimeSpanAxis]::ToDouble([TimeSpan]::Parse($Value))
            }
          }
        }

        "System.DateTime" {
          $Value = [OxyPlot.Axes.DateTimeAxis].ToDouble($Value)
        }

        "System.TimeSpan" {
          $Value = [OxyPlot.Axes.TimeSpanAxis].ToDouble($Value)
        }

        defalut {
          $value = [double]$Value
        }
      }
    }

    "OxyPlot.OxyColor" {
      $Value = New-OxyColor $Value
    }

    "OxyPlot.OxyPalette" {
      $Value = New-OxyPalette @Value
    }

    "OxyPlot.OxyThickness" {
      $Value = New-OxyThickness $Value
    }

    { $_ -eq "System.Double[,]" -or $_ -eq "double[,]" } {
      $Value = New-OxyTwoDimensionArray $Value
    }

    { $_ -eq "System.Boolean" -or $_ -eq "bool" } {
      if ($value -is [string]) {
        if ($value -eq "true" -or $value -eq "t" -or $value -eq "1") {
          $Value = $true
        }
        if ($value -eq "false" -or $value -eq "f" -or $value -eq "0") {
          $Value = $false
        }
      }
      $Value = [bool]$value
    }

  }

  ,$Value
}

function Get-ValueType {
  param(
    [object]$Value
  )

  if ($Value -is [string]) {
    try {
      if ($Value -match "^(.+)(px|in|cm|pt)\s*$") {
        $Value = $matches[1]
      }
      $null = [Double]::Parse($Value, "Any")
      return "System.Double"
    }
    catch [FormatException] {
      try {
        $null = [DateTime]::Parse($Value)
        return "System.DateTime"
      }
      catch [FormatException] {
        try {
          $Value = $Value -replace "^\s*\+", ""
          $null = [TimeSpan]::Parse($Value)
          return "System.TimeSpan"
        }
        catch [FormatException] {
        }
      }
    }
  }
  return $Value.GetType().FullName
}

function Assign-Parameter {
  param(
    [Reflection.PropertyInfo]$Prop,
    [object]$Object,
    [object]$Value
  )

  $targetTypeName = $Prop.PropertyType.FullName
  $name = $Prop.Name

  $collections = @(
    "System.Collections.Generic.IList"
    "OxyPlot.ElementCollection"
  )

  foreach($c in $collections) {
    if ($TargetTypeName.StartsWith($c)) {
      $elementType = $Prop.PropertyType.GenericTypeArguments[0]
      $coll = $Object.$name
      if ($null -eq $coll) {
        $coll = New-Object "$c[$($elementType.FullName)]"
        $Object.$name = $coll
      }
      else {
        $coll.Clear()
      }
      foreach ($e in $Value) {
        [void]$coll.Add((Convert-ParameterValue $elementType.FullName $e))
      }
      return
    }
  }

  $v = Convert-ParameterValue $targetTypeName $Value
  $Object.$name = $v
}

function Assign-ParametersToProperties {
  param(
    [hashtable]$Props,
    [Collections.Generic.IDictionary[string,object]]$BoundParameters,
    [hashtable]$Options,
    [object]$Object,
    [string]$Prefix = ""
  )

  foreach ($p in $BoundParameters.Keys) {
    if (!$p.StartsWith($Prefix)) {
      continue
    }
    $q = $p -replace "^$Prefix", ""

    if ($Props.ContainsKey($q)) {
      Assign-Parameter $Props[$q] $Object $BoundParameters[$p]
    }
  }

  foreach ($p in $Options.Keys) {
    if (!$p.StartsWith($Prefix)) {
      continue
    }
    $q = $p -replace "^$Prefix", ""

    if ($Props.ContainsKey($q)) {
      Assign-Parameter $Props[$q] $Object $Options[$p]
    }
  }
}
