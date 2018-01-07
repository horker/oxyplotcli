<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

function New-Oxy<% $ClassName -replace "^([^.]+\.)*", "" %> {
  [cmdletbinding()]
  param(
<% $SeriesElement.Element | foreach { -%>
    [Parameter(ParameterSetName="ByElement")]
    [<% $_.Class %>[]]$<% $_.Name %> = @(),
<% } -%>

<% $SeriesElement.Element | foreach { -%>
    [Parameter(ParameterSetName="Composite")]
    [string]$<% $_.Name %>Name = "<% $_.Name %>",
<% } -%>
    [Parameter(ParameterSetName="Composite")]
    [object[]]$Data,
    [Parameter(ParameterSetName="Composite", ValueFromPipeline=$true)]
    [object]$InputObject,

    [string]$StyleName,

<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName $ClassName -Indent 4 -%>

    [hashtable]$Options = @{}
  )

begin {
  $series = New-Object <% $ClassName %>

<% if (!$NoAxis) { -%>
  $info = [PSCustomObject]@{
    XAxisTitle = $null
    YAxisTitle = $null
    XDataType = $null
    YDataType = $null
  }

  if ($PSCmdlet.ParameterSetName -eq "Composite") {
    $info.XAxisTitle = $<% $SeriesElement.Element[0].Name %>
    $info.YAxisTitle = $<% $SeriesElement.Element[1].Name %>
  }
  else {
    $info.XAxisTitle = "<% $SeriesElement.Element[0].Name %>"
    $info.YAxisTitle = "<% $SeriesElement.Element[1].Name %>"
  }
<% } -%>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName $ClassName -Indent 2 -VariableName series -OptionHashName Options -%>

  Set-StrictMode -Off
}

process {
  if ($null -ne $InputObject) {
    <% $SeriesElement.Cmdlet %> $series<% $SeriesElement.Element | foreach { %> $InputObject.$<% $_.Name %>Name<% } %>

<% if (!$NoAxis) { -%>
    if ($null -eq $info.XDataType) {
      $info.XDataType = $InputObject.$<% $SeriesElement.Element[0].Name %>Name.GetType()
      $info.YDataType = $InputObject.$<% $SeriesElement.Element[1].Name %>Name.GetType()
    }
<% } -%>
  }
}

end {
  if ($PSCmdlet.ParameterSetName -eq "Composite") {
    foreach ($d in $Data) {
      <% $SeriesElement.Cmdlet %> $series<% $SeriesElement.Element | foreach { %> $d.$<% $_.Name %>Name<% } %>
    }
<% if (!$NoAxis) { -%>
    if ($null -eq $info.XDataType) {
      $info.XDataType = $Data[0].$<% $SeriesElement.Element[0].Name %>Name.GetType()
      $info.YDataType = $Data[0].$<% $SeriesElement.Element[1].Name %>Name.GetType()
    }
<% } -%>
  }
  else {
    for ($i = 0; $i -lt $<% $SeriesElement.Element[0].Name%>.Count; ++$i) {
      <% $SeriesElement.Cmdlet %> $series<% $SeriesElement.Element | foreach { %> $<% $_.Name %>[$i]<% }%>
    }

<% if (!$NoAxis) { -%>
    $info.XDataType = $<% $SeriesElement.Element[0].Name %>[0].GetType()
    $info.YDataType = $<% $SeriesElement.Element[1].Name %>[0].GetType()
<% } -%>
  }

#  Apply-Style "<% $ClassName %>" $l $MyInvocation $StyleName

<% if (!$NoAxis) { -%>
  $series | Add-Member -PassThru NoteProperty _Info $info
<% } else {-%>
  $series
<% } -%>
}
}
