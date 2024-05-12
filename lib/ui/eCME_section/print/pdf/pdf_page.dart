
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:MREPORTING/ui/eCME_section/print/util/util.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPage extends StatefulWidget {
ApprovedPrintDataModel wholeData;
  DataListPrint dataListPrint;
   PdfPage({
     super.key,
     required this.wholeData,
     required this.dataListPrint}) ;

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
        title:  Text('Bill Expense PDF(${widget.dataListPrint.sl})',style:const TextStyle(fontSize: 16),),
      ),
      body: PdfPreview(
        allowSharing: true,
        allowPrinting: true,
        maxPageWidth: 700,

        actions: acitons,
        onPrinted: (BuildContext context) => showPrintedToast(context,widget.wholeData, widget.dataListPrint) ,
        onShared: (BuildContext context) => showSharedToast(context,widget.wholeData, widget.dataListPrint) ,
        build: (PdfPageFormat format) => generatePdf(format,widget.wholeData,widget.dataListPrint),
      ),
    );
  }
}



