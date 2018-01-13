$model = New-OxyPlotModel -Title "Tool tips" `
  -Axis (New-OxyLinearAxis -Position Bottom),
        (New-OxyLinearAxis -Position Left)

$anno1 = New-OxyLineAnnotation -Slope 0.1 -Intercept 1 -Text "LineAnnotation" -ToolTip "This is a tool tip for the LineAnnotation"

$anno2 = New-OxyRectangleAnnotation -MinimumX 20 -MaximumX 70 -MinimumY 10 -MaximumY 40 -TextRotation 10 -Text "RectangleAnnotation" -ToolTip "This is a tooltip for the RectangleAnnotation" -Fill Blue-40 -Stroke Black -StrokeThickness 2

$anno3 = New-OxyEllipseAnnotation -X 20 -Y 60 -Width 20 -Height 15 -Text "EllipseAnnotation" -ToolTip "This is a tool tip for the EllipseAnnotation" -TextRotation 10 -Fill Green-40 -Stroke Black -StrokeThickness 2

$anno4 = New-OxyPointAnnotation -X 50 -Y 50 -Text "P1" -ToolTip "This is a tool tip for the PointAnnotation"

$anno5 = New-OxyArrowAnnotation -StartPoint (New-OxyDataPoint 8 4) -EndPoint (New-OxyDataPoint 0 0) -Color Green -Text "ArrowAnnotation" -ToolTip "This is a tool tip for the ArrowAnnotation"

$anno6 = New-OxyTextAnnotation -TextPosition (New-OxyDataPoint 60 60) -Text "TextAnnotation" -ToolTip "This is a tool tip for the TextAnnotation"

$model.Annotations.Add($anno1)
$model.Annotations.Add($anno2)
$model.Annotations.Add($anno3)
$model.Annotations.Add($anno4)
$model.Annotations.Add($anno5)
$model.Annotations.Add($anno6)

$model
