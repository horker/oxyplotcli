Set-StrictMode -Version 3

$script:Styles = @{}

function Add-OxyStyle {
  [cmdletbinding()]
  param(
    [string]$StyleName,
    [hashtable]$Config
  )

  $filteredTypes = New-Object Collections.Generic.List[object]

  $general = @{}
  $specific = @{}

  foreach ($filter in $Config.Keys) {

    if ($filter -match "^\[") {
      $general[$filter] = $Config[$filter]
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
    if ($originalValue -is [Array] -and
        $originalValue.Count -eq 2 -and
        $originalValue[1] -is [string] -and
        $originalValue[1] -match "^(pt|in|cm|pt)$") {
      $originalValue = $originalValue[0].ToString() + $originalValue[1].ToString()
    }

    $matchCount = 0

    foreach ($t in $filteredTypes) {

      if ($filterProp -eq "*") {
        if ($originalValue -isnot [scriptblock]) {
          Write-Error "Filter $filter's property is wildcard, but no scriptblock is specified"
          return
        }
        $value = $originalValue
        ++$matchCount
      }
      else {
        $prop = $t.GetProperties() | where { $_.Name -eq $filterProp }
        if ($null -eq $prop -or !$prop.CanWrite) {
          continue
        }

        Write-Verbose "$filter=$originalValue (class: $($t.FullName))"
        ++$matchCount

        $value = Convert-ParameterValue $prop.PropertyType.FullName $originalValue
      }

      $isGeneral = $filterType -match "[*?]"
      if ($isGeneral) {
        if ($general.Contains($t.FullName)) {
          $general[$t.Fullname][$filterProp] = $value
        }
        else {
          $general[$t.FullName] = @{ $filterProp = $value }
        }
      }
      else {
        if ($specific.Contains($t.FullName)) {
          $specific[$t.Fullname][$filterProp] = $value
        }
        else {
          $specific[$t.FullName] = @{ $filterProp = $value }
        }
      }

    }

    if ($matchCount -eq 0) {
      Write-Error "No matching property for '$filterProp'"
      return
    }

  }

  foreach ($type in $specific.Keys) {
    if ($specific[$type] -is [Collections.IDictionary]) {
      foreach ($prop in $specific[$type].Keys) {
        if ($general.Contains($type)) {
          $general[$type][$prop] = $specific[$type][$prop]
        }
        else {
          $general[$type] = @{ $prop = $specific[$type][$prop] }
        }
      }
    }
  }

  $Styles[$StyleName] = $general
}

function Remove-OxyStyle {
  param(
    [string]$StyleName
  )

  $styles.Remove($StyleName)
}

function Get-OxyStyle {
  [cmdletbinding()]
  param(
    [string]$StyleName
  )

  if (!(Test-OxyStyleName $StyleName)) {
    Write-Error "Unknown style: $StyleName"
    return
  }

  $Styles[$StyleName]
}

function Test-OxyStyleName {
  [cmdletbinding()]
  param(
    [string]$StyleName
  )
  $Styles.Contains($StyleName)
}

function Apply-OxyStyle {
  param(
    [object]$Object,
    [string]$StyleName,
    [Management.Automation.InvocationInfo]$InvocationInfo
  )

  $style = $Styles[$StyleName]
  if ($style -eq $null) {
    return
  }

  $config = $style[$Object.GetType().FullName]

  if ($null -ne $config) {
    foreach ($p in $config.Keys) {
      if ($p -eq "*") {
        [void]$config["*"].Invoke($Object, $InvocationInfo)
      }
      else {
        $Object.$p = $config[$p]
      }
    }
  }

  if ($StyleName -ne "local" -and $Styles.ContainsKey("local")) {
    Apply-OxyStyle $Object "local" $InvocationInfo
  }
}

function Apply-OxyStyleEvent {
  param(
    [OxyPlot.PlotModel]$PlotModel,
    [string]$StyleName,
    [string]$EventName,
    [Management.Automation.InvocationInfo]$InvocationInfo
  )

  $style = $Styles[$StyleName]
  if ($style -eq $null) {
    Write-Error "Unknown style: $StyleName"
    return
  }

  [scriptblock]$script = $style["[$EventName]"]
  if ($script -eq $null) {
    return
  }

  [void]$script.Invoke($PlotModel, $InvocationInfo)
}

function Set-OxyDefaultStyle {
  param(
    [string]$StyleName
  )

  $Styles["default"] = $Styles[$StyleName]
}
