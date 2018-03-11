<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

<#
<% ../tools/Insert-Help.ps1 $Document $ClassName %>
.INPUTS
#>
function New-Oxy<% $ClassName -replace "^([^.]+\.)*", "" %> {
 [cmdletbinding()]
 [OutputType([<% $ClassName %>])]
  param(
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName $ClassName -Indent 4 -%>

    [hashtable]$Options = @{},

    [string]$Style = "default",
    [OxyPlot.PlotModel]$AddTo
  )

  $a = New-Object <% $ClassName %>

  Apply-OxyStyle $a $Style $MyInvocation

  $props = $PROPERTY_HASH["<% $ClassName %>"]
  Assign-ParametersToProperties $props $PSBoundParameters $Options $a

  if ($AddTo -ne $null) {
<% if ($ClassName -match "Axis$") { -%>
    $AddTo.Axes.Add($a)
<% } else { -%>
    $AddTo.Annotations.Add($a)
<% } -%>
    $AddTo.InvalidatePlot($false)
  }
  else {
    $a
  }
}
