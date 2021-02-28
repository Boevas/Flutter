/*import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Page8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'MyFont'),
      home: Scaffold(
        appBar: AppBar(title: Text("")),
        body: PdfPreview(
          build: (format) => _generatePdf(format, 'Сновым годом !!!'),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String text) async {
    var fontdata = await rootBundle.load("assets/font/OpenSans-Bold.ttf");
    var myFont = pw.Font.ttf(fontdata);
    var myStyle = pw.TextStyle(
        font: myFont,
        fontSize: 50,
        letterSpacing: 3,
        color: PdfColor.fromHex('#3269a8'));

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(text, style: myStyle),
          );
        },
      ),
    );

    return pdf.save();
  }
}

*/
