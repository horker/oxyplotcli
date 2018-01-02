Set-StrictMode -Version 3

$script:WindowList = New-Object Collections.Generic.List[object]

############################################################

function New-OxyWindow {
  [cmdletbinding()]
  param(
    [OxyPlot.PlotModel]$Model,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "System.Windows.Window" -%>
    [Hashtable]$Options = @{}
  )

  $OptionHash = @{ Title = "OxyPlot CLI" }

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "System.Windows.Window" -VariableName "OptionHash" -OptionHashName "Options" -%>

  $w = New-WpfWindow -Options $OptionHash

  Invoke-WpfWindowAction $w {
    $view = New-Object OxyPlot.Wpf.PlotView
    $view.Model = $Model

    $g = New-Object Windows.Controls.Grid
    $g.Children.Add($view)
    $w.Content = $g
  }

  $script:WindowList.Add([PSCustomObject]@{
    Window = $w
    PlotModel = $Model
  })

  $w
}

function Close-OxytWindow {
  [cmdletbinding()]
  param(
    [int]$Index = -1
  )

  $list = Get-OxyWindowList
  if ($Index = -1) {
    $Index = $list.Count - 1
  }
  $w = $list[$Index].Window
  Close-WpfWindow $w

  $sciprt:WindowList.RemoveAt($Index)
}

function Get-OxyWindow {
  [cmdletbinding()]
  param(
    [int]$Index = -1
  )

  $list = Get-OxyWindowList
  if ($list.Count -eq 0) {
    Write-Error "No active OxyPlot windows"
    return
  }

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

  Update-OxyWindowList
  ,$script:WindowList
}

function Update-OxyWindowList {
  [cmdletbinding()]
  param()

  [void]$script:WindowList.RemoveAll({ Test-WindowClosed $args[0].Window })
}
