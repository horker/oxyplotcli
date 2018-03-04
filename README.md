# OxyPlot CLI

OxyPlot CLI is a PowerShell module for using the [OxyPlot](http://www.oxyplot.org) library on commnad line.

OxyPlot CLI is designed for both interactive usage and complex, sophisticated visualization scripting. It supports all series, axes and annotations of OxyPlot.

OxyPlot CLI provides the 'style' feature. A style can apply a set of visual properties to the chart at once. Currently, one style named 'ggplot' is provided. You can define your own style.

## Installation

OxyPLot CLI is published in [PowerShell Gallery](https://www.powershellgallery.com).

```PowerShell
Install-Package oxyplotcli
```

## Usage

### Series, axis and annotation creation cmdlets

OxyPlot CLI provides cmdlets corresponding to series, axis and annotation classes in OxyPlot. By calling these cmdlets, you can create any object of the type that the cmdlet name suggests.

(TBD: aliases)

* Series cmdlets

  - New-OxyAreaSeries (class: OxyPlot.Series.AreaSeries)
  - New-OxyBarSeries (class: OxyPlot.Series.BarSeries)
  - New-OxyBoxPlotSeries (class: OxyPlot.Series.BoxPlotSeries)
  - New-OxyCandleStickAndVolumeSeries (class: OxyPlot.Series.CandleStickAndVolumeSeries)
  - New-OxyCandleStickSeries (class: OxyPlot.Series.CandleStickSeries)
  - New-OxyColumnSeries (class: OxyPlot.Series.ColumnSeries)
  - New-OxyContourSeries (class: OxyPlot.Series.ContourSeries)
  - New-OxyErrorColumnSeries (class: OxyPlot.Series.ErrorColumnSeries)
  - New-OxyFunctionSeries (class: OxyPlot.Series.FunctionSeries)
  - New-OxyHeatMapSeries (class: OxyPlot.Series.HeapMapSeries)
  - New-OxyHighLowSeries (class: OxyPlot.Series.HighLowSeries)
  - New-OxyIntervalBarSeries (class: OxyPlot.Series.IntervalBarSeries)
  - New-OxyLinearBarSeries (class: OxyPlot.Series.LinearBarSeries)
  - New-OxyLineSeries (class: OxyPlot.Series.LineSeries)
  - New-OxyPieSeries (class: OxyPlot.Series.PieSeries)
  - New-OxyRectangleBarSeries (class: OxyPlot.Series.RectangleBarSeries)
  - New-OxyScatterErrorSeries (class: OxyPlot.Series.ScatterErrorSeries)
  - New-OxyScatterSeries (class: OxyPlot.Series.ScatterSeries)
  - New-OxyStairStepSeries (class: OxyPlot.Series.StairStepSeries)
  - New-OxyStemSeries (class: OxyPlot.Series.StemSeries)
  - New-OxyThreeColorLineSeries (class: OxyPlot.Series.ThreeColorLineSeries)
  - New-OxyTornadoBarSeries (class: OxyPlot.Series.TornadoBarSeries)
  - New-OxyTwoColorAreaSeries (class: OxyPlot.Series.TwoColorAreaSeries)
  - New-OxyTwoColorLineSeries (class: OxyPlot.Series.TwoColorLineSeries)
  - New-OxyVolumeSeries (class: OxyPlot.Series.VolumeSeries)

* Axis cmdlets

  - New-OxyAngleAxis (class: OxyPlot.Axes.AngleAxis)
  - New-OxyCategoryAxis (class: OxyPlot.Axes.CategoryAxis)
  - New-OxyDateTimeAxis (class: OxyPlot.Axes.DateTimeAxis)
  - New-OxyLinearAxis (class: OxyPlot.Axes.LinearAxis)
  - New-OxyLinearColorAxis (class: OxyPlot.Axes.ColorAxis)
  - New-OxyLogarithmicAxis (class: OxyPlot.Axes.LogarithmicAxis)
  - New-OxyMagnitudeAxis (class: OxyPlot.Axes.MagnitudeAxis)
  - New-OxyRangeColorAxis (class: OxyPlot.Axes.RangeColorAxis)
  - New-OxyTimeSpanAxis (class: OxyPlot.Axes.TimeSpanAxis)

* Annotation cmdlets

  - New-OxyArrowAnnotation (class: OxyPlot.Annotations.ArrowAnnotation)
  - New-OxyEllipseAnnotation (class: OxyPlot.Annotations.EllipseAnnotation)
  - New-OxyFunctionAnnotation (class: OxyPlot.Annotations.FunctionAnnotation)
  - New-OxyImageAnnotation (class: OxyPlot.Annotations.ImageAnnotation)
  - New-OxyLineAnnotation (class: OxyPlot.Annotations.LineAnnotation)
  - New-OxyPointAnnotation (class: OxyPlot.Annotations.PointAnnotation)
  - New-OxyPolygonAnnotation (class: OxyPlot.Annotations.PolygonAnnotation)
  - New-OxyPolylineAnnotation (class: OxyPlot.Annotations.PolylineAnnotation)
  - New-OxyRectangleAnnotation (class: OxyPlot.Annotations.RectangleAnnotation)
  - New-OxyTextAnnotation (class: OxyPlot.Annotations.TextAnnotation)

#### Object properties to parameters

These cmdlets provide the parameters corresponding to the properties of the corresponding classes. With these parameters, you can set any property values of an object instance.

For example, the following script:

```PowerShell
$line = New-OxyLineSeries -Color red -LineStyle Dash
```

is equivalent to the following code in C#:
```C#
var line = new LineSeries();
line.Color = OxyColors.Red;
line.LineStyle = LineStyle.Dash;
```

Note: Several properties with non-scalar types are interpreted by the converters to help users express the values of such parameters on command line. The `Color` property is one example. (TBD: details)

#### Data points

Most of series objects need a set of a specific kind of data points (or items). For example, `LineSeries` takes data points containing the `X` and `Y` elements, and `PieSeries` takes items containing the `Label` and `Value` elements.

You can assign data points (or items) to a series object in two ways.

##### Direct assignment

Each cmdlet provides parameters with the names of the data point elements. You can provide a set of elements with these parameters.   For example, the `-X` and `-Y` parameters are defined in `New-OxyLineSeries`.

```PowerShell
$line = New-OxyLineSeries -X 1, 2, 3 -Y 21, 35, 17
```

The above code assigns three points (X, Y) = (1, 21) , (2, 35) and (3, 17) to a LineSeries object. Not to mention, the numbers of those elements should be the same.

##### Through pipeline

You can give a data source to a cmdlet through pipeline, and specify mappings between the data source and the data point elements by cmdlet parameters. The names of such parameters begin with element names, followed by `Name`.  For example, the `New-OxyLineSeries` cmdlet provides the `-XName` and `-YName` parameters.

```PowerShell
$data = Import-Csv datasets\iris.csv
$line = $data | New-OxyLineSeries -XName Sepal.Width -YName Sepal.Length
```
(`datasets\iris.csv` are installed in the same folder where the module is installed.)

### Plot model cmdlets

In OxyPlot, series, axes and annotations are aggregated to a plot model to form a chart. A plot model is represented by the `OxyPlot.PlotModel` class.

Several cmdlets are defined to create, manipulate, and display a chart based on a plot model.

#### Basic operations

The `New-OxyPlotModel` cmdlet is a basic cmdlet to create an `OxyPlot.PlotModel` object. The `Add-OxyObjectToPlotModel` cmdlet can be used to add series, axes and annotations to a plot model. The `Show-OxyPlot` cmdlet takes a PlotModel object through pipeline, opens a window and plot a chart based on the plot model.

```PowerShell
# Create a plot model
$model = New-OxyPlotModel

# Prepare series objects
$scatter = New-OxyScatterSeries
$axis = New-OxyLogarithmicAxis

# Add them to a plot model
Add-OxyObjectToPlotModel $scatter $model
Add-OxyObjectToPlotModel $axis $model

# Display a chart
$model | Show-OxyPlot
```

#### Short representations for command-line usage

The `New-OxyPlotModel` accepts `-Show` parameter to display a chart immediately.

```PowerShell
# An empty window appears
$model = New-OxyPlotModel -Show
```

In addition, object creation cmdlets, such as `New-OxyLineSeries`, provide the `-AddTo` parameter, which takes a plot model and adds a newly created object to it.  When the `-AddTo` parameter is specified, the cmdlet returns no object, and the chart is updated immediately.

```PowerShell
New-OxyLinearAxis -Position Bottom -AddTo $model
New-OxyScatterSeries -AddTo $model
```

By using these parameters, you can build up a chart in an interactive way.

As another way, you can give series objects as input objects of `New-OxyPlotModel` or `Show-OxyPlot`.

```PowerShell
$scatter = New-OxyScatterSeries
$line = New-OxyLineSeries

$model = $scatter, $line | New-OxyPlotModel
```

You can use `Show-OxyPlot` to plot a chart in one line, if you don't need OxyPlot objects later.

```PowerShell
oxyscat -X 1,2,3 -Y 4,5,6 | Show-OxyPlot
```

#### Saving a chart as an image file

The `Save-OxyPlot` cmdlet works in a similar way to `Show-OxyPlot`, but saves the chart to an image file.

```PowerShell
$model | Save-OxyPlot -OutFile chart.png -ImageWidth 800 -ImageHeight 600
```

This cmdlet defines several parameters specific to image files: `-OutFile`, `-ImageWidth`, `-ImageHeight`, or `-ImageBackground`.

#### Additional parameters

For convinience, several sets of parameters are defined in `New-OxyPlotModel`, `Show-OxyPlot` and `Save-OxyPlot`.

First, these cmdlets accept `OxyPlot.PlotModel` properties as parameters, like the other object creation cmdlets do. The following script creates a PlotModel object and sets the property `Title` to "Example Chart" (and plot a chart).

```PowerShell
$line | Show-OxyPlot -Title "Example Chart"
```

Secondly, they take a set of parameters that begin with `-Ax` or `-Ay`.

The `-AxType` parameter specifies an axis class name for the X-axis of the plot model.

It can recognize a partial name of a class. In the following example, the value `log` matches the class name `OxyPlot.Axes.LogarithmicAxis`, so that a log-scale axis will appear.

```PowerShell
$data = Import-Csv datasets\iris.csv
$data | oxyscat -XName Sepal.Width -YName Sepal.Length | Show-OxyPlot -AxType log
```

The other `-Ax` parameters correspond to the properties of the axis object, prefixed with `-Ax`. For example, `-AxTitle` sets the value of the `Title` property of the axis object.

The `-AyType` and the other `-Ay` parameters are the same for the Y-axis of the plot model.

## Advanced topics

### Grouping

All series creation cmdlets offer the `-Group`, `-GroupName`, `-GroupingKeys` parameters. These parameters are used to categorize the source data.

When the parameter `-Group` or `-GroupName` is given, the data is categorized based on the category data specified by `-Group`, or the column with the name specified by `-GroupName`. For each subset of the source data, a series object is created.

In the following example, a series object is created for each value in the `Species` column. Thus, several scatter points will appear in the single chart. When the color is not specified (automatic), each set of scatter points will be plotted in differenct colors.

```PowerShell
$data = Import-Csv datasets\iris.csv
$data | oxyscat -XName Sepal.Width -YName Sepal.Length -GroupName Species | Show-OxyPlot
```

(TBD: -GroupingKeys)

### Style

(TBD)

### Multiple charts and sharing axes

(TBD)

### Direct object manipulation

(TBD)

### Window manipulation

(TBD)

### Axis type selection

(TBD)

## License

Licensed under the MIT License, except the following:

The files in the `datasets` folder contains the contents obtained from the products of the R and ggplot2 projects. These files are subject to the license of the original products (GPL).

