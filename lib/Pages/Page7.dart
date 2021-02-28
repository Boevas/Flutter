import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:test4/pdf/PdfUtils.dart';

class Page7 extends StatefulWidget {
  @override
  _Page7State createState() => new _Page7State();
}

class _Page7State extends State<Page7> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();

    PdfUtils().open("Test.pdf").then((f) {
      setState(() {
        pathPDF = f;
        print(pathPDF);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Center(
        child: RaisedButton(
          child: Text("View PDF from resources"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _PDFScreen(pathPDF)),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _PDFScreen extends StatefulWidget {
  String _pathPDF = "";
  _PDFScreen(this._pathPDF);

  @override
  __PDFScreenState createState() => __PDFScreenState();
}

class __PDFScreenState extends State<_PDFScreen> {
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document Pdf"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: widget._pathPDF);
  }
}
