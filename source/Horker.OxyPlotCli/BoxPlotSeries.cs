using System;
using System.Collections.Generic;
using System.Linq;

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

                var outliers = values.Where((x) => { return x < summary.LowerWhisker || summary.UpperWhisker < x; }).ToList<double>();

                var oxyItem = new OxyPlot.Series.BoxPlotItem(
                    entry.Key, summary.LowerWhisker, summary.LowerQuartile, summary.Median, summary.UpperQuartile, summary.UpperWhisker);

                oxyItem.Outliers = outliers;

                base.Items.Add(oxyItem);
            }

            RawItems.Clear();
        }
    }
}
