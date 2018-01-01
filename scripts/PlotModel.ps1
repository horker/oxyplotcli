Set-StrictMode -Version 3

function New-OxyPlotModel {
  [cmdletbinding()]
  param(
    [OxyPlot.Series.Series[]]$Series,
    [string]$StyleName,
    #### Replace with: @{ OutputType = "param"; ClassName = "OxyPlot.PlotModel" }
    [double]$AxisTierDistance,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$Background,
    [cultureinfo]$Culture,
    [System.Collections.Generic.IList[OxyPlot.OxyColor]]$DefaultColors,
    [string]$DefaultFont,
    [double]$DefaultFontSize,
    [bool]$IsLegendVisible,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$LegendBackground,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$LegendBorder,
    [double]$LegendBorderThickness,
    [double]$LegendColumnSpacing,
    [string]$LegendFont,
    [double]$LegendFontSize,
    [double]$LegendFontWeight,
    [OxyPlot.HorizontalAlignment]$LegendItemAlignment,
    [OxyPlot.LegendItemOrder]$LegendItemOrder,
    [double]$LegendItemSpacing,
    [double]$LegendLineSpacing,
    [double]$LegendMargin,
    [double]$LegendMaxHeight,
    [double]$LegendMaxWidth,
    [OxyPlot.LegendOrientation]$LegendOrientation,
    [double]$LegendPadding,
    [OxyPlot.LegendPlacement]$LegendPlacement,
    [OxyPlot.LegendPosition]$LegendPosition,
    [double]$LegendSymbolLength,
    [double]$LegendSymbolMargin,
    [OxyPlot.LegendSymbolPlacement]$LegendSymbolPlacement,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$LegendTextColor,
    [string]$LegendTitle,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$LegendTitleColor,
    [string]$LegendTitleFont,
    [double]$LegendTitleFontSize,
    [double]$LegendTitleFontWeight,
    [OxyPlot.OxyThickness]$Padding,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$PlotAreaBackground,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$PlotAreaBorderColor,
    [OxyPlot.OxyThickness]$PlotAreaBorderThickness,
    [OxyPlot.OxyThickness]$PlotMargins,
    [OxyPlot.PlotType]$PlotType,
    [System.Func[OxyPlot.IRenderContext,OxyPlot.IRenderContext]]$RenderingDecorator,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$SelectionColor,
    [string]$Subtitle,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$SubtitleColor,
    [string]$SubtitleFont,
    [double]$SubtitleFontSize,
    [double]$SubtitleFontWeight,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$TextColor,
    [string]$Title,
    [ValidatePattern('white|whitesmoke|gainsboro|lightgrey|silver|darkgray|gray|dimgray|black|snow|lightcoral|rosybrown|indianred|red|firebrick|brown|darkred|maroon|mistyrose|salmon|tomato|darksalmon|lightsalmon|coral|orangered|sienna|seashell|chocolate|saddlebrown|sandybrown|peachpuff|linen|peru|bisque|darkorange|antiquewhite|burlywood|tan|blanchedalmond|navajowhite|papayawhip|moccasin|oldlace|wheat|orange|floralwhite|darkgoldenrod|goldenrod|cornsilk|gold|lemonchiffon|palegoldenrod|khaki|darkkhaki|ivory|lightyellow|beige|lightgoldenrodyellow|yellow|olive|yellowgreen|olivedrab|darkolivegreen|greenyellow|chartreuse|lawngreen|honeydew|palegreen|lightgreen|darkseagreen|lime|limegreen|forestgreen|green|darkgreen|mediumseagreen|seagreen|mintcream|springgreen|mediumaquamarine|turquoise|lightseagreen|mediumturquoise|mediumspringgreen|aquamarine|azure|lightcyan|paleturquoise|cyan|aqua|darkcyan|teal|darkslategray|cadetblue|darkturquoise|powderblue|lightblue|deepskyblue|skyblue|lightskyblue|steelblue|aliceblue|dodgerblue|lightslategray|slategray|lightsteelblue|cornflowerblue|royalblue|ghostwhite|lavender|blue|mediumblue|darkblue|midnightblue|navy|mediumslateblue|slateblue|darkslateblue|mediumpurple|blueviolet|indigo|darkorchid|darkviolet|mediumorchid|thistle|plum|violet|magenta|fuchsia|darkmagenta|purple|orchid|mediumvioletred|deeppink|hotpink|lavenderblush|palevioletred|crimson|pink|lightpink|transparent|(#?[0-9a-f]{1,8})')][string]$TitleColor,
    [string]$TitleFont,
    [double]$TitleFontSize,
    [double]$TitleFontWeight,
    [OxyPlot.TitleHorizontalAlignment]$TitleHorizontalAlignment,
    [double]$TitlePadding,
    [string]$TitleToolTip,
    #### To here
    [hashtable]$Option = @{}
  )

  $model = New-Object OxyPlot.PlotModel
  foreach ($s in $Series) {
    $model.Series.Add($s)
  }

#  Apply-Style "PlotModel" $model $MyInvocation $StyleName

  #### Replace with: @{ OutputType = "assign"; ClassName = "OxyPlot.PlotModel";  VariableName = "model"; OptionHashName = "Option" }
  if ($PSBoundParameters.ContainsKey('AxisTierDistance')) { $model.AxisTierDistance = $AxisTierDistance }
  if ($PSBoundParameters.ContainsKey('Background')) { $model.Background = New-OxyColor $Background }
  if ($PSBoundParameters.ContainsKey('Culture')) { $model.Culture = $Culture }
  if ($PSBoundParameters.ContainsKey('DefaultColors')) { $model.DefaultColors = $DefaultColors }
  if ($PSBoundParameters.ContainsKey('DefaultFont')) { $model.DefaultFont = $DefaultFont }
  if ($PSBoundParameters.ContainsKey('DefaultFontSize')) { $model.DefaultFontSize = $DefaultFontSize }
  if ($PSBoundParameters.ContainsKey('IsLegendVisible')) { $model.IsLegendVisible = $IsLegendVisible }
  if ($PSBoundParameters.ContainsKey('LegendBackground')) { $model.LegendBackground = New-OxyColor $LegendBackground }
  if ($PSBoundParameters.ContainsKey('LegendBorder')) { $model.LegendBorder = New-OxyColor $LegendBorder }
  if ($PSBoundParameters.ContainsKey('LegendBorderThickness')) { $model.LegendBorderThickness = $LegendBorderThickness }
  if ($PSBoundParameters.ContainsKey('LegendColumnSpacing')) { $model.LegendColumnSpacing = $LegendColumnSpacing }
  if ($PSBoundParameters.ContainsKey('LegendFont')) { $model.LegendFont = $LegendFont }
  if ($PSBoundParameters.ContainsKey('LegendFontSize')) { $model.LegendFontSize = $LegendFontSize }
  if ($PSBoundParameters.ContainsKey('LegendFontWeight')) { $model.LegendFontWeight = $LegendFontWeight }
  if ($PSBoundParameters.ContainsKey('LegendItemAlignment')) { $model.LegendItemAlignment = $LegendItemAlignment }
  if ($PSBoundParameters.ContainsKey('LegendItemOrder')) { $model.LegendItemOrder = $LegendItemOrder }
  if ($PSBoundParameters.ContainsKey('LegendItemSpacing')) { $model.LegendItemSpacing = $LegendItemSpacing }
  if ($PSBoundParameters.ContainsKey('LegendLineSpacing')) { $model.LegendLineSpacing = $LegendLineSpacing }
  if ($PSBoundParameters.ContainsKey('LegendMargin')) { $model.LegendMargin = $LegendMargin }
  if ($PSBoundParameters.ContainsKey('LegendMaxHeight')) { $model.LegendMaxHeight = $LegendMaxHeight }
  if ($PSBoundParameters.ContainsKey('LegendMaxWidth')) { $model.LegendMaxWidth = $LegendMaxWidth }
  if ($PSBoundParameters.ContainsKey('LegendOrientation')) { $model.LegendOrientation = $LegendOrientation }
  if ($PSBoundParameters.ContainsKey('LegendPadding')) { $model.LegendPadding = $LegendPadding }
  if ($PSBoundParameters.ContainsKey('LegendPlacement')) { $model.LegendPlacement = $LegendPlacement }
  if ($PSBoundParameters.ContainsKey('LegendPosition')) { $model.LegendPosition = $LegendPosition }
  if ($PSBoundParameters.ContainsKey('LegendSymbolLength')) { $model.LegendSymbolLength = $LegendSymbolLength }
  if ($PSBoundParameters.ContainsKey('LegendSymbolMargin')) { $model.LegendSymbolMargin = $LegendSymbolMargin }
  if ($PSBoundParameters.ContainsKey('LegendSymbolPlacement')) { $model.LegendSymbolPlacement = $LegendSymbolPlacement }
  if ($PSBoundParameters.ContainsKey('LegendTextColor')) { $model.LegendTextColor = New-OxyColor $LegendTextColor }
  if ($PSBoundParameters.ContainsKey('LegendTitle')) { $model.LegendTitle = $LegendTitle }
  if ($PSBoundParameters.ContainsKey('LegendTitleColor')) { $model.LegendTitleColor = New-OxyColor $LegendTitleColor }
  if ($PSBoundParameters.ContainsKey('LegendTitleFont')) { $model.LegendTitleFont = $LegendTitleFont }
  if ($PSBoundParameters.ContainsKey('LegendTitleFontSize')) { $model.LegendTitleFontSize = $LegendTitleFontSize }
  if ($PSBoundParameters.ContainsKey('LegendTitleFontWeight')) { $model.LegendTitleFontWeight = $LegendTitleFontWeight }
  if ($PSBoundParameters.ContainsKey('Padding')) { $model.Padding = $Padding }
  if ($PSBoundParameters.ContainsKey('PlotAreaBackground')) { $model.PlotAreaBackground = New-OxyColor $PlotAreaBackground }
  if ($PSBoundParameters.ContainsKey('PlotAreaBorderColor')) { $model.PlotAreaBorderColor = New-OxyColor $PlotAreaBorderColor }
  if ($PSBoundParameters.ContainsKey('PlotAreaBorderThickness')) { $model.PlotAreaBorderThickness = $PlotAreaBorderThickness }
  if ($PSBoundParameters.ContainsKey('PlotMargins')) { $model.PlotMargins = $PlotMargins }
  if ($PSBoundParameters.ContainsKey('PlotType')) { $model.PlotType = $PlotType }
  if ($PSBoundParameters.ContainsKey('RenderingDecorator')) { $model.RenderingDecorator = $RenderingDecorator }
  if ($PSBoundParameters.ContainsKey('SelectionColor')) { $model.SelectionColor = New-OxyColor $SelectionColor }
  if ($PSBoundParameters.ContainsKey('Subtitle')) { $model.Subtitle = $Subtitle }
  if ($PSBoundParameters.ContainsKey('SubtitleColor')) { $model.SubtitleColor = New-OxyColor $SubtitleColor }
  if ($PSBoundParameters.ContainsKey('SubtitleFont')) { $model.SubtitleFont = $SubtitleFont }
  if ($PSBoundParameters.ContainsKey('SubtitleFontSize')) { $model.SubtitleFontSize = $SubtitleFontSize }
  if ($PSBoundParameters.ContainsKey('SubtitleFontWeight')) { $model.SubtitleFontWeight = $SubtitleFontWeight }
  if ($PSBoundParameters.ContainsKey('TextColor')) { $model.TextColor = New-OxyColor $TextColor }
  if ($PSBoundParameters.ContainsKey('Title')) { $model.Title = $Title }
  if ($PSBoundParameters.ContainsKey('TitleColor')) { $model.TitleColor = New-OxyColor $TitleColor }
  if ($PSBoundParameters.ContainsKey('TitleFont')) { $model.TitleFont = $TitleFont }
  if ($PSBoundParameters.ContainsKey('TitleFontSize')) { $model.TitleFontSize = $TitleFontSize }
  if ($PSBoundParameters.ContainsKey('TitleFontWeight')) { $model.TitleFontWeight = $TitleFontWeight }
  if ($PSBoundParameters.ContainsKey('TitleHorizontalAlignment')) { $model.TitleHorizontalAlignment = $TitleHorizontalAlignment }
  if ($PSBoundParameters.ContainsKey('TitlePadding')) { $model.TitlePadding = $TitlePadding }
  if ($PSBoundParameters.ContainsKey('TitleToolTip')) { $model.TitleToolTip = $TitleToolTip }
  foreach ($key in $Option.Keys) {
    $model.$key = $Option[$key]
  }
  #### To here

  $model
}

function Update-OxyPlotModel {
  [cmdletbinding()]
  param(
    [OxyPlot.PlotModel]$Model,
    [bool]$UpdateData = $true
  )
  $Model.InvalidatePlot($UpdateData)
}
