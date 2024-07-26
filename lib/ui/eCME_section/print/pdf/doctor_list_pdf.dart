import 'package:MREPORTING_OFFLINE/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/print/util/doctor_list_utils.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class DoctorListPdfScreen extends StatefulWidget {
  final ApprovedPrintDataModel wholeData;
  final DataListPrint dataListPrint;
  const DoctorListPdfScreen({
    super.key,
    required this.wholeData,
    required this.dataListPrint,
  });

  @override
  State<DoctorListPdfScreen> createState() => _DoctorListPdfScreenState();
}

class _DoctorListPdfScreenState extends State<DoctorListPdfScreen> {
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
    final acitons = <PdfPreviewAction>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor List PDF(${widget.dataListPrint.sl})',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: PdfPreview(
        allowSharing: true,
        allowPrinting: true,
        maxPageWidth: 700,
        actions: acitons,
        onPrinted: (BuildContext context) => DoctorListPrintUtil()
            .showPrintedToast(context, widget.wholeData, widget.dataListPrint),
        onShared: (BuildContext context) => DoctorListPrintUtil()
            .showSharedToast(context, widget.wholeData, widget.dataListPrint),
        build: (PdfPageFormat format) => DoctorListPrintUtil()
            .generatePdf(format, widget.wholeData, widget.dataListPrint),
      ),
    );
  }
}
