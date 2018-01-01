Add-Type -AssemblyName PresentationFramework

$script:windows = @{}

function New-WpfWindow {
  [cmdletbinding()]
  param(
    [string]$XamlString = '',
    [hashtable]$Options = @{}
  )

  $syncHash = [hashtable]::Synchronized(@{})

  if (!$XamlString.Length -eq 0) {
    $syncHash.Xaml = [xml]$XamlString
  }
  $syncHash.Error = $null
  $syncHash.Options = $Options

  # Runspace
  $runspace = [runspacefactory]::CreateRunspace()
  $runspace.ApartmentState = "STA"
  $runspace.ThreadOptions = "ReuseThread"
  $runspace.Open()
  $runspace.SessionStateProxy.SetVariable("syncHash", $syncHash)
  $syncHash.Runspace = $runspace

  # 同期
  $event = New-Object Threading.ManualResetEvent $false
  $syncHash.Event = $event

  $script = {
    # ウィンドウ生成
    if ($null -ne $syncHash.Xaml) {
      $reader = New-Object System.Xml.XmlNodeReader $syncHash.Xaml
      $window = [Windows.Markup.XamlReader]::Load($reader)
    }
    else {
      $window = New-Object Windows.Window
    }

    $options = $syncHash.Options
    foreach ($key in $options.Keys) {
      $window.$key = $options[$key]
    }

    $syncHash.Window = $window
    $syncHash.Event.Set()

    # 表示
    [void]$window.ShowDialog()
    $syncHash.Error = $Error
  }

  $ps = [PowerShell]::Create()
  $syncHash.PowerShell = $ps

  $ps.Runspace = $runspace
  [void]$ps.AddScript($script)
  $asyncResult = $ps.BeginInvoke()
  $syncHash.AsyncResult = $asyncResult

  [void]$event.WaitOne()
  $event.Dispose()

  $script:windows[$syncHash.Window] = $syncHash

  $syncHash.Window
}

function Close-WpfWindow {
  [cmdletbinding()]
  param(
    [Windows.Window]$Window
  )

  $syncHash = $script:windows[$Window]

  $Window.Dispatcher.InvokeShutdown()
  [void]$syncHash.PowerShell.EndInvoke($syncHash.AsyncResult)
  $syncHash.PowerShell.Dispose()
  $syncHash.Runspace.Close()
}

function Invoke-WpfWindowAction {
  [cmdletbinding()]
  param(
    [Windows.Window]$Window,
    [scriptblock]$Action
  )

  $Window.Dispatcher.Invoke($Action)
}
