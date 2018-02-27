Set-StrictMode -Version 3

$script:TYPES = [OxyPlot.PlotModel].Assembly.DefinedTypes |
  where { $_.IsPublic -and !$_.IsAbstract -and $_.FullName -match "(PlotModel|Series|Axis|Annotation)$" } |
  sort FullName

$script:TYPE_HASH = @{}
foreach ($t in $TYPES) {
  $TYPE_HASH[$t.FullName -replace "^OxyPlot\.((Series|Axes|Annotations)\.)?", ""] = $t
}

$script:Styles = @{}

function Get-LogicalPoint {
  param(
    [string]$Value,
    [string]$Unit
  )

  if ($Value -match "^\s*([\d.]+)\s*([^\d.]+)\s*$") {
    $Value = $matches[1]
    $Unit = $matches[2]
  }

  if ($Unit -notmatch "^(px|in|cm|pt)$") {
    Write-Error "Unknown unit: '$Unit'"
    return
  }

  switch ($Unit) {
    "px" { $result = [double]$Value }
    "in" { $result = [double]$Value * 96.0 }
    "cm" { $result = [double]$Value * (96.0 / 2.54) }
    "pt" { $result = [double]$Value * (96.0 / 72) }
    default {
      Write-Error "Unknown unit: '$Unit'"
      return
    }
  }

  $result
}

function Add-OxyStyle {
  [cmdletbinding()]
  param(
    [string]$StyleName,
    [hashtable]$Config
  )

  $filteredTypes = New-Object Collections.Generic.List[object]
  $unit = "px"

  $result = @{}

  if ($Config.Contains("unit")) {
    $unit = $Config["unit"]
    if ($unit -notmatch "^(px|in|cm|pt)$") {
      Write-Error "Unknown unit: '$unit'"
      return
    }
  }

  foreach ($filter in $Config.Keys) {

    if ($filter -eq "unit") {
      continue
    }

    $filterType = $filter -replace "\..+$", ""
    $filterProp = $filter -replace "^.+\.", ""

    $filteredTypes.Clear()
    foreach ($t in $TYPE_HASH.Keys) {
      if ($t -like $filterType) {
        $filteredTypes.Add($TYPE_HASH[$t])
      }
    }
    if ($filteredTypes.Count -eq 0) {
      Write-Error "No matching types for '$filterType'"
      return
    }

    $originalValue = $Config[$filter]
    $matchCount = 0

    foreach ($t in $filteredTypes) {

      $prop = $t.GetProperties() | where { $_.Name -eq $filterProp }
      if ($null -eq $prop -or !$prop.CanWrite) {
        continue
      }

      Write-Verbose "$filter=$originalValue (class: $($t.FullName))"
      ++$matchCount

      switch -regex ($prop.PropertyType.FullName) {
        "^System\.Double$" {
          $value = Get-LogicalPoint $originalValue $unit
        }
        "^OxyPlot\.OxyColor$" {
          $value = New-OxyColor $originalValue
        }
        "^System\.Collections\.Generic\.IList``1\[\[OxyPlot\.OxyColor" {
          $value = New-Object Collections.Generic.List[OxyPlot.OxyColor]
          foreach ($v in $originalValue) {
            if ($v -isnot [OxyPlot.OxyColor]) {
              $v = New-OxyColor $v
            }
            $value.Add($v)
          }
        }
        default {
          $value = $originalValue
        }
      }

      if ($result.Contains($t.FullName)) {
        $result[$t.Fullname][$filterProp] = $value
      }
      else {
        $result[$t.FullName] = @{ $filterProp = $value }
      }

    }

    if ($matchCount -eq 0) {
      Write-Error "No matching property for '$filterProp'"
      return
    }

  }

  $Styles[$StyleName] = $result
}

function Get-OxyStyle {
  [cmdletbinding()]
  param(
    [string]$StyleName
  )

  $Styles[$StyleName]
}

function Test-OxyStyleName {
  param(
    [string]$StyleName
  )
  $Styles.Contains($StyleName)
}

function Apply-OxyStyle {
  param(
    [object]$Object,
    [string]$StyleName,
    [Management.Automation.InvocationInfo]$InvocationInfo # for future use
  )

  $style = $Styles[$StyleName]
  if ($style -eq $null) {
    return
  }

  $config = $style[$Object.GetType().FullName]
  if ($null -eq $config) {
    return
  }

  foreach ($p in $config.Keys) {
    $Object.$p = $config[$p]
  }
}

function Set-OxyDefaultStyle {
  param(
    [string]$StyleName
  )

  $Styles["default"] = $Styles[$StyleName]
}
