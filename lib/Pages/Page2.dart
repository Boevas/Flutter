import 'package:flutter/material.dart';
import 'package:test4/widgets/DataTableWidget.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  TextEditingController sqlController =
      new TextEditingController(text: "SELECT * FROM OBJECTS LIMIT 100;");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page2"),
      ),
      body: new Container(
        //alignment: Alignment.center,
        child: Wrap(
          children: <Widget>[
            Container(
              child: TextField(
                textAlign: TextAlign.left,
                controller: sqlController,
                decoration: new InputDecoration(
                  helperText: "SQL Script",
                ),
              ),
            ),
            SizedBox(
              height: 10,
              width: 10,
            ),
            DataTableWidget(
                dbName: "130",
                viewSqlScript: sqlController.text,
                rowHeight: 100,
                columns: {
                  'ID': DataColumnEx(
                    show: true,
                    label: "ИД",
                    numeric: true,
                    tooltip: "ИД tooltip",
                    editable: false,
                  ),
                  //'ID_TYPES': DataColumnEx(show: true, editable: false),
                  'NAME': DataColumnEx(
                      show: true,
                      label: "Название",
                      numeric: false,
                      tooltip: "Название tooltip",
                      editable: true,
                      editableTextInputType: TextInputType.text),
                  'DATE': DataColumnEx(
                      show: true,
                      label: "Дата",
                      numeric: false,
                      tooltip: "Дата tooltip",
                      editable: false,
                      editableTextInputType: TextInputType.datetime),
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        tooltip: 'Test',
        child: Icon(Icons.square_foot_sharp),
      ),
    );
  }
}
