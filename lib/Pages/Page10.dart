import 'package:flutter/material.dart';
import 'Page1.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Page10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Статус')),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            SizedBox(
              height: 10,
              width: 1,
            ),
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue[100],
                    border: Border.all(
                      width: 2.0,
                    )),
                margin: EdgeInsets.only(left: 50, right: 50),
                height: 40,
                child: Text(
                  "Цель: Выручка 1000 ",
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 10,
              width: 1,
            ),
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1.0,
                )),
                margin: EdgeInsets.only(left: 30, right: 30),
                height: 20,
                child: Text(
                  "Деньги",
                  textAlign: TextAlign.center,
                )),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                width: 1.0,
              )),
              margin: EdgeInsets.only(left: 30, right: 30),
              height: 30,
              child: Text(
                "В товаре: 100",
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                width: 1.0,
              )),
              margin: EdgeInsets.only(left: 30, right: 30),
              height: 30,
              child: Text(
                "В заказе: 200",
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                width: 1.0,
              )),
              margin: EdgeInsets.only(left: 30, right: 30),
              height: 30,
              child: Text(
                "Выручка вчера: 300",
              ),
            ),
            SizedBox(
              height: 30,
              width: 1,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                width: 1.0,
              )),
              margin: EdgeInsets.only(left: 30, right: 30),
              height: 20,
              child: Text(
                "Склад",
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 2.0,
                )),
                margin: EdgeInsets.only(left: 30, right: 30),
                height: 400,
                child: charts.BarChart(
                  ChartDemoData1().getdata(),
                  animate: true,
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                      renderSpec: new charts.NoneRenderSpec()),
                  domainAxis: new charts.OrdinalAxisSpec(
                      showAxisLine: true,
                      renderSpec: new charts.NoneRenderSpec()),
                ),
              ),
            ),
            SizedBox(
              height: 10,
              width: 1,
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: 30, right: 30),
              child: RaisedButton(
                onPressed: () {},
                child: const Text('Руб/шт', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
