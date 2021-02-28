import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class LinearSales {
  final int year;
  final int sales;
  final List<int> dashPattern;
  final double strokeWidthPx;

  LinearSales(this.year, this.sales, this.dashPattern, this.strokeWidthPx);
}

class ChartDemoData2 {
  List<charts.Series<LinearSales, int>> getdata() {
    final colorChangeData = [
      new LinearSales(0, 5, null, 2.0),
      new LinearSales(1, 15, null, 2.0),
      new LinearSales(2, 25, null, 2.0),
      new LinearSales(3, 75, null, 2.0),
      new LinearSales(4, 100, null, 2.0),
      new LinearSales(5, 90, null, 2.0),
      new LinearSales(6, 75, null, 2.0),
    ];

    // Series of data with changing color and dash pattern.
    final dashPatternChangeData = [
      new LinearSales(0, 5, [2, 2], 2.0),
      new LinearSales(1, 15, [2, 2], 2.0),
      new LinearSales(2, 25, [4, 4], 2.0),
      new LinearSales(3, 75, [4, 4], 2.0),
      new LinearSales(4, 100, [4, 4], 2.0),
      new LinearSales(5, 90, [8, 3, 2, 3], 2.0),
      new LinearSales(6, 75, [8, 3, 2, 3], 2.0),
    ];

    // Series of data with changing color and stroke width.
    final strokeWidthChangeData = [
      new LinearSales(0, 5, null, 2.0),
      new LinearSales(1, 15, null, 2.0),
      new LinearSales(2, 25, null, 4.0),
      new LinearSales(3, 75, null, 4.0),
      new LinearSales(4, 100, null, 4.0),
      new LinearSales(5, 90, null, 6.0),
      new LinearSales(6, 75, null, 6.0),
    ];

    // Generate 2 shades of each color so that we can style the line segments.
    final blue = charts.MaterialPalette.blue.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(2);
    final green = charts.MaterialPalette.green.makeShades(2);

    return [
      new charts.Series<LinearSales, int>(
        id: 'Color Change',
        // Light shade for even years, dark shade for odd.
        colorFn: (LinearSales sales, _) =>
            sales.year % 2 == 0 ? blue[1] : blue[0],
        dashPatternFn: (LinearSales sales, _) => sales.dashPattern,
        strokeWidthPxFn: (LinearSales sales, _) => sales.strokeWidthPx,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: colorChangeData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Dash Pattern Change',
        // Light shade for even years, dark shade for odd.
        colorFn: (LinearSales sales, _) =>
            sales.year % 2 == 0 ? red[1] : red[0],
        dashPatternFn: (LinearSales sales, _) => sales.dashPattern,
        strokeWidthPxFn: (LinearSales sales, _) => sales.strokeWidthPx,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: dashPatternChangeData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Stroke Width Change',
        // Light shade for even years, dark shade for odd.
        colorFn: (LinearSales sales, _) =>
            sales.year % 2 == 0 ? green[1] : green[0],
        dashPatternFn: (LinearSales sales, _) => sales.dashPattern,
        strokeWidthPxFn: (LinearSales sales, _) => sales.strokeWidthPx,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: strokeWidthChangeData,
      ),
    ];
  }
}

class Page4 extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  Page4(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: animate);
  }
}
