import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class UrlText extends pw.StatelessWidget {
  final String text;
  final String url;
  final pw.Font font;
  UrlText(this.text, this.url, this.font);

  @override
  pw.Widget build(final pw.Context context) => pw.UrlLink(
        destination: url,
        child: pw.Text(text,
            style: pw.TextStyle(
                decoration: pw.TextDecoration.underline,
                font: font,
                color: PdfColors.blue)),
      );
}
