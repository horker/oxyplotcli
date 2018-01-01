Set-StrictMode -Version 3

$script:WindowList = New-Object Collections.Generic.List[object]

############################################################

function Test-WindowClosed {
  param(
    [System.Windows.Window]$Window
  )

  # ref.
  # http://stackoverflow.com/questions/381973/how-do-you-tell-if-a-wpf-window-is-closed

  $pi = [Windows.Window].GetProperty("IsDisposed",
    [Reflection.BindingFlags]::NonPublic -bor [Reflection.BindingFlags]::Instance)
  $pi.GetValue($Window)
}

############################################################

function New-OxyWindow {
  [cmdletbinding()]
  param(
    [OxyPlot.PlotModel]$Model,
    #### Replace with: @{ OutputType = "param"; ClassName = "System.Windows.Window" }
    [bool]$AllowDrop,
    [bool]$AllowsTransparency,
    [System.Windows.Media.Brush]$Background,
    [System.Windows.Data.BindingGroup]$BindingGroup,
    [System.Windows.Media.Effects.BitmapEffect]$BitmapEffect,
    [System.Windows.Media.Effects.BitmapEffectInput]$BitmapEffectInput,
    [System.Windows.Media.Brush]$BorderBrush,
    [System.Windows.Thickness]$BorderThickness,
    [System.Windows.Media.CacheMode]$CacheMode,
    [System.Windows.Media.Geometry]$Clip,
    [bool]$ClipToBounds,
    [System.Object]$Content,
    [string]$ContentStringFormat,
    [System.Windows.DataTemplate]$ContentTemplate,
    [System.Windows.Controls.DataTemplateSelector]$ContentTemplateSelector,
    [System.Windows.Controls.ContextMenu]$ContextMenu,
    [System.Windows.Input.Cursor]$Cursor,
    [System.Object]$DataContext,
    [System.Nullable[bool]]$DialogResult,
    [System.Windows.Media.Effects.Effect]$Effect,
    [System.Windows.FlowDirection]$FlowDirection,
    [bool]$Focusable,
    [System.Windows.Style]$FocusVisualStyle,
    [System.Windows.Media.FontFamily]$FontFamily,
    [double]$FontSize,
    [System.Windows.FontStretch]$FontStretch,
    [System.Windows.FontStyle]$FontStyle,
    [System.Windows.FontWeight]$FontWeight,
    [bool]$ForceCursor,
    [System.Windows.Media.Brush]$Foreground,
    [double]$Height,
    [System.Windows.HorizontalAlignment]$HorizontalAlignment,
    [System.Windows.HorizontalAlignment]$HorizontalContentAlignment,
    [System.Windows.Media.ImageSource]$Icon,
    [System.Windows.Input.InputScope]$InputScope,
    [bool]$IsEnabled,
    [bool]$IsHitTestVisible,
    [bool]$IsManipulationEnabled,
    [bool]$IsTabStop,
    [System.Windows.Markup.XmlLanguage]$Language,
    [System.Windows.Media.Transform]$LayoutTransform,
    [double]$Left,
    [System.Windows.Thickness]$Margin,
    [double]$MaxHeight,
    [double]$MaxWidth,
    [double]$MinHeight,
    [double]$MinWidth,
    [string]$Name,
    [double]$Opacity,
    [System.Windows.Media.Brush]$OpacityMask,
    [bool]$OverridesDefaultStyle,
    [System.Windows.Window]$Owner,
    [System.Windows.Thickness]$Padding,
    [System.Windows.Size]$RenderSize,
    [System.Windows.Media.Transform]$RenderTransform,
    [System.Windows.Point]$RenderTransformOrigin,
    [System.Windows.ResizeMode]$ResizeMode,
    [System.Windows.ResourceDictionary]$Resources,
    [bool]$ShowActivated,
    [bool]$ShowInTaskbar,
    [System.Windows.SizeToContent]$SizeToContent,
    [bool]$SnapsToDevicePixels,
    [System.Windows.Style]$Style,
    [int]$TabIndex,
    [System.Object]$Tag,
    [System.Windows.Shell.TaskbarItemInfo]$TaskbarItemInfo,
    [System.Windows.Controls.ControlTemplate]$Template,
    [string]$Title,
    [System.Object]$ToolTip,
    [double]$Top,
    [bool]$Topmost,
    [string]$Uid,
    [bool]$UseLayoutRounding,
    [System.Windows.VerticalAlignment]$VerticalAlignment,
    [System.Windows.VerticalAlignment]$VerticalContentAlignment,
    [System.Windows.Visibility]$Visibility,
    [double]$Width,
    [System.Windows.WindowStartupLocation]$WindowStartupLocation,
    [System.Windows.WindowState]$WindowState,
    [System.Windows.WindowStyle]$WindowStyle,
    #### To here
    [hashtable]$Options = @{}
  )

  $OptionHash = @{ Title = "OxyPlot CLI" }

  #### Replace with: @{ OutputType = "assign"; ClassName = "System.Windows.Window";  VariableName = "OptionHash"; OptionHashName = "Options" }
  if ($PSBoundParameters.ContainsKey('AllowDrop')) { $OptionHash.AllowDrop = $AllowDrop }
  if ($PSBoundParameters.ContainsKey('AllowsTransparency')) { $OptionHash.AllowsTransparency = $AllowsTransparency }
  if ($PSBoundParameters.ContainsKey('Background')) { $OptionHash.Background = $Background }
  if ($PSBoundParameters.ContainsKey('BindingGroup')) { $OptionHash.BindingGroup = $BindingGroup }
  if ($PSBoundParameters.ContainsKey('BitmapEffect')) { $OptionHash.BitmapEffect = $BitmapEffect }
  if ($PSBoundParameters.ContainsKey('BitmapEffectInput')) { $OptionHash.BitmapEffectInput = $BitmapEffectInput }
  if ($PSBoundParameters.ContainsKey('BorderBrush')) { $OptionHash.BorderBrush = $BorderBrush }
  if ($PSBoundParameters.ContainsKey('BorderThickness')) { $OptionHash.BorderThickness = $BorderThickness }
  if ($PSBoundParameters.ContainsKey('CacheMode')) { $OptionHash.CacheMode = $CacheMode }
  if ($PSBoundParameters.ContainsKey('Clip')) { $OptionHash.Clip = $Clip }
  if ($PSBoundParameters.ContainsKey('ClipToBounds')) { $OptionHash.ClipToBounds = $ClipToBounds }
  if ($PSBoundParameters.ContainsKey('Content')) { $OptionHash.Content = $Content }
  if ($PSBoundParameters.ContainsKey('ContentStringFormat')) { $OptionHash.ContentStringFormat = $ContentStringFormat }
  if ($PSBoundParameters.ContainsKey('ContentTemplate')) { $OptionHash.ContentTemplate = $ContentTemplate }
  if ($PSBoundParameters.ContainsKey('ContentTemplateSelector')) { $OptionHash.ContentTemplateSelector = $ContentTemplateSelector }
  if ($PSBoundParameters.ContainsKey('ContextMenu')) { $OptionHash.ContextMenu = $ContextMenu }
  if ($PSBoundParameters.ContainsKey('Cursor')) { $OptionHash.Cursor = $Cursor }
  if ($PSBoundParameters.ContainsKey('DataContext')) { $OptionHash.DataContext = $DataContext }
  if ($PSBoundParameters.ContainsKey('DialogResult')) { $OptionHash.DialogResult = $DialogResult }
  if ($PSBoundParameters.ContainsKey('Effect')) { $OptionHash.Effect = $Effect }
  if ($PSBoundParameters.ContainsKey('FlowDirection')) { $OptionHash.FlowDirection = $FlowDirection }
  if ($PSBoundParameters.ContainsKey('Focusable')) { $OptionHash.Focusable = $Focusable }
  if ($PSBoundParameters.ContainsKey('FocusVisualStyle')) { $OptionHash.FocusVisualStyle = $FocusVisualStyle }
  if ($PSBoundParameters.ContainsKey('FontFamily')) { $OptionHash.FontFamily = $FontFamily }
  if ($PSBoundParameters.ContainsKey('FontSize')) { $OptionHash.FontSize = $FontSize }
  if ($PSBoundParameters.ContainsKey('FontStretch')) { $OptionHash.FontStretch = $FontStretch }
  if ($PSBoundParameters.ContainsKey('FontStyle')) { $OptionHash.FontStyle = $FontStyle }
  if ($PSBoundParameters.ContainsKey('FontWeight')) { $OptionHash.FontWeight = $FontWeight }
  if ($PSBoundParameters.ContainsKey('ForceCursor')) { $OptionHash.ForceCursor = $ForceCursor }
  if ($PSBoundParameters.ContainsKey('Foreground')) { $OptionHash.Foreground = $Foreground }
  if ($PSBoundParameters.ContainsKey('Height')) { $OptionHash.Height = $Height }
  if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) { $OptionHash.HorizontalAlignment = $HorizontalAlignment }
  if ($PSBoundParameters.ContainsKey('HorizontalContentAlignment')) { $OptionHash.HorizontalContentAlignment = $HorizontalContentAlignment }
  if ($PSBoundParameters.ContainsKey('Icon')) { $OptionHash.Icon = $Icon }
  if ($PSBoundParameters.ContainsKey('InputScope')) { $OptionHash.InputScope = $InputScope }
  if ($PSBoundParameters.ContainsKey('IsEnabled')) { $OptionHash.IsEnabled = $IsEnabled }
  if ($PSBoundParameters.ContainsKey('IsHitTestVisible')) { $OptionHash.IsHitTestVisible = $IsHitTestVisible }
  if ($PSBoundParameters.ContainsKey('IsManipulationEnabled')) { $OptionHash.IsManipulationEnabled = $IsManipulationEnabled }
  if ($PSBoundParameters.ContainsKey('IsTabStop')) { $OptionHash.IsTabStop = $IsTabStop }
  if ($PSBoundParameters.ContainsKey('Language')) { $OptionHash.Language = $Language }
  if ($PSBoundParameters.ContainsKey('LayoutTransform')) { $OptionHash.LayoutTransform = $LayoutTransform }
  if ($PSBoundParameters.ContainsKey('Left')) { $OptionHash.Left = $Left }
  if ($PSBoundParameters.ContainsKey('Margin')) { $OptionHash.Margin = $Margin }
  if ($PSBoundParameters.ContainsKey('MaxHeight')) { $OptionHash.MaxHeight = $MaxHeight }
  if ($PSBoundParameters.ContainsKey('MaxWidth')) { $OptionHash.MaxWidth = $MaxWidth }
  if ($PSBoundParameters.ContainsKey('MinHeight')) { $OptionHash.MinHeight = $MinHeight }
  if ($PSBoundParameters.ContainsKey('MinWidth')) { $OptionHash.MinWidth = $MinWidth }
  if ($PSBoundParameters.ContainsKey('Name')) { $OptionHash.Name = $Name }
  if ($PSBoundParameters.ContainsKey('Opacity')) { $OptionHash.Opacity = $Opacity }
  if ($PSBoundParameters.ContainsKey('OpacityMask')) { $OptionHash.OpacityMask = $OpacityMask }
  if ($PSBoundParameters.ContainsKey('OverridesDefaultStyle')) { $OptionHash.OverridesDefaultStyle = $OverridesDefaultStyle }
  if ($PSBoundParameters.ContainsKey('Owner')) { $OptionHash.Owner = $Owner }
  if ($PSBoundParameters.ContainsKey('Padding')) { $OptionHash.Padding = $Padding }
  if ($PSBoundParameters.ContainsKey('RenderSize')) { $OptionHash.RenderSize = $RenderSize }
  if ($PSBoundParameters.ContainsKey('RenderTransform')) { $OptionHash.RenderTransform = $RenderTransform }
  if ($PSBoundParameters.ContainsKey('RenderTransformOrigin')) { $OptionHash.RenderTransformOrigin = $RenderTransformOrigin }
  if ($PSBoundParameters.ContainsKey('ResizeMode')) { $OptionHash.ResizeMode = $ResizeMode }
  if ($PSBoundParameters.ContainsKey('Resources')) { $OptionHash.Resources = $Resources }
  if ($PSBoundParameters.ContainsKey('ShowActivated')) { $OptionHash.ShowActivated = $ShowActivated }
  if ($PSBoundParameters.ContainsKey('ShowInTaskbar')) { $OptionHash.ShowInTaskbar = $ShowInTaskbar }
  if ($PSBoundParameters.ContainsKey('SizeToContent')) { $OptionHash.SizeToContent = $SizeToContent }
  if ($PSBoundParameters.ContainsKey('SnapsToDevicePixels')) { $OptionHash.SnapsToDevicePixels = $SnapsToDevicePixels }
  if ($PSBoundParameters.ContainsKey('Style')) { $OptionHash.Style = $Style }
  if ($PSBoundParameters.ContainsKey('TabIndex')) { $OptionHash.TabIndex = $TabIndex }
  if ($PSBoundParameters.ContainsKey('Tag')) { $OptionHash.Tag = $Tag }
  if ($PSBoundParameters.ContainsKey('TaskbarItemInfo')) { $OptionHash.TaskbarItemInfo = $TaskbarItemInfo }
  if ($PSBoundParameters.ContainsKey('Template')) { $OptionHash.Template = $Template }
  if ($PSBoundParameters.ContainsKey('Title')) { $OptionHash.Title = $Title }
  if ($PSBoundParameters.ContainsKey('ToolTip')) { $OptionHash.ToolTip = $ToolTip }
  if ($PSBoundParameters.ContainsKey('Top')) { $OptionHash.Top = $Top }
  if ($PSBoundParameters.ContainsKey('Topmost')) { $OptionHash.Topmost = $Topmost }
  if ($PSBoundParameters.ContainsKey('Uid')) { $OptionHash.Uid = $Uid }
  if ($PSBoundParameters.ContainsKey('UseLayoutRounding')) { $OptionHash.UseLayoutRounding = $UseLayoutRounding }
  if ($PSBoundParameters.ContainsKey('VerticalAlignment')) { $OptionHash.VerticalAlignment = $VerticalAlignment }
  if ($PSBoundParameters.ContainsKey('VerticalContentAlignment')) { $OptionHash.VerticalContentAlignment = $VerticalContentAlignment }
  if ($PSBoundParameters.ContainsKey('Visibility')) { $OptionHash.Visibility = $Visibility }
  if ($PSBoundParameters.ContainsKey('Width')) { $OptionHash.Width = $Width }
  if ($PSBoundParameters.ContainsKey('WindowStartupLocation')) { $OptionHash.WindowStartupLocation = $WindowStartupLocation }
  if ($PSBoundParameters.ContainsKey('WindowState')) { $OptionHash.WindowState = $WindowState }
  if ($PSBoundParameters.ContainsKey('WindowStyle')) { $OptionHash.WindowStyle = $WindowStyle }
  foreach ($key in $Options.Keys) {
    $OptionHash.$key = $Options[$key]
  }
  #### To here

  $w = New-WpfWindow -Options $OptionHash

  Invoke-WpfWindowAction $w {
    $view = New-Object OxyPlot.Wpf.PlotView
    $view.Model = $Model

    $g = New-Object Windows.Controls.Grid
    $g.Children.Add($view)
    $w.Content = $g
  }

  $script:WindowList.Add([pscustomobject]@{
    Window = $w
    PlotModel = $Model
  })

  $w
}

function Close-OxytWindow {
  [cmdletbinding()]
  param(
    [int]$Index = -1
  )

  $list = Get-OxyWindowList
  if ($Index = -1) {
    $Index = $list.Count - 1
  }
  $w = $list[$Index].Window
  Close-WpfWindow $w

  $sciprt:WindowList.RemoveAt($Index)
}

function Get-OxyWindow {
  [cmdletbinding()]
  param(
    [int]$Index = -1
  )

  $list = Get-OxyWindowList
  if ($list.Count -eq 0) {
    Write-Error "No active OxyPlot windows"
    return
  }

  if ($Index = -1) {
    $Index = $list.Count - 1
  }

  if ($Index -lt 0 -or $list.Count -le $Index) {
    Write-Error "Window index out of range"
    return
  }

  $list[$Index]
}

function Get-OxyWindowList {
  [cmdletbinding()]
  param()

  Update-OxyWindowList
  ,$script:WindowList
}

function Update-OxyWindowList {
  [cmdletbinding()]
  param()

  [void]$script:WindowList.RemoveAll({ Test-WindowClosed $args[0].Window })
}
