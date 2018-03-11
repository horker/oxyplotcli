Set-StrictMode -Version 3

function New-OxyWindow {
  [cmdletbinding()]
  [OutputType([Windows.Window])]
  param(
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "System.Windows.Window" -%>
    [Hashtable]$Options = @{}
  )

  $OptionHash = @{ Title = "OxyPlot CLI" }

  $props = $PROPERTY_HASH["System.Windows.Window"]
  Assign-ParametersToProperties $props $PSBoundParameters $Options $OptionHash

  New-WpfWindow -Options $OptionHash
}

function Close-OxyWindow {
  [cmdletbinding()]
  [OutputType([void])]
  param(
    [int]$Index = -1,
    [switch]$All
  )

  if ($All) {
    foreach ($w in (Get-OxyWindowList)) {
      Close-WpfWindow $w
    }
  }
  else {
    $w = Get-OxyWindow $Index
    Close-WpfWindow $w
  }
}

function Get-OxyWindow {
  [cmdletbinding()]
  [OutputType([Windows.Window])]
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
  [OutputType([Windows.Window[]])]
  param()

  Get-WpfWindowList
}

############################################################

function Add-OxyPlotViewInGrid {
  [cmdletbinding(DefaultParameterSetName="ByDefinition")]
  [OutputType([OxyPlot.Wpf.PlotView[]])]
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
  $props = $PROPERTY_HASH["System.Windows.Controls.Grid"]
  Assign-ParametersToProperties $props $PSBoundParameters $Options $OptionHash

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
  [OutputType([void])]
  param(
    [Windows.Window]$Window,
    [OxyPlot.Wpf.PlotView]$PlotView,
    [OxyPlot.PlotModel]$PlotModel
  )

  $null = Invoke-WpfWindowAction $Window {
    $PlotView.Model = $PlotModel
  }
}
