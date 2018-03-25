using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using Horker.OxyPlotCli;

namespace OxyPlotCliTests
{
    [TestClass]
    public class SummaryOfDataSetTest
    {
        [TestMethod]
        public void TestLength4()
        {
            var data = new List<double>() { 1, 2, 3, 4 };

            var summary = new SummaryOfDataSet(data);

            Assert.AreEqual(1, summary.Minimum);
            Assert.AreEqual(1.5, summary.LowerQuartile);
            Assert.AreEqual(2.5, summary.Median);
            Assert.AreEqual(3.5, summary.UpperQuartile);
            Assert.AreEqual(4, summary.Maximum);
        }

        [TestMethod]
        public void TestLength5()
        {
            var data = new List<double>() { 1, 2, 3, 4, 5 };

            var summary = new SummaryOfDataSet(data);

            Assert.AreEqual(1, summary.Minimum);
            Assert.AreEqual(2, summary.LowerQuartile);
            Assert.AreEqual(3, summary.Median);
            Assert.AreEqual(4, summary.UpperQuartile);
            Assert.AreEqual(5, summary.Maximum);
        }

        [TestMethod]
        public void TestLength6()
        {
            var data = new List<double>() { 1, 2, 3, 4, 5, 6 };

            var summary = new SummaryOfDataSet(data);

            Assert.AreEqual(1, summary.Minimum);
            Assert.AreEqual(2, summary.LowerQuartile);
            Assert.AreEqual(3.5, summary.Median);
            Assert.AreEqual(5, summary.UpperQuartile);
            Assert.AreEqual(6, summary.Maximum);
        }

        [TestMethod]
        public void TestLength7()
        {
            var data = new List<double>() { 1, 2, 3, 4, 5, 6, 7 };

            var summary = new SummaryOfDataSet(data);

            Assert.AreEqual(1, summary.Minimum);
            Assert.AreEqual(2.5, summary.LowerQuartile);
            Assert.AreEqual(4, summary.Median);
            Assert.AreEqual(5.5, summary.UpperQuartile);
            Assert.AreEqual(7, summary.Maximum);
        }

        [TestMethod]
        public void TestWikipedia1()
        {
            // Source: https://en.wikipedia.org/wiki/Quartile
            // Example 1

            var data = new List<double>() { 6, 7, 15, 36, 39, 40, 41, 42, 43, 47, 49 };

            var summary = new SummaryOfDataSet(data);

            Assert.AreEqual(6, summary.Minimum);
            Assert.AreEqual(25.5, summary.LowerQuartile);
            Assert.AreEqual(40, summary.Median);
            Assert.AreEqual(42.5, summary.UpperQuartile);
            Assert.AreEqual(49, summary.Maximum);
        }

        [TestMethod]
        public void TestWikipedia2()
        {
            // Source: https://en.wikipedia.org/wiki/Quartile
            // Example 2

            var data = new List<double>() { 7, 15, 36, 39, 40, 41 };

            var summary = new SummaryOfDataSet(data);

            Assert.AreEqual(7, summary.Minimum);
            Assert.AreEqual(15, summary.LowerQuartile);
            Assert.AreEqual(37.5, summary.Median);
            Assert.AreEqual(40, summary.UpperQuartile);
            Assert.AreEqual(41, summary.Maximum);
        }

        [TestMethod]
        public void TestIris()
        {
            // > boxplot.stats(subset(iris, Species == 'versicolor')$Petal.Length)
            // $stats
            // [1] 3.30 4.00 4.35 4.60 5.10

            // iris versicolor Petal.Length
            var data = new double[] { 4.7, 4.5, 4.9, 4, 4.6, 4.5, 4.7, 3.3, 4.6, 3.9, 3.5, 4.2, 4, 4.7, 3.6, 4.4, 4.5, 4.1, 4.5, 3.9, 4.8, 4, 4.9, 4.7, 4.3, 4.4, 4.8, 5, 4.5, 3.5, 3.8, 3.7, 3.9, 5.1, 4.5, 4.5, 4.7, 4.4, 4.1, 4, 4.4, 4.6, 4, 3.3, 4.2, 4.2, 4.2, 4.3, 3, 4.1 };

            Array.Sort(data);
            var summary = new SummaryOfDataSet(data);

            Assert.AreEqual(3.00, summary.Minimum);
            Assert.AreEqual(3.30, summary.LowerWhisker);
            Assert.AreEqual(4.00, summary.LowerQuartile);
            Assert.AreEqual(4.35, summary.Median);
            Assert.AreEqual(4.60, summary.UpperQuartile);
            Assert.AreEqual(5.10, summary.UpperWhisker);
            Assert.AreEqual(5.10, summary.Maximum);
        }
    }
}
