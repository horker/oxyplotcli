[cmdletbinding()]
param(
  [string]$InPath,
  [string]$OutPath
)

$files = Get-ChildItem -Recurse $InPath -Filter *.ps1 |
  where { $_.Length -gt 0 }

foreach ($f in $files) {
  Write-Host $f.FullName

  $model = . ($f.FullName)

  $out = Join-Path $OutPath ($f.FullName -replace "^.+\\(.+)\\(.+)\.ps1$", "`$1 - `$2.png")

  $model | Save-OxyPlot -OutFile $out
}
