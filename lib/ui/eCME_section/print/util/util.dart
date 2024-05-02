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

  //final pageTheme = await _myPageTheme(format);
  List<List<String>> tableData = [
    ['Expense Particulars ', 'Expense amount(Taka)', 'Remarks'],
    ['1. Morning/Evenning Refreshment', '', ''],
    ['2. Lunch/Dinner/Snacks', '', ''],
    ['3. Stationaries(Pen,Photocopies etc)', '', ''],
    ['4. Gifts or souvenir', '', ''],
    ['5. Miscellaneous(Banner,Sound etc)', '', ''],
   
     ['TOTAL :', '', ''],
     ['IN WORDS :', '', ''],
  ];

  List<List<String>> secondTable = [
    ['', 'Amount'],
    ['Advance Recieved (MI Number:......, Date:.......)[If approprite]', '' ],
    ["Total Expense",""],
    ['Amount Payable by/Refundable to the Company(TK)', ''],
    ['In words :', '', ],
    
  ];

  doc.addPage(
    pw.MultiPage(
    //  pageTheme: pageTheme,
      header: (final context) => pw.Column(
        children: [
          pw.Center(child: pw.Text("SK+F",style: pw.TextStyle(fontSize: 21,color: PdfColors.blue,fontWeight:pw.FontWeight.bold ))),
          pw.Center(child: pw.Text("Eskayef Pharmaceuticals Limited",style: pw.TextStyle(fontSize: 18,fontWeight: pw.FontWeight.bold ))),
          pw.SizedBox(height: 8),
          pw.Center(child: pw.Text("Top sheet on",style:const pw.TextStyle(fontSize: 9 ))),
          pw.Center(child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
            pw.Text("Clinical / RMP / PGO / Intern Reception Meeting Expense bill ",style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
            pw.Text("(Please specify by tick mark)",style:const pw.TextStyle(fontSize: 8))
          ])),
          pw.SizedBox(height: 2),
          pw.Container(height: 0.5,color: PdfColors.black),
          pw.SizedBox(height: 10)
        ]
       
          
          ),
      
      build: (final context) => [
        pw.Container(
          padding: const pw.EdgeInsets.only( bottom: 6),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Row(children: [
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text("BILL SUBMISSION DATE :",style: pw.TextStyle(fontSize: 8,fontWeight: pw.FontWeight.bold))
                )),
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text("ID NUMBER OF ASM/RSM:",style: pw.TextStyle(fontSize: 8,fontWeight: pw.FontWeight.bold))
                )),
              ]),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
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
    
        pw.SizedBox(height: 2),
        pw.Table.fromTextArray(
          context: context,
          data: tableData,
          headerStyle: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: 8),
          cellStyle: pw.TextStyle(fontSize: 6,fontWeight:pw.FontWeight.bold),
          border: pw.TableBorder.all(width: 0.5),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey100
          ),
          cellHeight: 8,
          headerHeight: 12,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            2: pw.Alignment.center,
          },
        ),
        pw.SizedBox(height: 8),
        pw.Table.fromTextArray(
          context: context,
          data: secondTable,
          headerStyle: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: 8,),
          cellStyle: pw.TextStyle(fontSize: 6,fontWeight:pw.FontWeight.bold),
          border: pw.TableBorder.all(width: 0.5),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey100,
          ),
          cellHeight: 6,
          headerHeight: 10,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            
          },
        ),

        pw.SizedBox(height: 40),
        
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
        pw.SizedBox(height: 40),
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
                child: pw.Text("Finance & Administration Department",style: pw.TextStyle(fontWeight:pw.FontWeight.bold,fontSize: 9))
                )),
                pw.SizedBox(child: pw.Text(":")),
                 pw.Expanded(flex: 3,
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
                      pw.Container(color:PdfColors.black,height: 0.6,),
                      pw.Expanded(child: pw.Text("Checked by",style:const pw.TextStyle(fontSize: 8))),
                    

                    ],
                  ),
              ),
              pw.SizedBox(width: 15),
               pw.Expanded(
                flex: 2,
                child: pw.Column(
                    children: [
                      pw.Container(color:PdfColors.black,height: 0.6),
                      pw.Expanded(child: pw.Text("Verified By",style:const pw.TextStyle(fontSize: 8))),
                      
                    ],
                  ),
              ),
              pw.SizedBox(width: 15),
               pw.Expanded(
                flex: 4,
                child: pw.Column(
                    children: [
                      pw.Container(color:PdfColors.black,height: 0.6),
                      pw.Expanded(child: pw.Text("Approved for Payment",style:const pw.TextStyle(fontSize: 8))),
                     

                    ],
                  ),
              ),
               
               
            ]
          )
        ),
        pw.SizedBox(height:8 ),
        pw.Column(
           mainAxisAlignment: pw.MainAxisAlignment.center,
           crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
         
          pw.Container(color:PdfColors.black,height: 1),
          pw.SizedBox(height: 1),
          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text("Note: Each Clinical /RMP /PGD / Intern Reception Meeting Expense bill MUST be submitted with :",style: pw.TextStyle(fontSize: 6,fontWeight:pw.FontWeight.bold),),)
          ,pw.SizedBox(height: 1),
          pw.Container(color:PdfColors.black,height: 1),
          
          pw.Padding(padding:const pw.EdgeInsets.only(left: 15),child: pw.Text("1. Copy of duty signed Approval letter (in the oofice format)",style: pw.TextStyle(fontSize: 5,fontWeight:pw.FontWeight.bold)), ),
          pw.SizedBox(height: 1),
          pw.Padding(padding:const pw.EdgeInsets.only(left: 15),child: pw.Text("2. Meeting feedback report by relevant MSO and cross signed by relevant A/FM and Regional Head",style: pw.TextStyle(fontSize: 5,fontWeight:pw.FontWeight.bold)), ),
          pw.SizedBox(height: 1),
          pw.Padding(padding:const pw.EdgeInsets.only(left: 15),child: pw.Text("3. List of Doctors who have attended the meeting (name,degree,chamber address, mobile number,email ID,)",style: pw.TextStyle(fontSize: 5,fontWeight:pw.FontWeight.bold)), ),
         
          pw.Container(color:PdfColors.black,height: 1),
        ])
      ],
    ),
  );
  return doc.save();
}

pw.Expanded signatureWIdget(String title,String designation) {
  return pw.Expanded(
              child: pw.Column(
                  children: [
                    pw.Container(color:PdfColors.black,height: 0.6),
                    pw.SizedBox(height: 2),
                    pw.Expanded(child: pw.Text(title,style:const pw.TextStyle(fontSize: 5))),
                    pw.Expanded(child: pw.Text(designation,style:const pw.TextStyle(fontSize: 6))),

                  ],
                ),
            );
}



pw.Row expenseTableRowWidget(String title, String value) {
  return pw.Row(children: [
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text(title,style: pw.TextStyle(fontSize: 8,fontWeight: pw.FontWeight.bold))
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
        return generatePdf(format); 
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

// void createPDFAndPrint(final BuildContext context) async{
//   final doc= pw.Document();
//   doc.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build:(pw.Context context){
//         return pw.Center(child: pw.Text("heloo"));
//       }
//     )
//   );
//   await Printing.layoutPdf(onLayout:( PdfPageFormat format) async=>await doc.save());
// }

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Document shared successfully done")));
}
