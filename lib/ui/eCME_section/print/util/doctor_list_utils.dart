import 'dart:io';
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DoctorListPrintUtil{
  
Future<Uint8List> generatePdf(final PdfPageFormat format,  ApprovedPrintDataModel wholeData, DataListPrint dataListPrint) async {

  final doc = pw.Document(title: 'Bill Expense(${dataListPrint.sl})');
  final  logoUint8List = pw.MemoryImage(
      (await rootBundle.load('assets/images/comp_logo1.png')).buffer.asUint8List());


  List<String> header = ["No", "Doctor Name","Doctor ID"];
  List<List<String>> doctorData() {
  List<List<String>> doctorListNew = [];
    if (dataListPrint.doctorList != null) {
      for (int i = 0; i < dataListPrint.doctorList.length; i++) {
        doctorListNew.add(["${i + 1}", dataListPrint.doctorList[i].doctorName, dataListPrint.doctorList[i].doctorId]);
      }
    }
    return doctorListNew;
  }


  doc.addPage(
    pw.MultiPage(
      build: (final context) => [
        pw.Center(
              child: pw.Center(
              child: pw.Container(
                child: pw.Image(logoUint8List),
                width: 50, 
                height: 50,
              ),
            )
          ),
          pw.Center(child: pw.Text("Eskayef Pharmaceuticals Limited",style: pw.TextStyle(fontSize: 18,fontWeight: pw.FontWeight.bold ))),
          pw.SizedBox(height: 8),
          pw.Center(child: pw.Text("Doctor List on",style: pw.TextStyle(fontSize: 10,fontWeight:pw.FontWeight.bold ))),
          pw.Center(child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
            pw.Text("Clinical / RMP / PGO / Intern Reception Meeting Expense bill ",style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
          ])),
          pw.SizedBox(height: 2),
          pw.Container(height: 0.5,color: PdfColors.black),
          pw.SizedBox(height: 10),
          expenseTableRowWidget("SL NO", dataListPrint.sl),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
          expenseTableRowWidget("TOTAL NO. OF PARTICIPATING DOCTORS", dataListPrint.doctorList.length.toString()),
          pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
          expenseTableRowWidget("PARTICIPATING DOCTORS", ""),
          pw.Table.fromTextArray(
                    context: context,
                    data: [header, ...doctorData()],
                    headerStyle: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: 8),
                    cellStyle: const pw.TextStyle(fontSize: 6.5,),
                    border: pw.TableBorder.all(width: 0.5),
                    headerDecoration: const pw.BoxDecoration(
                      color: PdfColors.grey100
                    ),
                    cellHeight: 6,
                    headerHeight: 10,
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.centerLeft,
                    },
                    columnWidths: {
                      0: const pw.FlexColumnWidth(1),
                      1: const pw.FlexColumnWidth(9), 
                      2:const pw.FlexColumnWidth(4), 
                    },
                  ),
      ],
    ),
  );
  return doc.save();
}

  pw.Row expenseTableRowWidget(String title, String value) {
    return pw.Row(children: [
                  pw.Expanded(flex: 2,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text(title,style: pw.TextStyle(fontSize: 7.5,fontWeight: pw.FontWeight.bold))
                  )),
                  pw.SizedBox(child: pw.Text(":")),
                  pw.Expanded(flex: 3,
                  child: pw.Text("    $value",style: const pw.TextStyle(fontSize:  7.5))),
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
    if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved at: ${file.path}")),
    );

    }
    
  } catch (e) {
    //print("Error saving file: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving PDF: $e")),
    );
  }
}
void showPrintedToast(final BuildContext context, ApprovedPrintDataModel wholeData,DataListPrint dataListPrint,) async {
  try {
    final result = await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return generatePdf(format,wholeData,dataListPrint,); 
      },
    );
    if (result) {
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Doctor List(${dataListPrint.sl}) printed successfully")),
      );
      }
    } else {
      
    }
  } catch (e) {
    print("Error printing document: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error printing document: $e")),
    );
  }
}

void showSharedToast(final BuildContext context, ApprovedPrintDataModel wholeData,DataListPrint dataListPrint) {
  ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Doctor List(${dataListPrint.sl}) shared successfully done")));
}

}