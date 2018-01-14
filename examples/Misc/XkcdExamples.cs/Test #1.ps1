New-OxyPlotModel `
  -Title "XKCD style plot" `
  -Subtitle "Install the 'Humor Sans' font for the best experience" `
  -RenderingDecorator { param($rc) New-Object OxyPlot.XkcdRenderingDecorator($rc) } `
  -Series (New-OxyFunctionSeries -F { [Math]::Sin($x) } -X0 0 -X1 10 -N 50 -Title "sin(x)")
