import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:test4/widgets/ShareFileWidget.dart';

class PdfWidget extends StatelessWidget {
  final String title;

  final String sharePopupTitle;
  final String subject;
  final String text;
  final String filepath;
  PdfWidget(
      {this.title = "Document Pdf",
      this.sharePopupTitle = "Share Pdf",
      this.subject = "Pdf file",
      this.text = "sample text",
      this.filepath});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            ShareFileWidget(
                sharePopupTitle: sharePopupTitle,
                subject: subject,
                text: text,
                filepath: filepath)
          ],
        ),
        path: filepath);
  }
}
