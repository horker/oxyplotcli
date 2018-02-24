<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

function New-Oxy<% $ClassName -replace "^([^.]+\.)*", "" %> {
  [cmdletbinding()]
  param(
<% if ($SeriesElement -ne $null) { -%>
<% $SeriesElement.Element | foreach { -%>
    [<% $_.Class %>[]]$<% $_.Name %> = @(),
<% } -%>

<% $SeriesElement.Element | foreach { -%>
    [string]$<% $_.Name %>Name,
<% } -%>

    [Parameter(ValueFromPipeline=$true)]
    [object]$InputObject,

<% } -%>
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName $ClassName -Indent 4 -%>

    [hashtable]$Options = @{},

    [string]$Style = "default",
    [switch]$Show
  )

begin {

  if (!(Test-OxyStyleName $Style)) {
    Write-Error "Unknown style: '$Style'"
    return
  }

  $series = New-Object <% $ClassName %>

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

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName $ClassName -Indent 2 -VariableName series -OptionHashName Options -%>

<% if ($SeriesElement -ne $null) { -%>
<% foreach ($e in $SeriesElement.Element) { -%>
  $<% $e.Name %>Data = New-Object Collections.Generic.List[<% $e.Class %>]
<% } -%>

  Set-StrictMode -Off
<% } -%>
}

<% if ($SeriesElement -ne $null) { -%>
process {
  if ($InputObject -ne $null) {
<% foreach ($e in $SeriesElement.Element) { -%>
    if ($PSBoundParameters.ContainsKey("<% $e.Name %>Name")) { $<% $e.Name %>Data.Add($InputObject.$<% $e.Name %>Name) }
<% } -%>
  }
}
<% } -%>

end {
<% if ($SeriesElement -ne $null) { -%>
<% foreach ($e in $SeriesElement.Element) { -%>
  if ($<% $e.Name %>Data.Count -gt 0 -and $<% $e.Name %>.Count -gt 0) { Write-Error "Data set of '<% $e.Name %>' is given in two ways"; return }
<% } -%>

<% foreach ($e in $SeriesElement.Element) { -%>
  $<% $e.Name %>Data.AddRange($<% $e.Name %>)
<% } -%>

  $dataCount = $<% $SeriesElement.Element[0].Name %>Data.Count
  for ($i = 0; $i -lt $dataCount; ++$i) {
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

  if ($Show) {
    $series | Show-OxyPlot -WTitle $MyInvocation.Line -Style $Style
  }
  else {
    $series
  }
}
}
