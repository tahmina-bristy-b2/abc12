import 'package:MREPORTING/ui/eCME_section/print/util/util.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPage extends StatefulWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final acitons = <PdfPreviewAction>[
     
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter PDF"),
      ),
     
      body: PdfPreview(
        allowSharing: true,
        allowPrinting: true,
        maxPageWidth: 700,
        actions: acitons,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: generatePdf,
      ),
    );
  }
}



