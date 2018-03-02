<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

<#
<% ../tools/Insert-Help.ps1 $Document $ClassName %>
.INPUTS
#>
function New-Oxy<% $ClassName -replace "^([^.]+\.)*", "" %> {
 [cmdletbinding()]
  param(
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName $ClassName -Indent 4 -%>

    [hashtable]$Options = @{},

    [string]$Style = "default",
    [OxyPlot.PlotModel]$AddTo
  )

  $a = New-Object <% $ClassName %>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName $ClassName -Indent 2 -VariableName a -OptionHashName Options -%>

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
