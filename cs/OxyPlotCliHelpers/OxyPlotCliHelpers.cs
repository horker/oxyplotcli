using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Management;
using System.Management.Automation;
using OxyPlot;
using OxyPlot.Axes;

#pragma warning disable CS1591

namespace Horker.OxyPlotCli
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

    // Source:
    // https://github.com/wch/r-source/blob/trunk/src/library/grDevices/src/colors.c

    public class ColorConverter
    {
        public class Rgb
        {
            public double R;
            public double G;
            public double B;

            public Rgb(double r, double g, double b)
            {
                this.R = r;
                this.G = g;
                this.B = b;
            }

            public void Fixup()
            {
                if (R < 0) { R = 0; }
                else if (R > 1) { R = 1; }
                if (G < 0) { G = 0; }
                else if (G > 1) { G = 1; }
                if (B < 0) { B = 0; }
                else if (B > 1) { B = 1; }
            }

            public override string ToString()
            {
                return String.Format("#{0:x2}{1:x2}{2:x2}",
                    (int)(R * 255 + 0.5),
                    (int)(G * 255 + 0.5),
                    (int)(B * 255 + 0.5));
            }
        }

        private const double DEG2RAD = 0.01745329251994329576;

        /* D65 White Point */

        private const double WHITE_X = 95.047;
        private const double WHITE_Y = 100.000;
        private const double WHITE_Z = 108.883;
        private const double WHITE_u = 0.1978398;
        private const double WHITE_v = 0.4683363;

        /* Standard CRT Gamma */

        const double GAMMA = 2.4;

        private static double gtrans(double u)
        {
            if (u > 0.00304)
                return 1.055 * Math.Pow(u, (1 / GAMMA)) - 0.055;
            else
                return 12.92 * u;
        }

        static public Rgb ConvertHclToRgb(double h, double c, double l)
        {
            var result = new Rgb(0, 0, 0);
            if (l <= 0.0) {
                return result;
            }
            double L, U, V;
            double u, v;
            double X, Y, Z;

            /* Step 1 : Convert to CIE-LUV */

            h = DEG2RAD * h;
            L = l;
            U = c * Math.Cos(h);
            V = c * Math.Sin(h);

            /* Step 2 : Convert to CIE-XYZ */

            if (L <= 0 && U == 0 && V == 0) {
                X = 0;
                Y = 0;
                Z = 0;
            }
            else {
                Y = WHITE_Y * ((L > 7.999592) ? Math.Pow((L + 16) / 116, 3) : L / 903.3);
                u = U / (13 * L) + WHITE_u;
                v = V / (13 * L) + WHITE_v;
                X = 9.0 * Y * u / (4 * v);
                Z = -X / 3 - 5 * Y + 3 * Y / v;
            }

            /* Step 4 : CIE-XYZ to sRGB */

            result.R = gtrans((3.240479 * X - 1.537150 * Y - 0.498535 * Z) / WHITE_Y);
            result.G = gtrans((-0.969256 * X + 1.875992 * Y + 0.041556 * Z) / WHITE_Y);
            result.B = gtrans((0.055648 * X - 0.204043 * Y + 1.057311 * Z) / WHITE_Y);

            return result;
        }

    }
}
