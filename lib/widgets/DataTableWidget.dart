import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test4/sqlite/Sqlite.dart';

class DataColumnEx {
  bool show;
  String label;
  String tooltip;
  bool numeric;
  bool editable;
  TextInputType editableTextInputType;
  double width;
  TextAlign align;
  DataColumnEx(
      {@required this.show,
      this.label = "",
      this.tooltip = "",
      this.numeric = false,
      this.editable = false,
      this.editableTextInputType = TextInputType.text,
      this.width = 100,
      this.align = TextAlign.left});
}

class DataTableWidget extends StatefulWidget {
  final String dbName;
  final String viewSqlScript;
  final Map<String, DataColumnEx> columns;
  final String updateTableName;
  final String updateTablePK;

  DataTableWidget({
    @required this.dbName,
    @required this.viewSqlScript,
    @required this.columns,
    this.updateTableName,
    this.updateTablePK,
  });

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  List<Map<String, dynamic>> _snapshot;

  List<Map<String, dynamic>> _getsnapshot() {
    return _snapshot;
  }

  _setsnapshot(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    _snapshot = List<Map<String, dynamic>>.from(snapshot.data);
  }

  _sort() {
    String columnName = _getsnapshot().first.keys.elementAt(_sortColumnIndex);
    if (_sortAscending)
      _getsnapshot().sort((a, b) => (b[columnName]).compareTo(a[columnName]));
    else
      _getsnapshot().sort((a, b) => (a[columnName]).compareTo(b[columnName]));
  }

  DataColumnEx getDataColumnEx(String columnName) {
    return widget.columns.containsKey(columnName)
        ? widget.columns[columnName]
        : DataColumnEx(
            show: true,
            label: columnName,
            tooltip: columnName,
            numeric: false,
            editable: false,
            editableTextInputType: TextInputType.name);
  }

  List<DataColumn> _getDataColumn() {
    List<DataColumn> listDataColumn = <DataColumn>[];

    for (var i = 0; i < _getsnapshot()[0].keys.length; i++) {
      String columnName = _getsnapshot()[0].keys.elementAt(i).toString();

      DataColumnEx column = getDataColumnEx(columnName);

      if (false == column.show) continue;

      listDataColumn.add(DataColumn(
          onSort: (columnIndex, ascending) {
            setState(() {
              _sortColumnIndex = columnIndex;
              _sortAscending = ascending;
            });
          },
          tooltip: column.tooltip,
          label: Expanded(
              child: Text(column.label, textAlign: TextAlign.center))));
    }
    listDataColumn.add(DataColumn(
        tooltip: "",
        label: Expanded(child: Text('Удалить', textAlign: TextAlign.center))));
    return listDataColumn;
  }

  List<DataRow> _getDataRow() {
    List<DataRow> listDataRow = <DataRow>[];

    for (var rowIdx = 0; rowIdx < _getsnapshot().length; rowIdx++) {
      List<DataCell> ldc = <DataCell>[];
      for (var ceilIdx = 0;
          ceilIdx < _getsnapshot()[0].keys.length;
          ceilIdx++) {
        String columnName =
            _getsnapshot().first.keys.elementAt(ceilIdx).toString();

        DataColumnEx column = getDataColumnEx(columnName);
        if (false == column.show) continue;

        String ceilText = _getsnapshot()[rowIdx][columnName].toString();

        TextEditingController tec = TextEditingController(text: ceilText);
        ldc.add(column.editable
            ? DataCell(
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  width: column.width,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter a message",
                      suffixIcon: IconButton(
                        onPressed: () => tec.clear(),
                        icon: Icon(Icons.clear),
                      ),
                    ),
                    textAlign: column.align,
                    style: TextStyle(fontSize: 15),
                    controller: tec,
                    //initialValue: ceilText,
                    keyboardType: column.editableTextInputType,
                    onFieldSubmitted: (val) {
                      String updateSql =
                          'UPDATE ${widget.updateTableName} SET ${_getsnapshot().first.keys.elementAt(ceilIdx).toString()}=${val.toString()} WHERE ${widget.updateTablePK}=${_getsnapshot()[rowIdx][widget.updateTablePK].toString()}';

                      SqliteUtils(widget.dbName).executeReader(updateSql);
                      //_getsnapshot()[rowIdx][columnName] = val;
                    },
                  ),
                ),
                //showEditIcon: true,
              )
            : DataCell(Container(
                decoration: BoxDecoration(border: Border.all(width: 1)),
                alignment: Alignment.center,
                width: column.width,
                child: Text(
                  ceilText,
                  textAlign: column.align,
                  style: TextStyle(fontSize: 15),
                ),
              )));
      }

      ldc.add(DataCell(
        Container(
          alignment: Alignment.center,
          child: SizedBox.fromSize(
            size: Size(56, 56), // button width and height
            child: ClipOval(
              child: Material(
                child: InkWell(
                  splashColor: Colors.red, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.delete), // icon
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ));
      listDataRow.add(DataRow(
        // color: MaterialStateColor.resolveWith((states) {
        //   return rowIdx % 2 == 0 ? Colors.red : Colors.black; //make tha magic!
        // }),
        // color: MaterialStateProperty.resolveWith<Color>(
        //     (Set<MaterialState> states) {
        //   if (states.contains(MaterialState.selected))
        //     return Theme.of(context).colorScheme.primary.withOpacity(0.58);
        //   return null; // Use the default value.
        // }),
        // selected: true,
        // onSelectChanged: (value) {
        //   setState(() {});
        // },
        cells: ldc,
      ));
    }
    return listDataRow;
  }

  @override
  Widget build(BuildContext context) {
    final sizemonitor = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: sizemonitor.width,
          //height: sizemonitor.height,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: SqliteUtils(widget.dbName)
                  .executeReader(widget.viewSqlScript),
              builder: (BuildContext c,
                  AsyncSnapshot<List<Map<String, dynamic>>> aspsh) {
                debugPrint("build");

                if (!aspsh.hasData) return CircularProgressIndicator();

                _setsnapshot(aspsh);
                //sleep(Duration(seconds: 5));
                _sort();

                return DataTable(
                  horizontalMargin: 5,
                  columnSpacing: 0,

                  //headingRowColor:
                  //    MaterialStateColor.resolveWith((states) => Colors.blue),
                  sortAscending: _sortAscending,
                  sortColumnIndex: _sortColumnIndex,
                  showCheckboxColumn: false,
                  columns: _getDataColumn(),
                  rows: _getDataRow(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
