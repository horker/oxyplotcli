Set-StrictMode -Version 3

Add-Type -AssemblyName PresentationFramework

$script:windowInfo = @{}
$script:runspacePool = $null
$script:event = $null

$script:openWindow = {
  param(
    [Hashtable]$info
  )

  if ($info["Xaml"].Length -gt 0) {
    $reader = New-Object System.Xml.XmlNodeReader [xml]$info["Xaml"]
    $window = [Windows.Markup.XamlReader]::Load($reader)
  }
  else {
    $window = New-Object Windows.Window
  }

  $options = $info["Options"]
  foreach ($key in $options.Keys) {
    $window.$key = $options[$key]
  }

  $info["Window"] = $window
  $info.Event.Set()

  $window.ShowDialog()
}

function New-WpfWindow {
  [cmdletbinding()]
  param(
    [string]$XamlString = '',
    [Hashtable]$Options = @{}
  )

  if ($null -eq $script:runspacePool) {
    $p = [RunspaceFactory]::CreateRunspacePool(1, 99)
    $p.ApartmentState = "STA"
    $p.ThreadOptions = "UseNewThread"
    $p.Open()
    $script:runspacePool = $p
    $script:event = New-Object Threading.ManualResetEvent $false
  }
  else {
    Refresh-WindowInfo
  }

  $info = [hashtable]::Synchronized(@{})
  $info["Xaml"] = $XamlString
  $info["Options"] = $Options
  $info["Event"] = $event

  $ps = [PowerShell]::Create("NewRunspace")
  $info["PowerShell"] = $ps

  $ps.RunspacePool = $script:runspacePool
  [void]$ps.AddScript($script:openWindow).AddParameter("info", $info)
  $info["AsyncResult"] = $ps.BeginInvoke()

  [void]$script:event.WaitOne()
  [void]$script:event.Reset()

  $script:windowInfo[$info["Window"]] = $info

  $info["Window"]
}

function Invoke-WpfWindowAction {
  [cmdletbinding()]
  param(
    [Windows.Window]$Window,
    [scriptblock]$Action
  )

  $Window.Dispatcher.Invoke($Action)
}

function Test-WpfWindowClosed {
  [cmdletbinding()]
  param(
    [Windows.Window]$Window
  )

  # ref.
  # http://stackoverflow.com/questions/381973/how-do-you-tell-if-a-wpf-window-is-closed

  $pi = [Windows.Window].GetProperty("IsDisposed",
    [Reflection.BindingFlags]::NonPublic -bor [Reflection.BindingFlags]::Instance)
  $closed = $pi.GetValue($Window)

  if ($closed) {
    Release-WpfWindowResource $Window -ErrorAction SilentlyContinue
  }

  $closed
}

function script:Release-WpfWindowResource {
  [cmdletbinding()]
  param(
    [Windows.Window]$Window
  )

  if (!$script:windowInfo.ContainsKey($window)) {
    Write-Error "No resource associated with the specified Window object"
    return
  }

  $info = $script:windowInfo[$Window]
  $script:windowInfo.Remove($Window)

  try {
    [void]$info["PowerShell"].EndInvoke($info["AsyncResult"])
  }
  catch {}
  finally {
    $info["PowerShell"].Dispose()
  }
}

function Close-WpfWindow {
  [cmdletbinding()]
  param(
    [Windows.Window]$Window
  )

  if (!(Test-WpfWindowClosed($Window))) {
    $Window.Dispatcher.InvokeShutdown()
    Release-WpfWindowResource $Window -ErrorAction SilentlyContinue
  }
}

function Get-WpfWindowList {
  [cmdletbinding()]
  param()

  Refresh-WindowInfo
  $script:windowInfo.Keys
}

function script:Refresh-WindowInfo {
  $windows = $script:windowInfo.Keys
  $array = New-Object Windows.Window[] $windows.Count
  $windows.CopyTo($array, 0)
  foreach ($w in $array) {
    if (Test-WpfWindowClosed $w) {
      Release-WpfWindowResource $w -ErrorAction SilentlyContinue
    }
  }
}
