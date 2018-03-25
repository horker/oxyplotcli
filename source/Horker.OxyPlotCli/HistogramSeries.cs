using System;
using System.Collections.Generic;
using System.Linq;

#pragma warning disable CS1591

namespace Horker.OxyPlotCli.Series
{
    public class Histogram
    {
        public IDictionary<int, int> Bins { get; private set; }

        public int BinCount { get; set; }
        public double BinWidth { get; set; }
        public double BinOffset { get; set; }

        public Histogram()
        {
            Bins = new Dictionary<int, int>();

            BinCount = 0;
            BinWidth = 0;
            BinOffset = 0;
        }

        public void UpdateBinWidth(IList<double> data)
        {
            if (!Double.IsNaN(BinWidth) && BinWidth != 0.0) {
                return;
            }

            var max = data.Max();
            var min = data.Min();
            var range = max - min;

            if (BinCount != 0) {
                BinWidth = range / (BinCount - 1);
                return;
            }

            BinCount = (int)Math.Ceiling(Math.Sqrt(data.Count));
            if (BinCount == 0) {
                BinCount = 1;
            }
            BinWidth = range / (BinCount - 1);
        }

        public void FillBins(IList<double> data)
        {
            foreach (var value in data) {
                var index = (int)Math.Floor((value - BinOffset) / BinWidth);
                if (!Bins.ContainsKey(index)) {
                    Bins[index] = 0;
                }
                ++Bins[index];
            }
        }

        public void ClearBins()
        {
            foreach (var offset in Bins.Keys.ToList<int>()) {
                Bins[offset] = 0;
            }
        }

        public IList<string> GetLabels(string formatString)
        {
            if (string.IsNullOrEmpty(formatString)) {
                formatString = "{0:0.0} -";
            }

            var labels = new List<string>();

            var indexes = Bins.Keys.ToList<int>();
            indexes.Sort();

            var min = indexes.Min();
            var max = indexes.Max();
            for (var i = min; i <= max; ++i) {
                var lower = i * BinWidth + BinOffset;
                var upper = lower + BinWidth;
                var upper1 = upper - 1;
                labels.Add(String.Format(formatString, lower, upper, upper1));
            }

            return labels;
        }
    }

    public class HistogramSeries : OxyPlot.Series.ColumnSeries, IProcessingSeries
    {
        public int BinCount { get; set; }
        public double BinWidth { get; set; }
        public double BinOffset { get; set; }

        public IList<double> RawValues { get; set; }

        public string BinLabelFormatString { get; set; }

        private Histogram _histogram;

        public HistogramSeries()
            : base()
        {
        }

        public HistogramSeries(Histogram histogram)
            : base()
        {
            IsStacked = true;

            BinCount = histogram.BinCount;
            BinWidth = histogram.BinWidth;
            BinOffset = histogram.BinOffset;

            RawValues = new List<double>();

            _histogram = histogram;
        }

        public void ProcessRawValues()
        {
            _histogram.ClearBins();
            _histogram.FillBins(RawValues);

            var indexes = _histogram.Bins.Keys.ToList<int>();
            indexes.Sort();

            var min = indexes[0];
            var max = indexes[indexes.Count - 1];
            for (var i = min; i <= max; ++i) {
                var freq = 0;
                _histogram.Bins.TryGetValue(i, out freq);
                var item = new OxyPlot.Series.ColumnItem(freq, i - min);
                Items.Add(item);
            }

            RawValues.Clear();
        }
    }
}
