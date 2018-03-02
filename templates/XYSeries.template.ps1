<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

<#
<% ../tools/Insert-Help.ps1 $Document $ClassName %>
#>
function New-Oxy<% $ClassName -replace "^([^.]+\.)*", "" %> {
  [cmdletbinding()]
  [OutputType([<% $ClassName %>[]])]
  param(
<% if ($SeriesElement -ne $null) { -%>
<% $SeriesElement.Element | foreach { -%>
    [<% $_.Class %>[]]$<% $_.Name %> = @(),
<% } -%>
    [string[]]$Group = @(),

<% $SeriesElement.Element | foreach { -%>
    [string]$<% $_.Name %>Name,
<% } -%>
    [string]$GroupName,
    [string[]]$GroupKeys = @(),

    [Parameter(ValueFromPipeline=$true)]
    [object]$InputObject,

<% } -%>
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName $ClassName -Indent 4 -%>

    [hashtable]$Options = @{},

    [string]$Style = "default",
    [OxyPlot.PlotModel]$AddTo
  )

begin {

  if (!(Test-OxyStyleName $Style)) {
    Write-Error "Unknown style: '$Style'"
    return
  }

  $info = [PSCustomObject]@{
<% if ($XAxisElement -ne $null) { -%>
    XAxisTitle = "<% $XAxisElement.Name %>"
<% } else { -%>
    XAxisTitle = $null
<% } -%>
<% if ($YAxisElement -ne $null) { -%>
    YAxisTitle = "<% $YAxisElement.Name %>"
<% } else { -%>
    YAxisTitle = $null
<% } -%>
    XDataType = $null
    YDataType = $null
<% if ($SeriesElement -ne $null) { -%>
    GroupName = $GroupName
<% } else { -%>
    GroupName = $null
<% } -%>
<% if ($SeriesElement -ne $null -and $SeriesElement.Element.Name -Contains "Category") { -%>
    CategoryNames = @()
<% } -%>
  }

<% if ($XAxisElement -ne $null) { -%>
  if ($PSBoundParameters.ContainsKey("<% $XAxisElement.Name %>Name")) { $info.XAxisTitle = $<% $XAxisElement.Name %>Name }
<% } -%>
<% if ($YAxisElement -ne $null) { -%>
  if ($PSBoundParameters.ContainsKey("<% $YAxisElement.Name %>Name")) { $info.YAxisTitle = $<% $YAxisElement.Name %>Name }
<% } -%>

<% if ($SeriesElement -ne $null) { -%>
<% foreach ($e in $SeriesElement.Element) { -%>
  $<% $e.Name %>Data = New-Object Collections.Generic.List[<% $e.Class %>]
<% } -%>
  $GroupData = New-Object Collections.Generic.List[string]

  Set-StrictMode -Off
<% } -%>
}

<% if ($SeriesElement -ne $null) { -%>
process {
  if ($InputObject -ne $null) {
<% foreach ($e in $SeriesElement.Element) { -%>
    if ($PSBoundParameters.ContainsKey("<% $e.Name %>Name")) { $<% $e.Name %>Data.Add($InputObject.$<% $e.Name %>Name) }
<% } -%>
    if ($PSBoundParameters.ContainsKey("GroupName")) { $GroupData.Add($InputObject.$GroupName) }
  }
}
<% } -%>

end {
<% if ($SeriesElement -ne $null) { -%>
<% foreach ($e in $SeriesElement.Element) { -%>
  if ($<% $e.Name %>Data.Count -gt 0 -and $<% $e.Name %>.Count -gt 0) { Write-Error "Data set of '<% $e.Name %>' is given in two ways"; return }
<% } -%>
  if ($GroupData.Count -gt 0 -and $Group.Count -gt 0) { Write-Error "Data set of 'Group' is given in two ways"; return }

<% foreach ($e in $SeriesElement.Element) { -%>
  $<% $e.Name %>Data.AddRange($<% $e.Name %>)
<% } -%>
  $GroupData.AddRange($Group)

  if ($GroupData.Count -gt 0) {
    $groups = @{}
    foreach ($e in $GroupData) {
      $groups[$e] = 1
    }
    if ($GroupKeys.Count -eq 0) {
      $groupKeys = $groups.Keys | Sort
    }
    $grouping = $true
  }
  else {
    $groupKeys = @("dummy")
    $grouping = $false
  }

  $dataCount = $<% $SeriesElement.Element[0].Name %>Data.Count
  foreach ($group in $groupKeys) {

<% } # if ($SeriesElement -ne $null) -%>
    $series = New-Object <% $ClassName %>

<% if ($SeriesElement -ne $null) { -%>
    if ($grouping) {
      $series.Title = $group
    }

<% } # if ($SeriesElement -ne $null) -%>
<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName $ClassName -Indent 4 -VariableName series -OptionHashName Options -%>

<% if ($SeriesElement -ne $null) { -%>
    for ($i = 0; $i -lt $dataCount; ++$i) {
      if ($grouping -and $GroupData[$i] -ne $group) {
        continue
      }
<% foreach ($e in $SeriesElement.Element) { -%>
<%   if ($e.Name -ne "CategoryIndex") { -%>
      if ($i -lt $<% $e.Name %>Data.Count) { $<% $e.Name %>Element = $<% $e.Name %>Data[$i] } else { $<% $e.Name %>Element = $null }
<%   } else { -%>
      if ($i -lt $CategoryIndexData.Count) { $CategoryIndexElement = $CategoryIndexData[$i] } else { $CategoryIndexElement = $i }
<%   } -%>
<% } -%>
      <% $SeriesElement.Cmdlet %> $series<% $SeriesElement.Element | where { $_.Name -ne "Category" } | foreach { %> $<% $_.Name %>Element<% } %>
    }

<% } # if ($SeriesElement -ne $null) -%>
<% if ($XAxisElement -ne $null) { -%>
    if ($<% $XAxisElement.Name %>Data.Count -gt 0) { $info.XDataType = $<% $XAxisElement.Name %>Data[0].GetType() }
<% } -%>
<% if ($YAxisElement -ne $null) { -%>
    if ($<% $YAxisElement.Name %>Data.Count -gt 0) { $info.YDataType = $<% $YAxisElement.Name %>Data[0].GetType() }
<% } -%>
<% if ($SeriesElement -ne $null -and $SeriesElement.Element.Name -Contains "Category") { -%>
    $info.CategoryNames = $CategoryData
<% } -%>

    $series = $series | Add-Member -PassThru NoteProperty _Info $info

    Apply-OxyStyle $series $Style $MyInvocation

    if ($AddTo -ne $null) {
      Add-OxyObjectToPlotModel $series $AddTo -NoRefresh
    }
    else {
      $series
    }
<% if ($SeriesElement -ne $null) { -%>
  }
<% } # if ($SeriesElement -ne $null) -%>

  if ($AddTo -ne $null) {
    $AddTo.InvalidatePlot($true)
  }
}
}
