import 'package:test4/sqlite/Sqlite.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class AutoOrder {
  String _datascript = "";
  String getDataScript() {
    try {
      return _datascript;
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  void setDataScript(String script) {
    try {
      _datascript = script;
    } on Exception catch (ex) {
      log(ex.toString());
    }
  }

  AutoOrder() {
    try {
      setDataScript("""
                        INSERT INTO CURRENT_ORDER ( ID_TMC_GROUP, GROUPLABEL, QUANTITY, QUANTITYAUTO, PRICE, SUM, SUMAUTO, STOCK, TARGETSTOCK, MAXSTOCK ) 
                          SELECT
                              DIAG_ATTRIBUTES.IDGROUP         AS ID_TMC_GROUP,
                              TMC_GROUP.LABEL                 AS GROUPLABEL,
                              DIAG_ATTRIBUTES.PURCHPLAN       AS QUANTITY,
                              DIAG_ATTRIBUTES.PURCHPLAN       AS QUANTITYAUTO,
                              DIAG_ATTRIBUTES.AVGPURCHPRICE   AS PRICE,
                              DIAG_ATTRIBUTES.PURCSUM         AS SUM,
                              DIAG_ATTRIBUTES.PURCSUM         AS SUMAUTO,
                              DIAG_ATTRIBUTES.CURRENTSTOCK    AS STOCK,
                              DIAG_ATTRIBUTES.TARGETSTOCK     AS TARGETSTOCK,
                              DIAG_ATTRIBUTES.TARGETSTOCK     AS MAXSTOCK 
                            FROM
                              TMC_GROUP
                          INNER JOIN DIAG_ATTRIBUTES 
                                ON DIAG_ATTRIBUTES.IDGROUP = TMC_GROUP.IDGROUP 
                            WHERE
                                  DIAG_ATTRIBUTES.PURCHPLAN > 0 
                                AND DIAG_ATTRIBUTES.CURRENTSTOCK <= DIAG_ATTRIBUTES.SSTOCK;
                    """);
    } on Exception catch (ex) {
      log(ex.toString());
    }
  }

  Future<dynamic> init() async {
    try {
      await SqliteUtils("130").executeNonQuery("DELETE FROM CURRENT_ORDER");
      return SqliteUtils("130").executeNonQuery(getDataScript());
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }
}

class OptimizeOrder {
  double orderlimit = 0;
  double getOrderLimit() {
    try {
      return orderlimit;
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  int orderrestrainstrategy = 0;
  int getOrderRestrainStrategy() {
    try {
      return orderrestrainstrategy;
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  List<Map<String, dynamic>> _dataTable = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> getDataTable() {
    try {
      return _dataTable;
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  void setDataTable(List<Map<String, dynamic>> dt) {
    try {
      dt.forEach((element) {
        Map<String, dynamic> newmmap = new Map<String, dynamic>();
        element.forEach((key, value) {
          newmmap[key.toString()] = value.toString();
        });
        _dataTable.add(newmmap);
      });
    } on Exception catch (ex) {
      log(ex.toString());
    }
  }

  String _datascript = "";
  String getDataScript() {
    try {
      return _datascript;
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  void setDataScript(String script) {
    try {
      _datascript = script;
    } on Exception catch (ex) {
      log(ex.toString());
    }
  }

  int _daystodisplay = 0;
  int get daystodisplay => _daystodisplay;
  set daystodisplay(int daystodisplay) {
    _daystodisplay = daystodisplay;
  }

  OptimizeOrder(
      {@required this.orderlimit, @required this.orderrestrainstrategy}) {
    try {
      setDataScript("""
                        SELECT
                            CURRENT_ORDER.ID
                            ,CURRENT_ORDER.QUANTITY
                            ,CURRENT_ORDER.SUM
                            ,CURRENT_ORDER.PRICE
                            ,DIAG_ATTRIBUTES.AVGPURCHPRICE
                            ,DIAG_ATTRIBUTES.CURRENTSTOCK
                            ,DIAG_ATTRIBUTES.AVGSALE
                            ,DIAG_ATTRIBUTES.PURCHPLAN
                            ,DIAG_ATTRIBUTES.ZERODAYS
                            ,ABC_RATINGS.ABCRATING
                            ,CASE 
                                WHEN DIAG_ATTRIBUTES.AVGSALE!=0 
                                    THEN CURRENT_ORDER.QUANTITY/DIAG_ATTRIBUTES.AVGSALE
                                ELSE 0
                                END AS STOCKINDAYS
                            ,LENGTH(ABCRATING) - LENGTH(REPLACE(ABCRATING, 'A', '')) AS COUNT_A
                            ,0 AS NEED_UPDATE

                        FROM
                            CURRENT_ORDER
                        INNER JOIN DIAG_ATTRIBUTES
                            ON CURRENT_ORDER.ID_TMC_GROUP = DIAG_ATTRIBUTES.IDGROUP
                        INNER JOIN ABC_RATINGS
                          ON CURRENT_ORDER.ID_TMC_GROUP = ABC_RATINGS.IDGROUP;
                    """);
    } on Exception catch (ex) {
      log(ex.toString());
    }
  }
  Future optimize() async {
    try {
      await SqliteUtils("130")
          .executeScalar("SELECT VALUEINT FROM SIMPLE_PROPERTIES WHERE ID=1; ")
          .then((value) {
        daystodisplay = int.parse(value.toString());
      });

      await SqliteUtils("130")
          .executeReader(getDataScript())
          .then((value) => setDataTable(value));

      return _optimizeOrderStrategy_0();
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  Future _optimizeOrderStrategy_0() {
    try {
      List<Map<String, dynamic>> data;

/*
      /////////////////////////////////////////////////////////////////QUANTITY > 1 AND STOCKINDAYS > 3 AND PURCHPLAN > 1
      Where = string.Format("QUANTITY > 1 AND STOCKINDAYS > 3 AND PURCHPLAN > 1");
      Order = string.Format("STOCKINDAYS DESC");
*/
      data = getDataTable()
          .where((element) => double.parse(element["QUANTITY"].toString()) > 1)
          .where(
              (element) => double.parse(element["STOCKINDAYS"].toString()) > 3)
          .where((element) => double.parse(element["PURCHPLAN"].toString()) > 1)
          .toList();
      data.sort((b, a) {
        return double.parse(a["STOCKINDAYS"].toString())
            .compareTo(double.parse(b["STOCKINDAYS"].toString()));
      });

      if (true == optimizeQUANTITY(data)) {
        return update();
      }

/*
      /////////////////////////////////////////////////////////////////Logic QUANTITY > 0 AND AVGSALE == 0
      Where = string.Format("QUANTITY > 0 AND AVGSALE = 0");
      Order = string.Format("AVGSALE ASC");
*/
      data = getDataTable()
          .where((element) => double.parse(element["QUANTITY"].toString()) > 0)
          .where((element) => double.parse(element["AVGSALE"].toString()) == 0)
          .toList();
      data.sort((a, b) => double.parse(a["AVGSALE"].toString())
          .compareTo(double.parse(b["AVGSALE"].toString())));

      if (true == optimizeQUANTITY(data)) {
        return update();
      }

/*
      /////////////////////////////////////////////////////////////////Logic ZeroDaysRatio > 0.9 
      Where = string.Format
          (
              "QUANTITY > 0 AND ZERODAYS / {0} > 0.9"
              , new DBPROPERTIES().simple_properties.daystodisplay.GetValue()
          );
      Order = string.Format("ZERODAYS DESC");
*/

      data = getDataTable()
          .where((element) => double.parse(element["QUANTITY"].toString()) > 0)
          .where((element) =>
              double.parse(element["ZERODAYS"].toString()) / daystodisplay >
              0.9)
          .toList();
      data.sort((b, a) => double.parse(a["ZERODAYS"].toString())
          .compareTo(double.parse(b["ZERODAYS"].toString())));

      if (true == optimizeQUANTITY(data)) {
        return update();
      }

/*
      /////////////////////////////////////////////////////////////////Logic QUANTITY > 1 AND STOCKINDAYS > 1 AND PURCHPLAN > 1
      Where = string.Format("QUANTITY > 1 AND STOCKINDAYS > 1 AND PURCHPLAN > 1");
      Order = string.Format("STOCKINDAYS DESC");
*/

      data = getDataTable()
          .where((element) => double.parse(element["QUANTITY"].toString()) > 1)
          .where(
              (element) => double.parse(element["STOCKINDAYS"].toString()) > 1)
          .where((element) => double.parse(element["PURCHPLAN"].toString()) > 1)
          .toList();
      data.sort((b, a) => double.parse(a["STOCKINDAYS"].toString())
          .compareTo(double.parse(b["STOCKINDAYS"].toString())));

      if (true == optimizeQUANTITY(data)) {
        return update();
      }

/*
      /////////////////////////////////////////////////////////////////Logic ZeroDaysRatio > 0.5 
      Where = string.Format
          (
              "QUANTITY > 0 AND ZERODAYS / {0} > 0.5"
              , new DBPROPERTIES().simple_properties.daystodisplay.GetValue()
          );
      Order = string.Format("ZERODAYS DESC");
*/

      data = getDataTable()
          .where((element) => double.parse(element["QUANTITY"].toString()) > 0)
          .where((element) =>
              double.parse(element["ZERODAYS"].toString()) / daystodisplay >
              0.5)
          .toList();
      data.sort((b, a) => double.parse(a["ZERODAYS"].toString())
          .compareTo(double.parse(b["ZERODAYS"].toString())));

      if (true == optimizeQUANTITY(data)) {
        return update();
      }

/*
      /////////////////////////////////////////////////////////////////Logic ZeroDaysRatio > 0.3 
      Where = string.Format
          (
              "QUANTITY > 0 AND ZERODAYS / {0} > 0.3"
              , new DBPROPERTIES().simple_properties.daystodisplay.GetValue()
          );
      Order = string.Format("ZERODAYS DESC");
*/

      data = getDataTable()
          .where((element) => double.parse(element["QUANTITY"].toString()) > 0)
          .where((element) =>
              double.parse(element["ZERODAYS"].toString()) / daystodisplay >
              0.3)
          .toList();
      data.sort((b, a) => double.parse(a["ZERODAYS"].toString())
          .compareTo(double.parse(b["ZERODAYS"].toString())));

      if (true == optimizeQUANTITY(data)) {
        return update();
      }

/*
      /////////////////////////////////////////////////////////////////Logic QUANTITY > 0 AND PURCHPLAN > 1
      Where = string.Format("QUANTITY > 0 AND PURCHPLAN > 1");
      Order = string.Format("AVGPURCHPRICE DESC, PURCHPLAN DESC");
*/

      data = getDataTable()
          .where((element) => double.parse(element["QUANTITY"].toString()) > 0)
          .where((element) => double.parse(element["PURCHPLAN"].toString()) > 1)
          .toList();
      data.sort((b, a) {
        int cmp = double.parse(a["AVGPURCHPRICE"].toString())
            .compareTo(double.parse(b["AVGPURCHPRICE"].toString()));
        if (cmp != 0) return cmp;
        return double.parse(a["PURCHPLAN"].toString())
            .compareTo(double.parse(b["PURCHPLAN"].toString()));
      });

      if (true == optimizeQUANTITY(data)) {
        return update();
      }

/*
      /////////////////////////////////////////////////////////////////Logic QUANTITY > 0
      Where = string.Format("QUANTITY > 0");
      Order = string.Format("AVGPURCHPRICE DESC, AVGSALE ASC");
*/

      data = getDataTable()
          .where((element) => double.parse(element["QUANTITY"].toString()) > 0)
          .toList();
      data.sort((a, b) {
        int cmp = double.parse(b["AVGPURCHPRICE"].toString())
            .compareTo(double.parse(a["AVGPURCHPRICE"].toString()));
        if (cmp != 0) return cmp;
        return double.parse(a["AVGSALE"].toString())
            .compareTo(double.parse(b["AVGSALE"].toString()));
      });

      if (true == optimizeQUANTITY(data)) {
        return update();
      }

/*
      /////////////////////////////////////////////////////////////////Logic PURCHPLAN > 0
      Where = string.Format("PURCHPLAN > 0");
      Order = string.Format("AVGPURCHPRICE DESC");
*/

      data = getDataTable()
          .where((element) => double.parse(element["PURCHPLAN"].toString()) > 0)
          .toList();
      data.sort((b, a) => double.parse(a["AVGPURCHPRICE"].toString())
          .compareTo(double.parse(b["AVGPURCHPRICE"].toString())));

      optimizeQUANTITY(data);

      return update();
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  bool optimizeQUANTITY(List<Map<String, dynamic>> data) {
    try {
      /*
            OptimizeQUANTITY1(Where, Order);
            if (GetDataTable().AsEnumerable().Where(x => x["QUANTITY", DataRowVersion.Current].ToDouble() > 0).Count() > 0)
                return Check();

            GetDataTable().RejectChanges();
            Order = "AVGPURCHPRICE DESC, QUANTITY DESC";

            OptimizeQUANTITY1(Where, Order);

            return Check();
      */
      if (true == optimizeQUANTITY1(List<Map<String, dynamic>>.from(data)))
        return true;

      data.sort((b, a) {
        int cmp = double.parse(a["AVGPURCHPRICE"].toString())
            .compareTo(double.parse(b["AVGPURCHPRICE"].toString()));
        if (cmp != 0) return cmp;
        return double.parse(a["QUANTITY"].toString())
            .compareTo(double.parse(b["QUANTITY"].toString()));
      });
      if (true == optimizeQUANTITY1(List<Map<String, dynamic>>.from(data)))
        return true;

      return false;
    } on Exception catch (ex) {
      log(ex.toString());
      return false;
    }
  }

  bool optimizeQUANTITY1(List<Map<String, dynamic>> data) {
    try {
      /*
          while (GetDataTable().Select(Where, Order).Count(x => x["QUANTITY", DataRowVersion.Current].ToDouble() > 0) > 0)
              foreach (DataRow dr in GetDataTable().Select(Where, Order).Where(x => x["QUANTITY", DataRowVersion.Current].ToDouble() > 0))
              {
                  double NewValue = dr["QUANTITY", DataRowVersion.Current].ToDouble() - 1;
                  if (0 > NewValue)
                      NewValue = 0;

                  dr["QUANTITY"] = NewValue;

                  if (true == Check())
                      return true;
              }

          return false;
      */
      while (data
              .where(
                  (element) => double.parse(element["QUANTITY"].toString()) > 0)
              .length >
          0)
        for (var dr in data.where(
            (element) => double.parse(element["QUANTITY"].toString()) > 0)) {
          double newValue = double.parse(dr["QUANTITY"].toString()) - 1;

          data.firstWhere((element) {
            return element["ID"] == dr["ID"];
          })["QUANTITY"] = newValue;

          Map<String, dynamic> m = getDataTable().firstWhere((element) {
            return element["ID"] == dr["ID"];
          });
          m["QUANTITY"] = newValue;
          m["NEED_UPDATE"] = 1;

          if (true == check()) return true;
        }

      return false;
    } on Exception catch (ex) {
      log(ex.toString());
      return false;
    }
  }

  bool check() {
    try {
      /*
          return GetDataTable().AsEnumerable().Sum(c => c["SUMM", DataRowVersion.Current].ToDouble()) < GetOrderLimit();
          SUMM= CURRENT_ORDER.QUANTITY*DIAG_ATTRIBUTES.AVGPURCHPRICE
      */
      double sum = 0;
      getDataTable().forEach((element) {
        sum += double.parse(element["QUANTITY"].toString()) *
            double.parse(element["AVGPURCHPRICE"].toString());
      });
      return sum <= getOrderLimit();
    } on Exception catch (ex) {
      log(ex.toString());
      return false;
    }
  }

  Future update() async {
    try {
/*          
            GetDataTable().TableName = "CURRENT_ORDER";

            DataTable dt = GetDataTable().Clone();
            foreach (DataRow dr in GetDataTable().GetChanges().Rows)
            {
                dr["SUM"] = dr["QUANTITY"].ToDouble() * dr["PRICE"].ToDouble();
                dt.ImportRow(dr);
            }

            dt.Columns.Remove("CURRENTSTOCK");
            dt.Columns.Remove("AVGSALE");
            dt.Columns.Remove("PURCHPLAN");
            dt.Columns.Remove("ZERODAYS");
            dt.Columns.Remove("STOCKINDAYS");
            dt.Columns.Remove("PRICE");

            dt.Columns["SUMM"].Expression = "";
            dt.Columns.Remove("AVGPURCHPRICE");
            dt.Columns.Remove("SUMM");
            dt.Columns.Remove("ABCRATING");
            dt.Columns.Remove("COUNT_A");

            dt.AcceptChanges();

            string Script = new GenerateSQL().CreateUpdateCommand(dt);

            new DBUtils().ExecuteNonQueryTurbo(Script);
*/

      for (Map<String, dynamic> dr in getDataTable().where(
          (element) => double.parse(element["NEED_UPDATE"].toString()) == 1)) {
        if (0 == double.parse(dr["QUANTITY"].toString())) {
          await SqliteUtils("130").executeNonQuery(
              'DELETE FROM CURRENT_ORDER WHERE ID =${dr["ID"].toString()};');
        } else {
          await SqliteUtils("130").executeNonQuery(
              'UPDATE CURRENT_ORDER SET QUANTITY=${dr["QUANTITY"].toString()},SUM=${dr["QUANTITY"].toString()}*${dr["PRICE"].toString()} WHERE ID = ${dr["ID"].toString()}');
        }
      }
    } on Exception catch (ex) {
      log(ex.toString());
      return null;
    }
  }
}
