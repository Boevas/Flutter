import 'package:flutter/material.dart';
import 'package:test4/pdf/PdfUtils.dart';
import 'package:test4/widgets/PdfWidget.dart';

class Page9 extends StatefulWidget {
  @override
  _Page9State createState() => new _Page9State();
}

class _Page9State extends State<Page9> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Center(
        child: RaisedButton(
            child: Text("View PDF Document from HTML https://google.com"),
            onPressed: () async {
              PdfUtils()
                  .url(
                      'https://www.google.com/search?q=%D1%81+%D0%BD%D0%BE%D0%B2%D1%8B%D0%BC+2021+%D0%B3%D0%BE%D0%B4%D0%BE%D0%BC&sxsrf=ALeKk03Ol3BM713jUfhE9u-I5DcBPKmcVQ:1609243706171&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiy-9n7k_PtAhVElYsKHXNoArMQ_AUoAXoECBIQAw&biw=1920&bih=912',
                      "Test")
                  .then((filepath) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfWidget(filepath: filepath)),
                );
              });
            }),
      ),
    );
  }
}
