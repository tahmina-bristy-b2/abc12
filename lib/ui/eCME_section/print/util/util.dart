import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


Future<Uint8List> generatePdf(final PdfPageFormat format) async {
  final doc = pw.Document(title: 'Flutter School');
  // final logoImage = pw.MemoryImage(
  //     (await rootBundle.load('assets/images/pigeon.png')).buffer.asUint8List());
  // final footerImage = pw.MemoryImage(
  //     (await rootBundle.load('assets/images/footer.png')).buffer.asUint8List());
  final font = await rootBundle.load('assets/Montserrat-Regular.ttf');
  final ttf = pw.Font.ttf(font);

  //final pageTheme = await _myPageTheme(format);
  List<List<String>> tableData = [
    ['Expense Particulars ', 'Expense amount(Taka)', 'Remarks'],
    ['Morning/Evenning Refreshment', '', ''],
    ['Lunch/Dinner/Snacks', '', ''],
    ['Stationaries(Pen,Photocopies etc)', '', ''],
    ['Gifts or souvenir', '', ''],
    ['Miscellaneous(Banner,Sound etc)', '', ''],
   
     ['', '', ''],
     ['Total :', '', ''],
     ['In words :', '', ''],
  ];

  List<List<String>> secondTable = [
    ['', 'Amount'],
    ['Advance Recieved (MI Number:......, Date:.......)[If approprite]', '' ],
    ['Amount Payable by/Refundable to the Company(TK)', ''],
    ['In words :', '', ],
   
    
  ];

  doc.addPage(
    pw.MultiPage(
    //  pageTheme: pageTheme,
      header: (final context) => pw.Column(
        children: [
          pw.Center(child: pw.Text("SK+F",style:const pw.TextStyle(fontSize: 24,color: PdfColors.blue ))),
         
          pw.Center(child: pw.Text("Eskayef Pharmaceuticals Limited",style:const pw.TextStyle(fontSize: 20 ))),
          pw.SizedBox(height: 3)
        ]
        //   alignment: pw.Alignment.topLeft,
        //  // logoImage,
        //   fit: pw.BoxFit.contain,
        //   width: 180
          
          ),
      // footer: (final context) =>
      //     pw.Image(footerImage, fit: pw.BoxFit.scaleDown),
      build: (final context) => [
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 5, bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Row(children: [
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text("BILL SUBMISSION DATE :",style:const pw.TextStyle(fontSize: 9))
                )),
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text("ID NUMBER OF ASM/RSM:",style:const pw.TextStyle(fontSize: 9))
                )),
              ]),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
              expenseTableRowWidget("NAME & TERR.CODE OF AM/FM ", ""),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("NAME & REGION OF ASM/RSM  ", ""),
              pw.Padding(padding: const pw.EdgeInsets.only(top:2)),
              expenseTableRowWidget("ESKAYEF PERSONS ATTENDED", ""),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("ESKAYEF PERSONS ATTENDED", ""),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING VENUE", ""),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING DATE", ""),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("TOTAL NO. OF PARTICIPATING DOCTORS", ""),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING TOPIC", ""),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("NAME OF REMINDED BRANDS", ""),
            ],
          ),
        ),
    
        pw.SizedBox(height: 4),
        pw.Table.fromTextArray(
          context: context,
          data: tableData,
          headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 9),
          cellStyle: pw.TextStyle(font: ttf,fontSize: 7),
          border: pw.TableBorder.all(width: 0.5),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          cellHeight: 9,
          headerHeight: 12,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            2: pw.Alignment.center,
          },
        ),
        pw.SizedBox(height: 3),
        pw.Table.fromTextArray(
          context: context,
          data: secondTable,
          headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 9),
          cellStyle: pw.TextStyle(font: ttf,fontSize: 7),
          border: pw.TableBorder.all(width: 0.5),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          cellHeight: 9,
          headerHeight: 12,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            
          },
        ),

        pw.SizedBox(height: 35),
        
        pw.Container(
          height: 14,
          child: pw.Row(
            children:[
              signatureWIdget("Signed by","MSO",),
              pw.SizedBox(width: 10,),
              signatureWIdget("Signed by","Area/Field Manager",),
              pw.SizedBox(width: 10,),
              signatureWIdget("Endorsed by","Regional Head",),
              pw.SizedBox(width: 10,),
              signatureWIdget("Checked by","Zonal Head",),
              pw.SizedBox(width: 10,),
              signatureWIdget("Checked by","Dpt. of Medical Affairs",),     
            ]
          )
        ),
        pw.SizedBox(height: 30),
        pw.Container(
          height: 14,
          child: pw.Row(
            children:[
            
              signatureWIdget("Recommended by","AGM,Medical Affairs",),
              pw.SizedBox(width: 10,),
              signatureWIdget("Approved By","HOS/GM Sales",),
              pw.SizedBox(width: 10,),
              signatureWIdget("Approved By","GM Marketing",),
              pw.SizedBox(width: 10,),
              signatureWIdget("Approved By","Additional Director\nMarketing & Sales",),
               
            ]
          )
        ),
       pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 5, bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Padding(padding: const pw.EdgeInsets.only(top: 7)),
              pw.Row(children: [
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text("Finance & Administration Department ",style: pw.TextStyle(fontWeight:pw.FontWeight.bold,fontSize: 10))
                )),
                pw.SizedBox(child: pw.Text(":")),
                 pw.Expanded(flex: 2,
                child: pw.Text("")),
              ]),
              
            
            ],
          ),
        ),
         pw.SizedBox(height: 30),
        pw.Container(
          height: 15,
          child: pw.Row(
            children:[
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                    children: [
                      pw.Container(color:PdfColors.black,height: 1,width: 100),
                      pw.Expanded(child: pw.Text("Checked by",style:const pw.TextStyle(fontSize: 9))),
                    

                    ],
                  ),
              ),
               pw.Expanded(
                flex: 2,
                child: pw.Column(
                    children: [
                      pw.Container(color:PdfColors.black,height: 1,width: 100),
                      pw.Expanded(child: pw.Text("verified By",style:const pw.TextStyle(fontSize: 9))),
                      
                    ],
                  ),
              ),
               pw.Expanded(
                flex: 4,
                child: pw.Column(
                    children: [
                      pw.Container(color:PdfColors.black,height: 1,width: 200),
                      pw.Expanded(child: pw.Text("Approved for Payment",style:const pw.TextStyle(fontSize: 9))),
                     

                    ],
                  ),
              ),
               
               
            ]
          )
        )
      ],
    ),
  );
  return doc.save();
}

