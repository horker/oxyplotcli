using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Management;
using System.Management.Automation;
using OxyPlot;
using OxyPlot.Axes;

namespace OxyPlotCliHelpers
{
    [Cmdlet("Add", "OxyAxisShare")]
    public class AddOxyAxisShare : PSCmdlet
    {
        [Parameter(Position = 0, Mandatory = true)]
        public Axis[] Axis { get; set; }

        [Parameter(Position = 1, Mandatory = false)]
        public double[] Multiplier { get; set; }

        [Parameter(Position = 2, Mandatory = false)]
        public double[] Offset { get; set; }

        protected override void EndProcessing()
        {
            if (Offset == null) {
                Offset = new double[Axis.Length];
                for (var i = 0; i < Offset.Length; ++i) {
                    Offset[i] = 0.0;
                }
            }

            if (Multiplier == null) {
                Multiplier = new double[Axis.Length];
                for (var i = 0; i < Multiplier.Length; ++i) {
                    Multiplier[i] = 1.0;
                }
            }
            else {
                if (Multiplier.Contains(0.0)) {
                    WriteError(new ErrorRecord(new ArgumentException(), "Multiplier should not be zero", ErrorCategory.InvalidArgument, null));
                    return;
                }

            }

            if (Axis.Length != Multiplier.Length || Multiplier.Length != Offset.Length) {
                WriteError(new ErrorRecord(new ArgumentException(), "Parameter length mismatch", ErrorCategory.InvalidArgument, null));
                return;
            }

            for (var i = 1; i < Axis.Length; ++i) {
                Axis[i].Minimum = (Axis[0].Minimum - Offset[0]) / Multiplier[0] * Multiplier[i] + Offset[i];
                Axis[i].Maximum = (Axis[0].Maximum - Offset[0]) / Multiplier[0] * Multiplier[i] + Offset[i];
            }

            // defensive copy
            Axis[] sharedAxes = new Axis[Axis.Length];
            Array.Copy(Axis, sharedAxes, Axis.Length);

            bool isInternalChange = false;
            for (var i = 0; i < Axis.Length; ++i) {
                Axis[i].AxisChanged += (sender, eventArgs) => {
                    if (isInternalChange) {
                        return;
                    }

                    var a1 = (Axis)sender;
                    int p;
                    for (p = 0; p < sharedAxes.Length; ++p) {
                        if (Axis[p] == a1) {
                            break;
                        }
                    }

                    isInternalChange = true;
                    for (var j = 0; j < sharedAxes.Length; ++j) {
                        var a2 = Axis[j];
                        if (a1 == a2) {
                            continue;
                        }

                        var min = (a1.ActualMinimum - Offset[p]) / Multiplier[p] * Multiplier[j] + Offset[j];
                        var max = (a1.ActualMaximum - Offset[p]) / Multiplier[p] * Multiplier[j] + Offset[j];

                        a2.Zoom(min, max);
                        a2.PlotModel.InvalidatePlot(false);
                    }
                    isInternalChange = false;
                };
            }

        }

    }
}
