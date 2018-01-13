Set-StrictMode -Version 3

function New-OxyWindow {
  [cmdletbinding()]
  param(
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "System.Windows.Window" -%>
    [Hashtable]$Options = @{}
  )

  $OptionHash = @{ Title = "OxyPlot CLI" }

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "System.Windows.Window" -VariableName "OptionHash" -OptionHashName "Options" -%>

  New-WpfWindow -Options $OptionHash
}

function Close-OxyWindow {
  [cmdletbinding()]
  param(
    [int]$Index = -1
  )

  $w = Get-OxyWindow $Index
  Close-WpfWindow $w
}

function Get-OxyWindow {
  [cmdletbinding()]
  param(
    [int]$Index = -1
  )

  $list = Get-OxyWindowList
  if ($null -eq $list) {
    Write-Error "No active OxyPlot windows"
    return
  }
  $list = @($list)

  if ($Index = -1) {
    $Index = $list.Count - 1
  }

  if ($Index -lt 0 -or $list.Count -le $Index) {
    Write-Error "Window index out of range"
    return
  }

  $list[$Index]
}

function Get-OxyWindowList {
  [cmdletbinding()]
  param()

  Get-WpfWindowList
}

############################################################

function Add-OxyPlotViewInGrid {
  [cmdletbinding(DefaultParameterSetName="ByDefinition")]
  param(
    [Parameter(Position=0)]
    [Windows.Window]$Window,
    [OxyPlot.PlotModel[]]$PlotModel,
    [Parameter(ParameterSetName="ByDefinition")]
    [string[]]$ColumnDefinition = "*",
    [Parameter(ParameterSetName="ByDefinition")]
    [string[]]$RowDefinition = "*",
    [Parameter(ParameterSetName="ByCount")]
    [int]$Columns = 1,
    [Parameter(ParameterSetName="ByCount")]
    [int]$Rows = 1,

<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "System.Windows.Controls.Grid" -Indent 4 -%>
    [Hashtable]$Options = @{}
  )

  $OptionHash = @{}
<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "System.Windows.Controls.Grid" -VariableName "OptionHash" -OptionHashName "Options" -Indent 2 -%>

  if ($PSCmdlet.ParameterSetName -eq "ByCount") {
    $ColumnDefinition = (1..$Columns) | foreach { "*" }
    $RowDefinition = (1..$Rows) | foreach { "*" }
  }

  $views = New-Object Collections.Generic.List[OxyPlot.Wpf.PlotView]

  Invoke-WpfWindowAction $Window {
    $grid = New-Object Windows.Controls.Grid

    foreach ($key in $OptionHash.Keys) {
      $grid.$key = $OptionHash[$key]
    }

    foreach ($c in $ColumnDefinition) {
      $def = New-Object Windows.Controls.ColumnDefinition
      $def.Width = (New-Object Windows.GridLengthConverter).ConvertFromString($c)
      $grid.ColumnDefinitions.Add($def)
    }

    foreach ($r in $RowDefinition) {
      $def = New-Object Windows.Controls.RowDefinition
      $def.Height = (New-Object Windows.GridLengthConverter).ConvertFromString($r)
      $grid.RowDefinitions.Add($def)
    }

    $Window.Content = $grid

    $columnCount = $grid.ColumnDefinitions.Count
    $rowCount = $grid.RowDefinitions.Count

    for ($r = 0; $r -lt $rowCount; ++$r) {
      for ($c = 0; $c -lt $columnCount; ++$c) {
        $view = New-Object OxyPlot.Wpf.PlotView
        $views.Add($view)
        $grid.Children.Add($view)
        [Windows.Controls.Grid]::SetColumn($view, $c)
        [Windows.Controls.Grid]::SetRow($view, $r)
      }
    }

    $count = 0
    foreach ($m in $PlotModel) {
      $views[$count].Model = $m
      ++$count
    }
  }

  $views
}

function Add-OxyPlotModelToPlotView {
  [cmdletbinding()]
  param(
    [Windows.Window]$Window,
    [OxyPlot.Wpf.PlotView]$PlotView,
    [OxyPlot.PlotModel]$PlotModel
  )

  Invoke-WpfWindowAction $Window {
    $PlotView.Model = $PlotModel
  }
}
