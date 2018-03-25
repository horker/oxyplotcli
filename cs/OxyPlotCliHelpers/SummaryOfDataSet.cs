using System.Collections.Generic;

#pragma warning disable CS1591

namespace Horker.OxyPlotCli
{
    /// <summary>
    /// Represents the five-number summary of a data set.</summary>
    /// <para> Returns the same results of the "boxplot.stat" function in R. This is the same as the computing method 2 in Wikipedia.</para>
    /// <para>boxplot.stat: http://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/boxplot.stats.html"</para>
    /// <para>Quartile in Wikipedia: https://en.wikipedia.org/wiki/Quartile"</para>
    public class SummaryOfDataSet
    {
        public double Minimum { get; private set; }
        public double LowerQuartile { get; private set; }
        public double Median { get; private set; }
        public double UpperQuartile { get; private set; }
        public double Maximum { get; private set; }

        public SummaryOfDataSet(IList<double> sortedDataSet)
        {
            Compute(sortedDataSet);
        }

        private void Compute(IList<double> dataSet)
        {
            var size = dataSet.Count;

            Minimum = dataSet[0];
            Maximum = dataSet[size - 1];

            // Median

            var latterHalf = 0; // Start position of the latter half
            var halfSize = 0;

            if (size % 2 == 0) {
                latterHalf = size / 2;
                halfSize = size / 2;
                Median = (dataSet[latterHalf - 1] + dataSet[latterHalf]) / 2.0;
            }
            else {
                latterHalf = size / 2; // round down
                halfSize = size / 2 + 1;
                Median = dataSet[latterHalf];
            }

            // Lower Quantile

            if (halfSize % 2 == 0) {
                var lowerq = halfSize / 2;
                LowerQuartile = (dataSet[lowerq - 1] + dataSet[lowerq]) / 2.0;
            }
            else {
                var lowerq = halfSize / 2; // round down
                LowerQuartile = dataSet[lowerq];
            }

            // Uppwer Quantitle

            if (halfSize % 2 == 0) {
                var upperq = latterHalf + halfSize / 2;
                UpperQuartile = (dataSet[upperq - 1] + dataSet[upperq]) / 2.0;
            }
            else {
                var upperq = latterHalf + halfSize / 2; // round down
                UpperQuartile = dataSet[upperq];
            }
        }
    }
}
