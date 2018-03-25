Set-StrictMode -Version 3

$TYPES_WPF = [System.Windows.Window], [System.Windows.Controls.Grid]

$TYPES_OXYPLOT = [OxyPlot.PlotModel].Assembly.DefinedTypes |
  where { $_.IsPublic -and !$_.IsAbstract -and $_.FullName -match "(PlotModel|Series|Axis|Annotation)$" }

$TYPES_HORKER = [Horker.OxyPlotCli.Series.BoxPlotSeries].Assembly.DefinedTypes |
  where { $_.IsPublic -and !$_.IsAbstract -and $_.FullName -match "(PlotModel|Series|Axis|Annotation)$" }

$TYPES = $TYPES_WPF + $TYPES_OXYPLOT + $TYPES_HORKER

$TYPE_HASH = @{}

foreach ($t in $TYPES) {
  $TYPE_HASH[$t.FullName -replace "^(OxyPlot|Horker\.OxyPlotCli)\.((Series|Axes|Annotations)\.)?", ""] = $t
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
