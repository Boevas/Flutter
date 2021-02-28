import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class LinearSales {
  final int year;
  final int sales;
  final List<int> dashPattern;
  final double strokeWidthPx;

  LinearSales(this.year, this.sales, this.dashPattern, this.strokeWidthPx);
}

class ChartDemoData4 {
  List<charts.Series<LinearSales, String>> getdata() {
    final colorChangeData = [
      new LinearSales(0, 5, null, 2.0),
      new LinearSales(1, 15, null, 2.0),
      new LinearSales(2, 25, null, 2.0),
      new LinearSales(3, 75, null, 2.0),
      new LinearSales(4, 100, null, 2.0),
      new LinearSales(5, 90, null, 2.0),
      new LinearSales(6, 75, null, 2.0),
    ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year.toString(),
        measureFn: (LinearSales sales, _) => sales.sales,
        data: colorChangeData,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (LinearSales sales, _) =>
            '${sales.year}: \$${sales.sales.toString()}',
        insideLabelStyleAccessorFn: (LinearSales sales, _) {
          final color = (sales.year == 2014)
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
        outsideLabelStyleAccessorFn: (LinearSales sales, _) {
          final color = (sales.year == 2014)
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
      ),
    ];
  }
}

class Page6 extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  Page6(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // Hide domain axis.
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }
}
