<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

<#
<% if ($output -match "New-OxyPlotModel") { -%>
<% ..\tools\Insert-Help.ps1 $Document OxyPlot.PlotModel -%>
<% } elseif ($output -match "Show-OxyPlot") { -%>
.SYNOPSIS
Shows an OxyPlot chart.
<% ..\tools\Insert-Help.ps1 $Document OxyPlot.PlotModel -OnlyParameters -%>
<% } else { -%>
.SYNOPSIS
Saves an OxyPlot chart to an image file.
<% ..\tools\Insert-Help.ps1 $Document OxyPlot.PlotModel -OnlyParameters -%>
<% } -%>

.PARAMETER PlotModel
Represents a plot model.

.PARAMETER InputObject
Represents a set of series objects.

<% if ($output -match "Save-OxyPlot") { -%>
.PARAMETER OutFile
Represents a image file to save a chart.

An image type is determined by file extension.
The file extension can be one of ".svg", ".pdf" or ".png".

.PARAMETER ImageWidth
Represents an image width.

.PARAMETER ImageHeight
Represents an image height.

.PARAMETER ImageBackground
Represents an image backround color.

.PARAMETER IsDocument
Indicates whether the output document should contain <html> and </html> tags.
Effective only for SVG files.

<% } elseif ($output -match "New-OxyPlotModel") { -%>
.PARAMETER Show
Shows a chart instead of returning a PlotModel object.

.PARAMETER Reuse
Indicates to reuse the current chart window instead of opening a new one.

<% } else { -%>
.PARAMETER Reuse
Indicates to reuse the current chart window instead of opening a new one.

<% } -%>
<% ..\tools\Insert-Help.ps1 $Document $AxesClassNames -Prefix Ax -OnlyParameters -%>
<% ..\tools\Insert-Help.ps1 $Document $AxesClassNames -Prefix Ay -OnlyParameters -%>
#>
function <% $output %> {
  [cmdletbinding(DefaultParameterSetName="PlotModel")]
<% if ($output -match "New-OxyPlotModel") { -%>
  [OutputType([OxyPlot.PlotModel], [void])]
<% } else { -%>
  [OutputType([void])]
<% } -%>
  param(
    [Parameter(ParameterSetName="PlotModel", ValueFromPipeline=$true)]
    [OxyPlot.PlotModel]$PlotModel,

    [Parameter(ParameterSetName="Series", ValueFromPipeline=$true)]
    [OxyPlot.Series.Series]$InputObject,

<% if ($output -match "Save-OxyPlot") { -%>
    [Parameter(Position=0, Mandatory=$true)]
    [string]$OutFile,

    [double]$ImageWidth = 800,
    [double]$ImageHeight = 600,
    [string]$ImageBackground = "white",
    [bool]$IsDocument = $false,

<% } elseif ($output -match "New-OxyPlotModel") { -%>
    [switch]$Show,
    [switch]$Reuse,

<% } else { -%>
    [switch]$Reuse,

<% } -%>
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.PlotModel" -Indent 4 -%>
    [hashtable]$Options = @{},

<% if ($output -match "Show-OxyPlot|New-OxyPlotModel") { -%>
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "System.Windows.Window" -Indent 2 -VariableName w -OptionHashName WOptions -Prefix W -%>
    [hashtable]$WOptions = @{},

<% } -%>
    [string]$AxType,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -Properties $AxesProperties -Indent 4 -Prefix "Ax" -%>
    [hashtable]$AxOptions = @{},

    [string]$AyType,
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -Properties $AxesProperties -Indent 4 -Prefix "Ay" -%>
    [hashtable]$AyOptions = @{},

    [string]$Style = "default"
  )

begin {
  if (!(Test-OxyStyleName $Style)) {
    Write-Error "Unknown style: '$Style'"
    return
  }

  $modelCreated = $false
  if ($PlotModel -eq $null) {
    $PlotModel = New-Object OxyPlot.PlotModel
    $modelCreated = $true
  }
}

process {
  if ($InputObject -ne $null) {
    $PlotModel.Series.Add($InputObject)
  }
}

end {
  foreach ($s in $PlotModel.Series) {
    if ($s.IsVisible -and $s.PSObject.Properties.Name -Contains "_Info") {
      $PlotModel.LegendTitle = $s._Info.GroupName
      break
    }
  }

  if ($modelCreated) {
    Apply-OxyStyle $PlotModel $Style $MyInvocation
  }

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.PlotModel" -Indent 2 -VariableName PlotModel -OptionHashName Options -%>

  $ax = $null
  $ay = $null
  $axCreated = $false
  $ayCreated = $false

  if ($PSBoundParameters.ContainsKey("AxType")) {
    $ax = Get-AxisByPartialTypeName $AxType
    if (!$ax) {
      Write-Error "No Axis type matches with '$AxType'"
      return
    }
    $axCreated = $true
  }

  if ($PSBoundParameters.ContainsKey("AyType")) {
    $ay = Get-AxisByPartialTypeName $AyType
    if (!$ay) {
      Write-Error "No Axis type matches with '$AyType'"
      return
    }
    $ayCreated = $true
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
        if ((Get-RequiredCategoryAxis $s) -eq "x") {
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
        $axCreated = $true
        break
      }
    }
  }

  if ($ay -eq $null) {
    foreach ($s in $PlotModel.Series) {
      if ($s.IsVisible -and (Test-AxesRequired $s)) {
        if ((Get-RequiredCategoryAxis $s) -eq "y") {
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
        $ayCreated = $true
        break
      }
    }
  }

  if ($axCreated -or $ayCreated) {
    foreach ($s in $PlotModel.Series) {
      if ($s.IsVisible -and $s.PSObject.Properties.Name -Contains "_Info") {
        if ($axCreated) {
          if ((Get-RequiredCategoryAxis $s) -eq "x" -and
              $null -ne $s._Info.CategoryTitle) {
            $ax.Title = $s._Info.CategoryTitle
          }
          else {
            $ax.Title = $s._Info.XAxisTitle
          }
        }
        if ($ayCreated) {
          if ((Get-RequiredCategoryAxis $s) -eq "y" -and
              $null -ne $s._Info.CategoryTitle) {
            $ay.Title = $s._Info.CategoryTitle
          }
          else {
            $ay.Title = $s._Info.YAxisTitle
          }
        }
        break
      }
    }
  }

  if ($axCreated) {
    $ax.Position = "Bottom"
    Apply-OxyStyle $ax $Style $MyInvocation
    $PlotModel.Axes.Add($ax)
  }

  if ($ayCreated) {
    $ay.Position = "Left"
    Apply-OxyStyle $ay $Style $MyInvocation
    $PlotModel.Axes.Add($ay)
  }

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -Properties $AxesProperties -Indent 2 -VariableName ax -OptionHashName AxOptions -Prefix Ax -%>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -Properties $AxesProperties -Indent 2 -VariableName ay -OptionHashName AyOptions -Prefix Ay -%>

<% if ($output -match "New-OxyPlotModel") { -%>
  if (!$Show) {
    return $PlotModel
  }

<% } -%>
  Apply-OxyStyleEvent $PlotModel $Style "BeforeRendering" $MyInvocation

<% if ($output -match "Show-OxyPlot|New-OxyPlotModel") { -%>
  $windowOptions = @{
    Title = $MyInvocation.Line
  }

  <% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "System.Windows.Window" -Indent 4 -VariableName windowOptions -OptionHashName WOptions -Prefix W -%>

  if ($Reuse) {
    $w = Get-OxyWindow
  }
  else {
    $w = New-WpfWindow -Options $windowOptions
  }

  Invoke-WpfWindowAction $w {
    if ($Reuse) {
      foreach ($key in $windowOptions.Keys) {
        $w.$key = $windowOptions[$key]
      }
    }

    [void]$w.Activate()

    $view = New-Object OxyPlot.Wpf.PlotView
    $view.Model = $PlotModel

    $g = New-Object Windows.Controls.Grid
    [void]$g.Children.Add($view)
    $w.Content = $g
  }
<%   if ($output -match "New-OxyPlotModel") { -%>

  $PlotModel
<%   } -%>
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
