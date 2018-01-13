Set-StrictMode -Version 3

$source = ".\source\source\source\Examples\ExampleLibrary\"

$examples =
  ls -rec -filter *.cs $source |
  where { $_ -notmatch "Issues|Discussions" } |
  sls '\[Example\([''"](.+)[''"]\)\]'

foreach ($e in $examples) {
  $location = $e.Path -replace '^.+\\ExampleLibrary\\', ''
  $file = $e.Matches.Groups[1].Value -replace '[\\/:<>]', '_' -replace "$", ".ps1"
  $path = Join-Path $location $file
  $path
  mkdir ("examples\\" + $location) -Force
  New-Item -Type file ("examples\\" + $path) -Force
}
