Set-StrictMode -Version 3

function New-OxyPlotModel {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.Series[]]$Series,
    [string]$StyleName,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.PlotModel" -Indent 4 -%>
    [hashtable]$Option = @{}
  )

  $model = New-Object OxyPlot.PlotModel
  foreach ($s in $Series) {
    $model.Series.Add($s)
  }

#  Apply-Style "PlotModel" $model $MyInvocation $StyleName

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.PlotModel" -VariableName "model" -OptionHashName "Option" -Indent 2 -%>

  $model
}

function Update-OxyPlotModel {
  [cmdletbinding()]
  param(
    [OxyPlot.PlotModel]$Model,
    [bool]$UpdateData = $true
  )
  $Model.InvalidatePlot($UpdateData)
}
