Set-StrictMode -Version 3

$TYPES = [System.Windows.Window], [System.Windows.Controls.Grid]

$TYPES += [OxyPlot.PlotModel].Assembly.DefinedTypes |
  where { $_.IsPublic -and !$_.IsAbstract -and $_.FullName -match "(PlotModel|Series|Axis|Annotation)$" }

$TYPES = $TYPES | Sort FullName

$TYPE_HASH = @{}

foreach ($t in $TYPES) {
  $TYPE_HASH[$t.FullName -replace "^OxyPlot\.((Series|Axes|Annotations)\.)?", ""] = $t
}

$PROPERTY_HASH = @{}

foreach ($t in $TYPES) {
  $props = $t.GetProperties()
  $propHash = @{}
  foreach ($p in $props) {
    if ($p.CanWrite) {
      $propHash[$p.Name] = $p
    }
  }
  $PROPERTY_HASH[$t.FullName] = $propHash
}

$AXES_PROPERTY_HASH = @{}

foreach ($t in ($TYPES | where { $_.Name -match "Axis$" })) {
  $props = $t.GetProperties()
  foreach ($p in $props) {
    if ($p.CanWrite) {
      $AXES_PROPERTY_HASH[$p.Name] = $p
    }
  }
}
