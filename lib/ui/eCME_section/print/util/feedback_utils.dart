  import 'dart:io';
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillFeedbackUtils{
Future<Uint8List> generatePdf(final PdfPageFormat format,  ApprovedPrintDataModel wholeData, DataListPrint dataListPrint) async {
  final doc = pw.Document(title: 'Feedback Letter(${dataListPrint.sl})');
  final  logoUint8List = pw.MemoryImage(
      (await rootBundle.load('assets/images/comp_logo1.png')).buffer.asUint8List());
  final font = await rootBundle.load('assets/Montserrat-Regular.ttf');

  doc.addPage(
    pw.MultiPage(
      header: (final context) => pw.Column(
        children: [
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
          pw.Container(height: 0.5,color: PdfColors.black),
            pw.SizedBox(height: 8),
        ]   
      ),
      
      build: (final context) => [
        pw.Container(
          padding: const pw.EdgeInsets.only( bottom: 6),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.SizedBox(height: 5),
              
              pw.Row(children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text("Date",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))
                )),
                pw.Text("  :  ",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                pw.Expanded(
                  flex:23,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text(dataListPrint.feedbackFormatDictData.date,style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))
                )),
              ]),
              pw.SizedBox(height: 10),
              pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text("To, ${dataListPrint.feedbackFormatDictData.to}",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text("From",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))
                )),
                pw.Text("  :  ",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                pw.Expanded(
                  flex:23,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text(dataListPrint.feedbackFormatDictData.from,style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))
                )),
              ]),
               pw.SizedBox(height: 5),
              pw.SizedBox(
                height: 60,
                  child: pw.Row(
                children: [
                pw.SizedBox(
                  height: 60,
                  child: pw.Expanded(
                  flex: 3,
                  child: pw.Align(alignment: pw.Alignment.topLeft,
                  child: pw.Text("Copy       ",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))
                )),
                ),
                pw.Align(alignment:pw.Alignment.topCenter,
                  child: pw.Text("  :  ",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                ),
                pw.Expanded(
                  flex: 23,
                  child: pw.ListView.builder(
                       itemCount: dataListPrint.feedbackFormatDictData.copy.length,
                      itemBuilder:( (context, index) {
                        return pw.SizedBox(
                          child:pw. Row(
                            children: [
                              pw.Text("${dataListPrint.feedbackFormatDictData.copy[index]}  ",style:const pw.TextStyle(fontSize: 12)),
                            ]
                          )
                        );  
                      }) 
                     )
                ),
              
               ]
             ),
            ),
             pw.SizedBox(height: 5),
            pw.Row(children: [
                pw.Expanded(
                  flex:3 ,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text("Subject   ",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))
                )),
                pw.Text("  :  ",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                pw.Expanded(
                  flex:23,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text(dataListPrint.feedbackFormatDictData.subject,style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))
                )),
              ]),
             pw.SizedBox(height: 10),
              pw.Row(children: [
                pw.Expanded(
                  flex:3 ,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text("Sir ,   ",style: const pw.TextStyle(fontSize: 13,))
                )),
                pw.Text("    ",style: const pw.TextStyle(fontSize: 12,)),
                pw.Expanded(
                  flex:23,
                  child: pw.Align(alignment: pw.Alignment.centerLeft,
                  child: pw.Text("   ",style: const pw.TextStyle(fontSize: 12,))
                )),
              ]),
           
            ],
          ),
        ),
      ],
    ),
  );
  return doc.save();
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
    print("Error saving file: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving PDF: $e")),
    );
  }
}

void showPrintedToast(final BuildContext context, ApprovedPrintDataModel wholeData,DataListPrint dataListPrint) async {
  try {
    final result = await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return generatePdf(format,wholeData,dataListPrint); 
      },
    );
    if (result) {
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Feedback Letter (${dataListPrint.sl}) printed successfully")),
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
       SnackBar(content: Text("Feedback Letter(${dataListPrint.sl}) shared successfully done")));
}

}