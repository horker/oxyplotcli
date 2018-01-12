Set-StrictMode -Version 3

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

  if ($Model -ne $null) {
    Invoke-WpfWindowAction $w {
      $view = New-Object OxyPlot.Wpf.PlotView
      $view.Model = $Model

      $g = New-Object Windows.Controls.Grid
      $g.Children.Add($view)
      $w.Content = $g
    }
  }

  $w
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
