<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

<#
<% ../tools/Insert-Help.ps1 $Document OxyPlot.Series.FunctionSeries -%>

<% # copied from the OxyPlot/Series/FunctionSeries.cs -%>
.PARAMETER F
The function f(x).

.PARAMETER X0
The start x value.

.PARAMETER X1
The end x value.

.PARAMETER  Fx
The function x(t).

.PARAMETER Fy
The function y(t).

.PARAMETER T0
The start t parameter.

.PARAMETER T1
The end t parameter.

.PARAMETER N
The number of points.

.PARAMETER Dx
The increment in x or t.

.PARAMETER Options
Sets properties of the object.

.PARAMETER Style
Sets a style of the object.

.PARAMETER AddTo
Specifies a plot model to which the object will be added.
#>
function New-OxyFunctionSeries {
  [cmdletbinding()]
  [OutputType([OxyPlot.Series.FunctionSeries])]
  param(
    [Parameter(ParameterSetName="Explicit", Position=0)]
    [scriptblock]$F,
    [Parameter(ParameterSetName="Explicit", Position=1)]
    [double]$X0,
    [Parameter(ParameterSetName="Explicit", Position=2)]
    [double]$X1,

    [Parameter(ParameterSetName="Implicit", Position=0)]
    [scriptblock]$Fx,
    [Parameter(ParameterSetName="Implicit", Position=1)]
    [scriptblock]$Fy,
    [Parameter(ParameterSetName="Implicit", Position=2)]
    [double]$T0,
    [Parameter(ParameterSetName="Implicit", Position=3)]
    [double]$T1,

    [double]$N = 100,

    [Alias("Dt")]
    [double]$Dx = [double]::NaN,

<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName OxyPlot.Series.FunctionSeries -Indent 4 -%>

    [hashtable]$Options = @{},

    [string]$Style = "default",
    [OxyPlot.PlotModel]$AddTo
  )

  if (!(Test-OxyStyleName $Style)) {
    Write-Error "Unknown style: '$Style'"
    return
  }

  $series = New-Object OxyPlot.Series.FunctionSeries

  if ([double]::IsNaN($Dx)) {
    if ($PSCmdlet.ParameterSetName -eq "Explicit") {
      $Dx = ($X1 - $X0) / ($N - 1)
    }
    else {
      $Dx = ($T1 - $T0) / ($N - 1)
    }
  }

  $va = New-Object Collections.Generic.List[Management.Automation.PSVariable]
  if ($PSCmdlet.ParameterSetName -eq "Explicit") {
    $va.Add((New-Object Management.Automation.PSVariable "x"))
    for ($i = $X0; $i -le $X1 + $Dx * 0.5; $i += $Dx) {
      $va[0].Value = $i
      $y = [double]($F.InvokeWithContext($null, $va, $null))[0]
      Add-OxyLineSeriesPoint $series $i $y
    }
  }
  else {
    $va.Add((New-Object Management.Automation.PSVariable "t"))
    for ($i = $T0; $i -le $T1 + $Dx * 0.5; $i += $Dx) {
      $va[0].Value = $i
      $x = [double]($Fx.InvokeWithContext($null, $va, $null))[0]
      $y = [double]($Fy.InvokeWithContext($null, $va, $null))[0]
      Add-OxyLineSeriesPoint $series $x $y
    }
  }

<% ..\tools\Insert-PropertyList.ps1 -OutputType "assign" -ClassName OxyPlot.Series.FunctionSeries -Indent 2 -VariableName series -OptionHashName Options -%>

  $info = [PSCustomObject]@{
    XAxisTitle = "x"
    YAxisTitle = "y"
    XDataType = [double]
    YDataType = [double]
    GroupName = $null
  }

  $series = $series | Add-Member -PassThru NoteProperty _Info $info

  Apply-OxyStyle $series $Style $MyInvocation

  if ($AddTo -ne $null) {
    Add-OxyObjectToPlotModel $series $AddTo
  }
  else {
    $series
  }
}
