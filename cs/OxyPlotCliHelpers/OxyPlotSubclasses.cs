using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OxyPlot;

#pragma warning disable CS1591

namespace Horker.OxyPlotCli.Series
{
    public class BoxPlotRawItem
    {
        public double X { get; set; }
        public double Value { get; set; }

        public BoxPlotRawItem(double x, double value)
        {
            X = x;
            Value = value;
        }
    }

    public class BoxPlotSeries : OxyPlot.Series.BoxPlotSeries
    {
        public IList<BoxPlotRawItem> RawItems { get; set; }

        public BoxPlotSeries()
            : base()
        {
            RawItems = new List<BoxPlotRawItem>();
        }

        public void ComputeRepresentativeValues()
        {
            var itemsByCategory = new Dictionary<double, IList<double>>();

            foreach (var i in RawItems) {
                if (!itemsByCategory.ContainsKey(i.X)) {
                    itemsByCategory.Add(i.X, new List<double>());
                }
                itemsByCategory[i.X].Add(i.Value);
            }

            foreach (var entry in itemsByCategory) {
                var values = entry.Value as List<double>;
                values.Sort();

                var summary = new SummaryOfDataSet(values);
                var median = summary.Median;
                var lowerq = summary.LowerQuartile;
                var upperq = summary.UpperQuartile;

                // The same results as R's boxplot.stat()
                // See: http://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/boxplot.stats.html

                var iqr = upperq - lowerq;
                var lowerWhisker = lowerq - 1.58 * iqr / Math.Sqrt(values.Count);
                var upperWhisker = upperq + 1.58 * iqr / Math.Sqrt(values.Count);

                var outliers = values.Where((x) => { return x < lowerWhisker || upperWhisker < x; }).ToList<double>();

                var oxyItem = new OxyPlot.Series.BoxPlotItem(entry.Key, lowerWhisker, lowerq, median, upperq, upperWhisker);

                oxyItem.Outliers = outliers;

                base.Items.Add(oxyItem);
            }

            RawItems.Clear();
        }
    }
}
