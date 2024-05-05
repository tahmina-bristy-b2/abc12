import 'package:MREPORTING/models/e_CME/e_CME_approval_data_model.dart';
import 'package:MREPORTING/ui/eCME_section/print/util/util.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPage extends StatefulWidget {
  EcmeBrandListDataModel? eCMEApprovalData;
   PdfPage({super.key,required this.eCMEApprovalData}) ;

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
        onPrinted: (BuildContext context) => showPrintedToast(context,widget.eCMEApprovalData!) ,
        onShared: showSharedToast,
        build: (PdfPageFormat format) => generatePdf(format,widget.eCMEApprovalData!),
      ),
    );
  }
}



