<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

function <% $output %> {
  [cmdletbinding(DefaultParameterSetName="PlotModel")]
  param(
    [Parameter(ParameterSetName="PlotModel", ValueFromPipeline=$true)]
    [OxyPlot.PlotModel]$PlotModel,

    [Parameter(ParameterSetName="Series", ValueFromPipeline=$true)]
    [OxyPlot.Series.Series]$InputObject,

<% if ($output -match "Show-OxyPlot") { -%>
    [switch]$Reuse,

<% } elseif ($output -match "Save-OxyPlot") { -%>
    [Parameter(Position=0, Mandatory=$true)]
    [string]$OutFile,

    [double]$ImageWidth = 800,
    [double]$ImageHeight = 600,
    [string]$ImageBackground = "white",
    [bool]$IsDocument = $false,

<% } -%>
    [string]$StyleName,

<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.PlotModel" -Indent 4 -%>
    [hashtable]$Options = @{},

<% if ($output -match "Show-OxyPlot") { -%>
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "System.Windows.Window" -Indent 2 -VariableName w -OptionHashName WOptions -Prefix W -%>
    [hashtable]$WOptions = @{},

<% } -%>
    [string]$AxType,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.Axes.Axis" -Indent 4 -Prefix "Ax" -%>
    [hashtable]$AxOptions = @{},

    [string]$AyType,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.Axes.Axis" -Indent 4 -Prefix "Ay" -%>
    [hashtable]$AyOptions = @{}
  )

begin {
  if ($PlotModel -eq $null) {
    $PlotModel = New-Object OxyPlot.PlotModel
  }
}

process {
  if ($InputObject -ne $null) {
    $PlotModel.Series.Add($InputObject)
  }
}

end {
<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.PlotModel" -Indent 2 -VariableName PlotModel -OptionHashName Options -%>

  $ax = $null
  $ay = $null

  if ($PSBoundParameters.ContainsKey("AxType")) {
    $ax = Get-AxisByPartialTypeName $AxType
    $ax.Position = "Bottom"
    if (!$ax) {
      Write-Error "No Axis type matches with '$AxType'"
      return
    }

    $PlotModel.Axes.Add($ax)
  }

  if ($PSBoundParameters.ContainsKey("AyType")) {
    $ay = Get-AxisByPartialTypeName $AyType
    $ay.Position = "Left"
    if (!$ay) {
      Write-Error "No Axis type matches with '$AyType'"
      return
    }

    $PlotModel.Axes.Add($ay)
  }

  foreach ($a in $PlotModel.Axes) {
    if ($ax -eq $null -and $a.IsHorizontal()) {
      $ax = $a
    }
    if ($ay -eq $null -and $a.IsVertical()) {
      $ay = $a
    }
  }

  if ($ax -eq $null) {
    foreach ($s in $PlotModel.Series) {
      if ($s.IsVisible -and (Test-AxesRequired $s)) {
        if ($s -is [OxyPlot.Series.ColumnSeries] -or
            $s -is [OxyPlot.Series.ErrorColumnSeries]) {
          $ax = New-Object OxyPlot.Axes.CategoryAxis
          if ($s.PSObject.Properties.Name -Contains "_Info") {
            foreach ($n in $s._Info.CategoryNames) {
              $ax.Labels.Add($n)
            }
          }
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
        $PlotModel.Axes.Add($ax)
        break
      }
    }
  }

  if ($ay -eq $null) {
    foreach ($s in $PlotModel.Series) {
      if ($s.IsVisible -and (Test-AxesRequired $s)) {
        if ($s -is [OxyPlot.Series.BarSeries] -or
            $s -is [OxyPlot.Series.IntervalBarSeries] -or
            $s -is [OxyPlot.Series.LinearBarSeries] -or
            $s -is [OxyPlot.Series.RectangleBarSeries] -or
            $s -is [OxyPlot.Series.TornadoBarSeries]) {
          $ay = New-Object OxyPlot.Axes.CategoryAxis
          if ($s.PSObject.Properties.Name -Contains "_Info") {
            foreach ($n in $s._Info.CategoryNames) {
              $ay.Labels.Add($n)
            }
          }
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
        $PlotModel.Axes.Add($ay)
        break
      }
    }
  }

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.Axes.Axis" -Indent 2 -VariableName ax -OptionHashName AxOptions -Prefix Ax -%>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.Axes.Axis" -Indent 2 -VariableName ay -OptionHashName AyOptions -Prefix Ay -%>

<% if ($output -match "New-OxyPlotModel") { -%>
  $PlotModel
<% } elseif ($output -match "Show-OxyPlot") { -%>
  if ($Reuse) {
    $w = Get-OxyWindow
  }
  else {
    $w = New-OxyWindow -Title $MyInvocation.Line
  }

  Invoke-WpfWindowAction $w {

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "System.Windows.Window" -Indent 4 -VariableName w -OptionHashName WOptions -Prefix W -%>

    $w.Activate()

    $view = New-Object OxyPlot.Wpf.PlotView
    $view.Model = $PlotModel

    $g = New-Object Windows.Controls.Grid
    $g.Children.Add($view)
    $w.Content = $g
  }
<% } else { -%>
  $OutFile = try { Resolve-Path $OutFile -EA Stop } catch { $_.TargetObject }

  switch -regex ($OutFile) {
    "\.svg$" {
      $ex = New-Object OxyPlot.SvgExporter
      $ex.Width = $ImageWidth
      $ex.Height = $ImageHeight
      $ex.IsDocument = $IsDocument
      $ex.ExportToString($PlotModel) | Set-Content $OutFile
    }
    "\.pdf$" {
      $ex = New-Object OxyPlot.PdfExporter
      $ex.Width = $ImageWidth
      $ex.Height = $ImageHeight
      $ex.Background = New-OxyColor $ImageBackground

      $stream = [IO.File]::Create($OutFile)
      try {
        $ex.Export($PlotModel, $stream)
      }
      finally {
        $stream.Close()
      }
    }
    default { # Png
      $ex = New-Object OxyPlot.Wpf.PngExporter
      $ex.Width = $ImageWidth
      $ex.Height = $ImageHeight
      $ex.Background = New-OxyColor $ImageBackground

      $stream = [IO.File]::Create($OutFile)
      try {
        $ex.Export($PlotModel, $stream)
      }
      finally {
        $stream.Close()
      }
    }
  }
<% } -%>
}
}
