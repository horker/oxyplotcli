Set-StrictMode -version 3

function New-Oxy<% $ClassName -replace "^([^.]+\.)*", "" %> {
  [cmdletbinding()]
  param(
<% $SeriesElement | foreach { -%>
    [Parameter(ParameterSetName="ByElement")]
    [<% $_.Class %>[]]$<% $_.Name %> = @(),
<% } -%>

<% $SeriesElement | foreach { -%>
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

  $info = [PSCustomObject]@{
    XAxisTitle = $null
    YAxisTitle = $null
    XDataType = $null
    YDataType = $null
  }

  if ($PSCmdlet.ParameterSetName -eq "Composite") {
    $info.XAxisTitle = $<% $SeriesElement[0].Name %>
    $info.YAxisTitle = $<% $SeriesElement[1].Name %>
  }
  else {
    $info.XAxisTitle = "<% $SeriesElement[0].Name %>"
    $info.YAxisTitle = "<% $SeriesElement[1].Name %>"
  }

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName $ClassName -Indent 2 -VariableName series -OptionHashName Options -%>

  Set-StrictMode -Off
}

process {
  if ($null -ne $InputObject) {
    Add-Oxy<% $ClassName -replace  "^([^.]+\.)*", "" %>Point $series<% $SeriesElement | foreach { %> $InputObject.$<% $_.Name %>Name<% } %>

    if ($null -eq $info.XDataType) {
      $info.XDataType = $InputObject.<% $SeriesElement[0].Name %>.GetType()
      $info.YDataType = $InputObject.<% $SeriesElement[1].Name %>.GetType()
    }
  }
}

end {
  if ($PSCmdlet.ParameterSetName -eq "Composite") {
    foreach ($d in $Data) {
      New-Oxy<% $ClassName -replace  "^([^.]+\.)*", "" %>Point $series<% $SeriesElement | foreach { %> $d.<% $_.Name %>Name<% } %>
    }
    if ($null -eq $info.XDataType) {
      $info.XDataType = $Data[0].<% $SeriesElement[0].Name %>.GetType()
      $info.YDataType = $Data[0].<% $SeriesElement[1].Name %>.GetType()
    }
  }
  else {
    for ($i = 0; $i -lt $<% $SeriesElement[0].Name%>.Count; ++$i) {
      Add-Oxy<% $ClassName -replace  "^([^.]+\.)*", "" %>Point $series<% $SeriesElement | foreach { %> $<% $_.Name %>[$i]<% }%>
    }

    $info.XDataType = $<% $SeriesElement[0].Name %>.GetType()
    $info.YDataType = $<% $SeriesElement[1].Name %>.GetType()
  }

#  Apply-Style "<% $ClassName %>" $l $MyInvocation $StyleName

  $series | Add-Member -PassThru NoteProperty _Info $info
}
}
