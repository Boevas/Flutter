import 'dart:math';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as element;
import 'package:charts_flutter/src/text_style.dart' as style;

class LinearSales {
  final int year;
  final int sales;
  final charts.Color color;
  final List<int> dashPattern;
  final double strokeWidthPx;

  LinearSales(
      this.year, this.sales, this.color, this.dashPattern, this.strokeWidthPx);
}

class ChartDemoData3 {
  Color blueShade1;
  Color blueShade2;

  List<charts.Series<LinearSales, int>> getdata() {
    List<charts.Color> blueShades = charts.MaterialPalette.blue.makeShades(2);
    charts.Color blueShade1 = blueShades[0];
    charts.Color blueShade2 = blueShades[1];

    List<LinearSales> colorChangeData = [
      new LinearSales(0, 5, blueShade1, null, 2.0),
      new LinearSales(1, 15, blueShade2, null, 2.0),
      new LinearSales(2, 25, blueShade1, null, 2.0),
      new LinearSales(3, 75, blueShade2, null, 2.0),
      new LinearSales(4, 100, blueShade1, null, 2.0),
      new LinearSales(5, 90, blueShade2, null, 2.0),
      new LinearSales(6, 75, blueShade1, null, 2.0),
    ];

    List<charts.Color> redShades = charts.MaterialPalette.red.makeShades(2);
    charts.Color redShade1 = redShades[0];
    charts.Color redShade2 = redShades[1];

    List<LinearSales> dashPatternChangeData = [
      new LinearSales(0, 10, redShade1, [1, 2], 2.0),
      new LinearSales(1, 30, redShade2, [2, 2], 2.0),
      new LinearSales(2, 50, redShade1, [4, 4], 2.0),
      new LinearSales(3, 150, redShade2, [4, 4], 2.0),
      new LinearSales(4, 200, redShade1, [4, 4], 2.0),
      new LinearSales(5, 180, redShade2, [2, 2, 5, 5], 2.0),
      new LinearSales(6, 150, redShade1, [2, 2, 5, 5], 2.0),
    ];

    List<charts.Color> greenShades = charts.MaterialPalette.green.makeShades(2);
    charts.Color greenShade1 = greenShades[0];
    charts.Color greenShade2 = greenShades[1];

    List<LinearSales> strokeWidthChangeData = [
      new LinearSales(0, 15, greenShade1, null, 2.0),
      new LinearSales(1, 45, greenShade2, null, 2.0),
      new LinearSales(2, 75, greenShade1, null, 4.0),
      new LinearSales(3, 225, greenShade2, null, 4.0),
      new LinearSales(4, 300, greenShade1, null, 4.0),
      new LinearSales(5, 270, greenShade2, null, 6.0),
      new LinearSales(6, 225, greenShade1, null, 6.0),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Color Change',
        // Light shade for even years, dark shade for odd.

        colorFn: (LinearSales sales, _) => sales.color,
        dashPatternFn: (LinearSales sales, _) => sales.dashPattern,
        strokeWidthPxFn: (LinearSales sales, _) => sales.strokeWidthPx,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: colorChangeData,
        labelAccessorFn: (LinearSales sales, _) =>
            '${sales.year}: \$${sales.sales.toString()}',
        insideLabelStyleAccessorFn: (LinearSales sales, _) {
          final color = (sales.year == 2)
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
        outsideLabelStyleAccessorFn: (LinearSales sales, _) {
          final color = (sales.year == 4)
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
      ),
      new charts.Series<LinearSales, int>(
        id: 'Dash Pattern Change',
        // Light shade for even years, dark shade for odd.
        colorFn: (LinearSales sales, _) => sales.color,
        dashPatternFn: (LinearSales sales, _) => sales.dashPattern,
        strokeWidthPxFn: (LinearSales sales, _) => sales.strokeWidthPx,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: dashPatternChangeData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Stroke Width Change',
        // Light shade for even years, dark shade for odd.
        colorFn: (LinearSales sales, _) => sales.color,
        dashPatternFn: (LinearSales sales, _) => sales.dashPattern,
        strokeWidthPxFn: (LinearSales sales, _) => sales.strokeWidthPx,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: strokeWidthChangeData,
      ),
    ];
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    charts.SeriesDatum csd = ToolTipMgr.getSeriesDatum()[ToolTipMgr.index];
    canvas.drawRect(
        Rectangle(bounds.left + 15, bounds.top - 2, bounds.width + 30,
            bounds.height + 5),
        fill: (csd.series.data[csd.index] as LinearSales).color);

    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.black;
    textStyle.fontSize = 16;

    canvas.drawText(
        element.TextElement(
            (csd.series.data[csd.index] as LinearSales).sales.toString(),
            style: textStyle),
        (bounds.left).round() + 15,
        (bounds.top).round());
    ToolTipMgr.index = ToolTipMgr.index + 1;
  }
}

class ToolTipMgr {
  static List<charts.SeriesDatum> _selectedDatum = <charts.SeriesDatum>[];
  static clear() {
    _selectedDatum.clear();
    index = 0;
  }

  static List<charts.SeriesDatum> getSeriesDatum() {
    return _selectedDatum;
  }

  static addAll(charts.SelectionModel model) {
    _selectedDatum.addAll(model.selectedDatum);
    index = 0;
  }

  static int index = 0;
  static int getIndex() {
    return index++;
  }
}

class Page5 extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  Page5(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      behaviors: [
        new charts.ChartTitle('Top title text',
            subTitle: 'Top sub-title text',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18),
        new charts.ChartTitle('Bottom title text',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Start title',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('End title',
            behaviorPosition: charts.BehaviorPosition.end,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.LinePointHighlighter(
            symbolRenderer: CustomCircleSymbolRenderer()),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) {
            ToolTipMgr.clear();
            ToolTipMgr.addAll(model);
          }
        })
      ],
      defaultRenderer: new charts.LineRendererConfig(
        //customRendererId: "s",
        //symbolRenderer:
        //rendererAttributes:
        //radiusPx: 5,
        //stacked: true,
        //strokeWidthPx: 50,
        //dashPattern: [1, 2, 3],
        //includeLine: true,
        includePoints: true,
        includeArea: true,
        //layoutPaintOrder: 20,
        areaOpacity: 0.3,
        //roundEndCaps: true,
      ),
      animate: false,
    );
  }
}
