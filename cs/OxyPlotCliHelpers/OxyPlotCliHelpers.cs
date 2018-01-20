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
    [Cmdlet("Add", "OxyCoupledAxes")]
    public class AddOxyCoupledAxes : PSCmdlet
    {
        [Parameter(Position = 0, Mandatory = true)]
        public Axis[] Axis { get; set; }

        protected override void EndProcessing()
        {
            var comb = new List<Axis>();
            for (var i = 0; i < Axis.Length - 1; ++i) {
                for (var j = i + 1; j < Axis.Length; ++j) {
                    comb.Add(Axis[i]);
                    comb.Add(Axis[j]);
                }
            }

            bool isInternalChange = false;
            for (var i = 0; i < comb.Count; i += 2) {
                for (var j = 0; j < 2; ++j) {
                    var a1 = comb[i + j];
                    var a2 = comb[i + 1 - j];
                    a1.AxisChanged += (s, e) => {
                        if (isInternalChange) {
                            return;
                        }

                        isInternalChange = true;
                        a2.Zoom(a1.ActualMinimum, a1.ActualMaximum);
                        a2.PlotModel.InvalidatePlot(false);
                        isInternalChange = false;
                    };
                }
            }

        }

    }
}
