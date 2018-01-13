<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

function New-OxyFunctionSeries {
  [cmdletbinding()]
  param(
    [Parameter(ParameterSetName="Explicit-n")]
    [Parameter(ParameterSetName="Explicit-dx")]
    [scriptblock]$F,
    [Parameter(ParameterSetName="Explicit-n")]
    [Parameter(ParameterSetName="Explicit-dx")]
    [double]$X0,
    [Parameter(ParameterSetName="Explicit-n")]
    [Parameter(ParameterSetName="Explicit-dx")]
    [double]$X1,

    [Parameter(ParameterSetName="Implicit-n")]
    [Parameter(ParameterSetName="Implicit-dx")]
    [scriptblock]$Fx,
    [Parameter(ParameterSetName="Implicit-n")]
    [Parameter(ParameterSetName="Implicit-dx")]
    [scriptblock]$Fy,
    [Parameter(ParameterSetName="Implicit-n")]
    [Parameter(ParameterSetName="Implicit-dx")]
    [double]$T0,
    [Parameter(ParameterSetName="Implicit-n")]
    [Parameter(ParameterSetName="Implicit-dx")]
    [double]$T1,

    [Parameter(ParameterSetName="Explicit-n")]
    [Parameter(ParameterSetName="Implicit-n")]
    [double]$N,
    [Parameter(ParameterSetName="Explicit-dx")]
    [Parameter(ParameterSetName="Implicit-dx")]
    [Alias("Dt")]
    [double]$Dx,

    [string]$StyleName,

<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName OxyPlot.Series.FunctionSeries -Indent 4 -%>

    [hashtable]$Options = @{}
  )

  $series = New-Object OxyPlot.Series.FunctionSeries

  switch ($PSCmdlet.ParameterSetName) {
    "Explicit-n" {
      $Dx = ($X1 - $X0) / ($N - 1)
    }
    "Implicit-n" {
      $Dx = ($T1 - $T0) / ($N - 1)
    }
  }

  $va = New-Object Collections.Generic.List[Management.Automation.PSVariable]
  if ($PSCmdlet.ParameterSetName -eq "Explicit-n" -or
      $PSCmdlet.ParameterSetName -eq "Explicit-dx") {
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
    BottomAxisType = "linear"
    LeftAxisType = "linear"
    RightAxisType = "none"
  }

  $series | Add-Member -PassThru NoteProperty _Info $info
}
