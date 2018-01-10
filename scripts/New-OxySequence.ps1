Set-StrictMode -Version 3

function New-OxySequence {
  [cmdletbinding()]
  param(
    [double]$Begin,
    [double]$End,
    [double]$Step,
    [switch]$Exclusive = $false
  )

  if ($Exclusive) {
    for ($i = $Begin; $i -lt $End; $i += $Step) {
      $i
    }
  }
  else {
    for ($i = $Begin; $i -le $End; $i += $Step) {
      $i
    }
  }
}
