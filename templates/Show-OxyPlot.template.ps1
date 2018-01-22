Set-StrictMode -Version 3

function Get-AxisObject {
  param(
    [Reflection.TypeInfo]$DataType
  )

  if ($DataType -eq [DateTime]) {
    $type = "OxyPlot.Axes.DateTimeAxis"
  }
  elseif ($DataType -is [TimeSpan]) {
    $type = "OxyPlot.Axes.TimeSpanAxis"
  }
  else {
    $type = "OxyPlot.Axes.LinearAxis"
  }

  New-Object $type
}

############################################################

$script:ResultsOfAreAxesRequired = @{}

[OxyPlot.Series.Series].Assembly.GetTypes() |
  where { $_.Name -Match "Series$" -And !$_.IsAbstract } |
  foreach {
    $m = [OxyPlot.Series.Series].GetMethod(
      "AreAxesRequired",
      [Reflection.BindingFlags]::InvokeMethod -bor [Reflection.BindingFlags]::Instance -bor [Reflection.BindingFlags]::NonPublic)
  },
  {
    $name = $_.FullName
    $ResultsOfAreAxesRequired[$name] = $m.Invoke((new-Object $name), $null)
  }

function Test-AxesRequired {
  param(
    [OxyPlot.Series.Series]$series
  )

  $ResultsOfAreAxesRequired[$series.GetType().FullName]
}

############################################################

$script:AxisTypes = [OxyPlot.Axes.Axis].Assembly.GetTypes() |
  where { $_.Name -Match "Axis$" -And !$_.IsAbstract } |
  foreach { $_.FullName } |
  Sort

function Get-AxisByPartialTypeName {
  param(
    [string]$PartialName
  )

  foreach ($t in $AxisTypes) {
    if ($t -Match [regex]::Escape($PartialName)) {
      return New-Object $t
    }
  }

  $null
}

############################################################

function Show-OxyPlot {
  [cmdletbinding()]
  param(
    [Parameter(ParameterSetName="PlotModel", ValueFromPipeline=$true)]
    [OxyPlot.PlotModel]$PlotModel,
    [Parameter(ParameterSetName="Series", ValueFromPipeline=$true)]
    [OxyPlot.Series.Series]$Series,
    [string]$StyleName,
    [OxyPlot.Axes.Axis[]]$Axes,
    [switch]$Reuse,

    [string]$AxType,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.Axes.Axis" -Indent 4 -Prefix "Ax" -%>
    [hashtable]$AxOptions = @{},

    [string]$AyType,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.Axes.Axis" -Indent 4 -Prefix "Ay" -%>
    [hashtable]$AyOptions = @{}
  )

begin {
  $model = $null
}

process {
  if ($model -eq $null) {
    if ($PSCmdlet.ParameterSetName -eq "Series") {
      $model = New-Object OxyPlot.PlotModel
    }
    else {
      $model = $PlotModel
    }
  }
  if ($Series -ne $null) {
    $model.Series.Add($Series)
  }
}

end {
  $ax = $null
  $ay = $null

  if ($PSBoundParameters.ContainsKey("AxType")) {
    $ax = Get-AxisByPartialTypeName $AxType
    $ax.Position = "Bottom"
    if (!$ax) {
      Write-Error "No Axis type matches with '$AxType'"
      return
    }

    $model.Axes.Add($ax)
  }

  if ($PSBoundParameters.ContainsKey("AyType")) {
    $ay = Get-AxisByPartialTypeName $AyType
    $ay.Position = "Left"
    if (!$ay) {
      Write-Error "No Axis type matches with '$AyType'"
      return
    }

    $model.Axes.Add($ay)
  }

  foreach ($a in $Axes) {
    $model.Axes.Add($a)
    if ($ax -eq $null -and $a.IsHorizontal()) {
      $ax = $a
    }
    if ($ay -eq $null -and $a.IsVertical()) {
      $ay = $a
    }
  }

  if ($ax -eq $null) {
    foreach ($s in $Series) {
      if ($s.IsVisible -and (Test-AxesRequired $s)) {
        if ($s -is [OxyPlot.Series.ColumnSeries]) {
          $ax = New-Object OxyPlot.Axes.CategoryAxis
        }
        else {
          if ($s.PSObject.Properties.Name -Contains "_Info") {
            $ax = Get-AxisObject $s._Info.XDataType
          }
          else {
            $ax = New-Object OxyPlot.Axes.LinearAxes
          }
        }
        $ax.Position = "Bottom"
        $model.Axes.Add($ax)
        break
      }
    }
  }

  if ($ay -eq $null) {
    foreach ($s in $Series) {
      if ($s.IsVisible -and (Test-AxesRequired $s)) {
        if ($s -is [OxyPlot.Series.BarSeries]) {
          $ay = New-Object OxyPlot.Axes.CategoryAxis
        }
        else {
          if ($s.PSObject.Properties.Name -Contains "_Info") {
            $ay = Get-AxisObject $s._Info.YDataType
          }
          else {
            $ay = New-Object OxyPlot.Axes.LinearAxes
          }
        }
        $ay.Position = "Left"
        $model.Axes.Add($ay)
        break
      }
    }
  }

  if ($ax -eq $null) {
    foreach ($a in $model.Axes) {
      if ($a.IsHorizontal()) {
        $ax = $a
        break
      }
    }
  }

  if ($ay -eq $null) {
    foreach ($a in $model.Axes) {
      if ($a.IsVertical()) {
        $ay = $a
        break
      }
    }
  }

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.Axes.Axis" -Indent 2 -VariableName ax -OptionHashName AxOptions -Prefix Ax -%>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.Axes.Axis" -Indent 2 -VariableName ay -OptionHashName AxOptions -Prefix Ay -%>

  if ($Reuse) {
    $w = Get-OxyWindow
  }
  else {
    $w = New-OxyWindow -Title $MyInvocation.Line
  }

  Invoke-WpfWindowAction $w {
    $w.Activate()

    $view = New-Object OxyPlot.Wpf.PlotView
    $view.Model = $model

    $g = New-Object Windows.Controls.Grid
    $g.Children.Add($view)
    $w.Content = $g
  }
}
}
