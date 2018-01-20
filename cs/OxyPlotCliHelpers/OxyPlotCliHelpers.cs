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

            if (Axis.Length != Multiplier.Length || Multiplier.Length != Offset.Length) {
                WriteError(new ErrorRecord(new ArgumentException(), "Parameter length mismatch", ErrorCategory.InvalidArgument, null));
                return;
            }

            bool isInternalChange = false;
            for (var i = 0; i < Axis.Length - 1; ++i) {
                for (var j = i + 1; j < Axis.Length; ++j) {
                    for (var k = 0; k < 2; ++k) {

                        var c1 = k == 0 ? i : j;
                        var c2 = k == 0 ? j : i;
                        var a1 = Axis[c1];
                        var a2 = Axis[c2];

                        a1.AxisChanged += (s, e) => {
                            if (isInternalChange) {
                                return;
                            }

                            var min = (a1.ActualMinimum - Offset[c1]) / Multiplier[c1] * Multiplier[c2] + Offset[c2];
                            var max = (a1.ActualMaximum - Offset[c1]) / Multiplier[c1] * Multiplier[c2] + Offset[c2];

                            isInternalChange = true;
                            a2.Zoom(min, max);
                            a2.PlotModel.InvalidatePlot(false);
                            isInternalChange = false;
                        };
                    }
                }
            }

        }

    }
}
