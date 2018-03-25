using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Microsoft.VisualStudio.TestTools.UnitTesting;

using Horker.OxyPlotCli.Series;

namespace OxyPlotCliTests
{
    [TestClass]
    public class HistogramSeriesTest
    {
        [TestMethod]
        public void TestHistogram()
        {
            // dummy test for debug

            var data = new List<double>() { 4.7, 4.5, 4.9, 4, 4.6, 4.5, 4.7, 3.3, 4.6, 3.9, 3.5, 4.2, 4, 4.7, 3.6, 4.4, 4.5, 4.1, 4.5, 3.9, 4.8, 4, 4.9, 4.7, 4.3, 4.4, 4.8, 5, 4.5, 3.5, 3.8, 3.7, 3.9, 5.1, 4.5, 4.5, 4.7, 4.4, 4.1, 4, 4.4, 4.6, 4, 3.3, 4.2, 4.2, 4.2, 4.3, 3, 4.1 };

            var hist = new Histogram();
            var series = new HistogramSeries(hist);
            series.RawValues = data;

            series.ProcessRawValues();

            Assert.AreEqual(0, series.BinCount);
        }
    }
}
