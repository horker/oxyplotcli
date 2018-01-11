<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

function New-Oxy<% $ClassName -replace "^([^.]+\.)*", "" %> {
 [cmdletbinding()]
  param(
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName $ClassName -Indent 4 -%>

    [hashtable]$Options = @{}
  )

  $axis = New-Object <% $ClassName %>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName $ClassName -Indent 2 -VariableName axis -OptionHashName Options -%>

  $axis
}
