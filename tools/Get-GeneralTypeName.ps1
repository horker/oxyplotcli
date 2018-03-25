[cmdletbinding()]
param(
  [string]$TargetTypeName
)

. $PSScriptRoot\..\scripts\Parameter.ps1

Get-GeneralTypeName $TargetTypeName
