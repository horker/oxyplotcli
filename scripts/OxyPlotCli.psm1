Set-StrictMode -version 3

Import-Module $PSScriptRoot\WpfWindowCmdlets.dll
Import-Module $PSScriptRoot\OxyPlotCliHelpers.dll

Get-ChildItem $PSScriptRoot\*.ps1 | foreach { . $_.FullName }

Get-Item function:\New-Oxy*Series  | where { $_ -match "^New-Oxy(\w+)Series(\w*)$" } | foreach {
  $fullName = $matches[0]
  $series = $matches[1]
  $lseries = $series.ToLower()
  $suffix = $matches[2]

  Set-Alias "oxy$lseries$suffix" $fullName
}
