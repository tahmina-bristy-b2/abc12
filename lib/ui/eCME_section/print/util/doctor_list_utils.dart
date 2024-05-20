
import 'dart:io';
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DoctorListPrintUtil {
  Future<Uint8List> generatePdf(
      final PdfPageFormat format,
      ApprovedPrintDataModel wholeData,
      DataListPrint dataListPrint) async {
    final doc = pw.Document(title: 'Bill Expense(${dataListPrint.sl})');
    final logoUint8List = pw.MemoryImage(
        (await rootBundle.load('assets/images/comp_logo1.png'))
            .buffer
            .asUint8List());

    List<String> header = [
      "SL.No.",
      "NAME OF DOCTOR",
      "CONTACT NO.",
      "SIGN"
    ];

    List<List<String>> doctorData() {
      List<List<String>> doctorListNew = [];
      if (dataListPrint.doctorList != null) {
        for (int i = 0; i < dataListPrint.doctorList.length; i++) {
          doctorListNew.add([
            "${i + 1}",
            dataListPrint.doctorList[i].doctorName,
            "",
            ""
          ]);
        }
      }
      return doctorListNew;
    }

    const int rowsPerPage = 100;
    List<List<String>> allDoctorData = doctorData();
    int totalPages = (allDoctorData.length / rowsPerPage).ceil();
    for (int pageIndex = 1; pageIndex <= totalPages; pageIndex++) {
      int start = (pageIndex - 1) * rowsPerPage;
      int end = start + rowsPerPage;
      List<List<String>> pageData = allDoctorData.sublist(
        start,
        end > allDoctorData.length ? allDoctorData.length : end,
      );

      doc.addPage(
        pw.MultiPage(
          header: (context) => buildHeader(context, logoUint8List, dataListPrint),
           footer: (pw.Context context) => buildPageFooter(context, context.pageNumber ),
          build: (final context) => [
            pw.Table.fromTextArray(
              context: context,
              data: [header, ...pageData],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 8,
              ),
              cellStyle: const pw.TextStyle(
                fontSize: 6.5,
              ),
              border: pw.TableBorder.all(width: 0.3),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey100,
              ),
              cellHeight: 6,
              headerHeight: 10,
              cellAlignments: {
                0: pw.Alignment.centerRight,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
              },
              columnWidths: {
                0: const pw.FlexColumnWidth(1.7),
                1: const pw.FlexColumnWidth(8),
                2: const pw.FlexColumnWidth(6),
                3: const pw.FlexColumnWidth(6),
              },
            ),
            pw.Spacer(flex: 1),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                height: 15,
                width: 300,
                child: pw.Column(
                  children: [
                    pw.Container(color: PdfColors.black, height: 0.5),
                    pw.Expanded(
                        child: pw.Align(
                          alignment:pw. Alignment.centerRight,
                          child: pw.Text(
                            dataListPrint.correspondenceFormatDictData.signatureAndTitle,
                            style: const pw.TextStyle(fontSize: 8))
                        )
                        ),
                  ],
                ),
              ),
            )
          ],
           
        ),
      );
    }
    return doc.save();
  }
 pw.Widget buildPageFooter(pw.Context context, int pageNumber) {
  return pw.Container(
    alignment: pw.Alignment.centerRight,
    margin: const pw.EdgeInsets.only(top: 20.0),
    child: pw.Text(
      'Page $pageNumber ',
      style: const pw.TextStyle(fontSize: 8),
    ),
  );
}



  pw.Widget buildHeader(pw.Context context, pw.MemoryImage logo, DataListPrint dataListPrint) {
    return pw.Center(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
              child: pw.Container(
            child: pw.Image(logo),
            width: 50,
            height: 50,
          )),
          pw.Center(
              child: pw.Text("Eskayef Pharmaceuticals Limited",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 4),
          pw.Center(
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                pw.Text("CORRESPONENCE DETAILS 0F DOCTORS",
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ])),
          pw.SizedBox(height: 6),
          pw.Container(height: 0.5, color: PdfColors.black),
          pw.SizedBox(height: 10),
          expenseTableRowWidget("SL NO", dataListPrint.sl),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
          expenseTableRowWidget("MEETINGS DATE & TIME", dataListPrint.meetingDate),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
          expenseTableRowWidget("MEETINGS TOPIC", dataListPrint.meetingTopic),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
          expenseTableRowWidget("MEETINGS VENUE", dataListPrint.meetingVenue),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
          pw.Text("Dear Doctor,", style: const pw.TextStyle(fontSize: 11)),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 4)),
          pw.Text(dataListPrint.correspondenceFormatDictData.greetings.toString(),
              style: const pw.TextStyle(fontSize: 11)),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 8)),
         pw.SizedBox(
  child: pw.RichText(
    text: pw.TextSpan(
      style: const pw.TextStyle(fontSize: 11),
      children: [
        pw.TextSpan(
          text: dataListPrint.correspondenceFormatDictData.firstLineHeader,
        ),
        const pw.TextSpan(text:" "),
        pw.TextSpan(
          text: dataListPrint.correspondenceFormatDictData.boldLine,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        const pw.TextSpan(text:" "),
        pw.TextSpan(
          text: dataListPrint.correspondenceFormatDictData.firstLineFooter,
        ),
      ],
      
    ),
      textAlign: pw.TextAlign.justify,
  ),
),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 8)),
          pw.Text(
              "To communicate you in future, we wish to have the following particulars of you please:",
              style: const pw.TextStyle(fontSize: 11)),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 8)),
        ],
      ),
    );
  }

  pw.Row expenseTableRowWidget(String title, String value) {
    return pw.Row(children: [
      pw.Expanded(
          flex: 2,
          child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(title,
                  style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)))),
      pw.SizedBox(child: pw.Text(":")),
      pw.Expanded(
          flex: 3,
          child: pw.Text("    $value", style: const pw.TextStyle(fontSize: 11))),
    ]);
  }

  Future<void> saveAsFile(
    final BuildContext context,
    final LayoutCallback build,
    final PdfPageFormat pageFormat,
    final String filePath,
  ) async {
    try {
      final bytes = await build(pageFormat);
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF saved at: ${file.path}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving PDF: $e")),
      );
    }
  }

  void showPrintedToast(final BuildContext context,
      ApprovedPrintDataModel wholeData, DataListPrint dataListPrint) async {
    try {
      final result = await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return generatePdf(format, wholeData, dataListPrint);
        },
      );
      if (result) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Doctor List(${dataListPrint.sl}) printed successfully")),
          );
        }
      }
    } catch (e) {
      print("Error printing document: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error printing document: $e")),
      );
    }
  }

  void showSharedToast(final BuildContext context, ApprovedPrintDataModel wholeData,
      DataListPrint dataListPrint) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Doctor List(${dataListPrint.sl}) shared successfully done")));
  }
}