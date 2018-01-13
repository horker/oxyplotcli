[cmdletbinding()]
param(
  [string]$Path,
  [int]$Count = 16,
  [string]$SortKey = "LastWriteTime"
)

$files = Get-ChildItem $Path -Filter *.ps1 |
  where { $_.Length -gt 0 } |
  Sort LastWriteTime -Desc |
  Select -First $Count

$Count = @($files).Count

$columnCount = [math]::Ceiling([math]::Sqrt($Count))
$rowCount = [math]::Floor([math]::Sqrt($Count))

for (;;) {
  if ($columnCount * $rowCount -ge $Count) {
    break
  }
  ++$rowCount
  if ($columnCount * $rowCount -ge $Count) {
    break
  }
  ++$columnCount
}

$models = $files | foreach {
  Write-Host $_.FullName
  . ($_.FullName)
}

$w = New-OxyWindow -Title "Examples: $Path"
$views = Add-OxyPlotViewInGrid $w -Columns $columnCount -Rows $rowCount -PlotModel $models -ShowGridlines $true
