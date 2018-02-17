Set-StrictMode -Version 3

function New-OxyPlotModel {
  [cmdletbinding()]
  param(
    [Parameter(ValueFromPipeline=$true, Mandatory=$false)]
    [OxyPlot.Series.Series]$InputObject,
    [string]$StyleName,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.PlotModel" -Indent 4 -%>
    [hashtable]$Option = @{}
  )

begin {
  $model = New-Object OxyPlot.PlotModel
}

process {
  if ($null -ne $InputObject) {
    $model.Series.Add($InputObject)
  }
}

end {
#  Apply-Style "PlotModel" $model $MyInvocation $StyleName

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.PlotModel" -VariableName "model" -OptionHashName "Option" -Indent 2 -%>

  $model
}
}

function Update-OxyPlotModel {
  [cmdletbinding()]
  param(
    [OxyPlot.PlotModel]$Model,
    [bool]$UpdateData = $true
  )
  $Model.InvalidatePlot($UpdateData)
}
