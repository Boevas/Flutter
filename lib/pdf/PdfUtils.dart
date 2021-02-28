import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:http/http.dart' as http;

class PdfUtils {
  Future<String> open(String fileName) async {
    String dirName = "pdf";
    final dirpath =
        join((await getApplicationDocumentsDirectory()).path, dirName);
    if (false == await io.Directory(dirpath).exists())
      await io.Directory(dirpath).create();

    final filepath = join(dirpath, fileName);
    if (true == await io.File(filepath).exists())
      await io.File(filepath).delete();

    ByteData data = await rootBundle.load(join("assets/pdf", fileName));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await io.File(filepath).writeAsBytes(bytes);
    return filepath;
  }

  Future<String> url(String url, String fileName) async {
    String dirName = "pdf";
    final dirpath =
        join((await getApplicationDocumentsDirectory()).path, dirName);
    if (false == await io.Directory(dirpath).exists())
      await io.Directory(dirpath).create();

    final filepath = join(dirpath, fileName);
    if (true == await io.File(filepath).exists())
      await io.File(filepath).delete();

    var response = await http.get(url);
    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        response.body, dirpath, fileName);

    return generatedPdfFile.path;
  }
}
