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

<% if ($output -match "Show-OxyPlot") { -%>
function Show-OxyPlot {
<% } else { -%>
function Save-OxyPlot {
<% } -%>
  [cmdletbinding()]
  param(
    [Parameter(ParameterSetName="PlotModel", ValueFromPipeline=$true)]
    [OxyPlot.PlotModel]$PlotModel,

    [Parameter(ParameterSetName="Series", ValueFromPipeline=$true)]
    [OxyPlot.Series.Series]$Series,

<% if ($output -match "Show-OxyPlot") { -%>
    [switch]$Reuse,
<% } else { -%>
    [Parameter(Position=0, Mandatory=$true)]
    [string]$OutFile,

    [double]$Width = 800,
    [double]$Height = 600,
    [string]$Background = "white",
    [bool]$IsDocument = $false,
<% } -%>

    [string]$StyleName,

    [OxyPlot.Axes.Axis[]]$Axes,

<% if ($output -match "Show-OxyPlot") { -%>
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "System.Windows.Window" -Indent 2 -VariableName w -OptionHashName WOptions -Prefix W -%>
    [hashtable]$WOptions = @{},
<% } -%>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName "OxyPlot.PlotModel" -Indent 4 -Prefix "M" -%>
    [hashtable]$MOptions = @{},

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
    if ($PSCmdlet.ParameterSetName -match "^Series") {
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

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.PlotModel" -Indent 2 -VariableName model -OptionHashName MOptions -Prefix M -%>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.Axes.Axis" -Indent 2 -VariableName ax -OptionHashName AxOptions -Prefix Ax -%>

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName "OxyPlot.Axes.Axis" -Indent 2 -VariableName ay -OptionHashName AyOptions -Prefix Ay -%>

<% if ($output -match "Show-OxyPlot") { -%>
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
    $view.Model = $model

    $g = New-Object Windows.Controls.Grid
    $g.Children.Add($view)
    $w.Content = $g
  }
<% } else { -%>
  $OutFile = try { Resolve-Path $OutFile -EA Stop } catch { $_.TargetObject }

  switch -regex ($OutFile) {
    "\.svg$" {
      $ex = New-Object OxyPlot.SvgExporter
      $ex.Width = $Width
      $ex.Height = $Height
      $ex.IsDocument = $IsDocument
      $ex.ExportToString($model) | Set-Content $OutFile
    }
    "\.pdf$" {
      $ex = New-Object OxyPlot.PdfExporter
      $ex.Width = $Width
      $ex.Height = $Height
      $ex.Background = New-OxyColor $Background

      $stream = [IO.File]::Create($OutFile)
      try {
        $ex.Export($model, $stream)
      }
      finally {
        $stream.Close()
      }
    }
    default { # Png
      $ex = New-Object OxyPlot.Wpf.PngExporter
      $ex.Width = $Width
      $ex.Height = $Height
      $ex.Background = New-OxyColor $Background

      $stream = [IO.File]::Create($OutFile)
      try {
        $ex.Export($model, $stream)
      }
      finally {
        $stream.Close()
      }
    }
  }
<% } -%>
}
}