pw.Expanded signatureWIdget(String title,String designation) {
  return pw.Expanded(
              child: pw.Column(
                  children: [
                    pw.Container(color:PdfColors.black,height: 1),
                    pw.SizedBox(height: 2),
                    pw.Expanded(child: pw.Text(title,style:const pw.TextStyle(fontSize: 5))),
                  
                    pw.Expanded(child: pw.Text(designation,style:const pw.TextStyle(fontSize: 7))),

                  ],
                ),
            );
}

// Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
//   final logoImage = pw.MemoryImage(
//       (await rootBundle.load('assets/images/watermark.png')).buffer.asUint8List());
//   return pw.PageTheme(
//       margin: const pw.EdgeInsets.symmetric(
//           horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
//       textDirection: pw.TextDirection.ltr,
//       orientation: pw.PageOrientation.portrait,
//       buildBackground: (final context) => pw.FullPage(
//           ignoreMargins: true,
//           child: pw.Watermark(
//               angle: 20,
//               child: pw.Opacity(
//                   opacity: 0.3,
//                   child: pw.Image(
//                       alignment: pw.Alignment.center,
//                       logoImage,
//                       fit: pw.BoxFit.cover)))));
// }

pw.Row expenseTableRowWidget(String title, String value) {
  return pw.Row(children: [
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text(title,style:const pw.TextStyle(fontSize: 9))
                )),
                pw.SizedBox(child: pw.Text(":")),
                 pw.Expanded(flex: 3,
                child: pw.Text(value)),
              ]);

}

// Future<void> saveAsFile(final BuildContext context, final LayoutCallback build,
//     final PdfPageFormat pageFormat) async {
//   final bytes = await build(pageFormat);
//   final appDocDir = await getApplicationDocumentsDirectory();
//   final appDocPath = appDocDir.path;
//   final file = File('$appDocPath/document.pdf');
//   print("save as file ${file.path}.......");
//   await file.writeAsBytes(bytes);
//   await OpenFile.open(file.path);
// }
Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
  final String filePath, // Add a parameter for the file path
) async {
  try {
    final bytes = await build(pageFormat);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    print("File saved at: ${file.path}");
    // You might want to show a message to the user indicating successful saving
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved at: ${file.path}")),
    );
  } catch (e) {
    print("Error saving file: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving PDF: $e")),
    );
  }
}
void showPrintedToast(final BuildContext context) async {
  try {
    final result = await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return generatePdf(format); // Call your function to generate the PDF
      },
    );
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Document printed successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to print document")),
      );
    }
  } catch (e) {
    print("Error printing document: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error printing document: $e")),
    );
  }
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Document shared successfully done")));
}
