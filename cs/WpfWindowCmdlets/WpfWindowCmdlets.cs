using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Windows;
using System.Windows.Markup;
using System.Windows.Media;
using System.Reflection;
using System.Windows.Interop;
using System.Runtime.InteropServices;

namespace WpfWindowCmdlets
{
    // Win32 API functions and constants to make a window invisible in the task switcher
    // ref.
    // https://social.msdn.microsoft.com/Forums/en-US/9c4ada92-5065-4abb-a295-d62e5ddaf2b1/wpf-window-is-showen-in-alttab-list-though-windowstylenone-showintaskbarfalse?forum=wpf

    class Win32Api
    {
        [Flags]
        public enum ExtendedWindowStyles
        {
            WS_EX_TOOLWINDOW = 0x00000080
        }

        public enum GetWindowLongFields
        {
            GWL_EXSTYLE = (-20)
        }

        [DllImport("kernel32.dll", EntryPoint = "SetLastError")]
        public static extern void SetLastError(int dwErrorCode);

        [DllImport("user32.dll")]
        public static extern IntPtr GetWindowLong(IntPtr hWnd, int nIndex);

        [DllImport("user32.dll", EntryPoint = "SetWindowLongPtr", SetLastError = true)]
        private static extern IntPtr IntSetWindowLongPtr(IntPtr hWnd, int nIndex, IntPtr dwNewLong);

        [DllImport("user32.dll", EntryPoint = "SetWindowLong", SetLastError = true)]
        private static extern Int32 IntSetWindowLong(IntPtr hWnd, int nIndex, Int32 dwNewLong);

        public static IntPtr SetWindowLong(IntPtr hWnd, int nIndex, IntPtr dwNewLong)
        {
            int error = 0;
            IntPtr result = IntPtr.Zero;
            // Win32 SetWindowLong doesn't clear error on success
            SetLastError(0);

            if (IntPtr.Size == 4) {
                // use SetWindowLong
                Int32 tempResult = IntSetWindowLong(hWnd, nIndex, IntPtrToInt32(dwNewLong));
                error = Marshal.GetLastWin32Error();
                result = new IntPtr(tempResult);
            }
            else {
                // use SetWindowLongPtr
                result = IntSetWindowLongPtr(hWnd, nIndex, dwNewLong);
                error = Marshal.GetLastWin32Error();
            }

            if ((result == IntPtr.Zero) && (error != 0)) {
                throw new System.ComponentModel.Win32Exception(error);
            }

            return result;
        }

        private static int IntPtrToInt32(IntPtr intPtr)
        {
            return unchecked((int)intPtr.ToInt64());
        }

        public static void MakeWindowInvisibleInTaskSwitcher(Window window)
        {
            WindowInteropHelper wndHelper = new WindowInteropHelper(window);

            int exStyle = (int)GetWindowLong(wndHelper.Handle, (int)GetWindowLongFields.GWL_EXSTYLE);

            exStyle |= (int)ExtendedWindowStyles.WS_EX_TOOLWINDOW;
            SetWindowLong(wndHelper.Handle, (int)GetWindowLongFields.GWL_EXSTYLE, (IntPtr)exStyle);
        }
    }

    public class Util
    {
        static private PropertyInfo IsDisposedMethod = typeof(Window).GetProperty("IsDisposed", BindingFlags.NonPublic | BindingFlags.Instance);

        static public bool IsWindowClosed(Window w)
        {
            return (bool)IsDisposedMethod.GetValue(w);
        }

        static public void OpenWindow(List<Window> result, AutoResetEvent e)
        {
            var window = new Window();
            window.AllowsTransparency = true;
            window.Background = Brushes.Transparent;
            window.WindowStyle = WindowStyle.None;
            window.ResizeMode = ResizeMode.NoResize;
            window.ShowInTaskbar = false;

            window.Loaded += (sender, args) => {
                Win32Api.MakeWindowInvisibleInTaskSwitcher((Window)sender);
            };

            result.Add(window);

            e.Set();

            window.ShowDialog();
        }
    }

    [Cmdlet("New", "WpfWindow")]
    public class OpenWpfWindow : PSCmdlet
    {
        [Parameter(Position = 0, Mandatory = false)]
        public string XamlString { get; set; }

        [Parameter(Position = 1, Mandatory = false)]
        public Hashtable Options { get; set; }

        static private Window _rootWindow;
        static private PowerShell _powerShell;

        private void OpenRootWindow()
        {
            if (_rootWindow != null) {
                if (!Util.IsWindowClosed(_rootWindow)) {
                    return;
                }
            }

            var runspace = RunspaceFactory.CreateRunspace();
            runspace.ApartmentState = ApartmentState.STA;
            runspace.ThreadOptions = PSThreadOptions.UseNewThread;
            runspace.Open();

            _powerShell = PowerShell.Create();
            _powerShell.Runspace = runspace;

            var result = new List<Window>();
            var e = new AutoResetEvent(false);

            _powerShell.AddScript(@"
                param($result, $event)
                [WpfWindowCmdlets.Util]::OpenWindow($result, $event)");
            _powerShell.AddParameter("result", result);
            _powerShell.AddParameter("event", e);

            _powerShell.BeginInvoke();

            e.WaitOne();

            _rootWindow = result[0];
        }

        protected override void EndProcessing()
        {
            Window window = null;

            OpenRootWindow();

            _rootWindow.Dispatcher.Invoke(() => {
                if (XamlString != null) {
                    window = (Window)XamlReader.Parse(XamlString);
                }
                else {
                    window = new Window();
                }

                var type = window.GetType();
                if (Options != null) {
                    foreach (DictionaryEntry entry in Options) {
                        var prop = type.GetProperty((string)entry.Key);
                        prop.SetValue(window, entry.Value);
                    }
                }

                window.Show();
            });


            GetWpfWindowList.WindowList.Add(window);

            WriteObject(window);
        }
    }

    [Cmdlet("Close", "WpfWindow")]
    public class CloseWpfWindow : PSCmdlet
    {
        [Parameter(Position = 0, Mandatory = true)]
        public Window Window { get; set; }

        protected override void EndProcessing()
        {
            Window.Dispatcher.InvokeShutdown();
        }
    }

    [Cmdlet("Invoke", "WpfWindowAction")]
    public class InvokeWpfWindowAction : PSCmdlet
    {
        [Parameter(Position = 0, Mandatory = true)]
        public Window Window { get; set; }

        [Parameter(Position = 1, Mandatory = true)]
        public ScriptBlock Action { get; set; }

        protected override void EndProcessing()
        {
            Window.Dispatcher.Invoke(() => {
                InvokeCommand.InvokeScript(false, Action, null);
            });
        }
    }

    [Cmdlet("Test", "WpfWindowClosed")]
    public class TestWpfWindowClosed : PSCmdlet
    {
        [Parameter(Position = 0, Mandatory = true)]
        public Window Window { get; set; }

        protected override void EndProcessing()
        {
            WriteObject(Util.IsWindowClosed(Window));
        }
    }

    [Cmdlet("Get", "WpfWindowList")]
    public class GetWpfWindowList : PSCmdlet
    {
        static private List<Window> _windowList = new List<Window>();

        static public List<Window> WindowList { get { return _windowList; } }

        protected override void EndProcessing()
        {
            _windowList.RemoveAll((w) => { return Util.IsWindowClosed(w); });

            foreach (var w in _windowList) {
                WriteObject(w);
            }
        }
    }
}