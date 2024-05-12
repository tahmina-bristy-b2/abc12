
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:MREPORTING/ui/eCME_section/print/util/feedback_utils.dart';
import 'package:MREPORTING/ui/eCME_section/print/util/util.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class BillfeedbackPrint extends StatefulWidget {
 final ApprovedPrintDataModel wholeData;
 final DataListPrint dataListPrint;
 final Map<String,dynamic> editedData;

 const  BillfeedbackPrint({
     super.key,
     required this.wholeData,
     required this.dataListPrint,
     required this.editedData
    }) ;

  @override
  State<BillfeedbackPrint> createState() => _BillfeedbackPrintState();
}

class _BillfeedbackPrintState extends State<BillfeedbackPrint> {
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

    return   Scaffold(
      appBar: AppBar(
        title:  Text('Feedback Letter(${widget.dataListPrint.sl})',style:const TextStyle(fontSize: 16),),
      ),
      body: PdfPreview(
        allowSharing: true,
        allowPrinting: true,
        maxPageWidth: 700,

        actions: acitons,
        onPrinted: (BuildContext context) =>BillFeedbackUtils().showPrintedToast(context,widget.wholeData, widget.dataListPrint,widget.editedData) ,
        onShared: (BuildContext context) =>BillFeedbackUtils(). showSharedToast(context,widget.wholeData, widget.dataListPrint,widget.editedData) ,
        build: (PdfPageFormat format) =>BillFeedbackUtils(). generatePdf(format,widget.wholeData,widget.dataListPrint,widget.editedData),
      ),
    );
  }
}



