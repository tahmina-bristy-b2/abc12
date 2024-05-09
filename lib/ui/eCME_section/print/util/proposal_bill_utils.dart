import 'dart:io';
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProposalBillPrintUtil{
  
Future<Uint8List> generatePdf(final PdfPageFormat format,  ApprovedPrintDataModel wholeData, DataListPrint dataListPrint) async {

  final doc = pw.Document(title: 'Bill Expense(${dataListPrint.sl})');
  final  logoUint8List = pw.MemoryImage(
      (await rootBundle.load('assets/images/comp_logo1.png')).buffer.asUint8List());

  //final font = await rootBundle.load('assets/Montserrat-Regular.ttf');
  List<List<String>> tableData = [
    ['Expense Particulars ', 'Expense amount(Taka)', ],
    ['1. Hall Rent', dataListPrint.hallRent.toString(), ],
    ['2. Food Expense', dataListPrint.foodExpense.toString(), ],
    ['3. Speaker Gift or Souvenir', dataListPrint.giftsSouvenirs.toString(), ],
    ['4. Stationaries or Others (Pen,Photocopies etc)', dataListPrint.stationnaires.toString(), ],

     ['TOTAL :', dataListPrint.totalBudget.toString(), ],
     ['IN WORDS :', dataListPrint.totalBudgetInWords, ],
  ];
   List<List<String>> secondTable = [
    ['Participates ', 'Amount', ],
    ['1. Doctors', dataListPrint.doctorsCount.toString(), ],
    ['2. Intern Doctors', dataListPrint.internDoctors.toString(), ],
    ['3. DMF/RMP Doctors', dataListPrint.dmfDoctors.toString(), ],
    ['4. Nurses/Staff', dataListPrint.stationnaires.toString(), ],
    ['4. SKF Attenadance', dataListPrint.skfAttendance.toString(), ],
    ['5. Others', dataListPrint.othersParticipants.toString(), ],

     ['TOTAL :', dataListPrint.totalNumbersOfParticipants.toString(), ],
     ['IN WORDS :', "", ],
  ];


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
          pw.Center(child: pw.Text("Proposal bill on",style: pw.TextStyle(fontSize: 10,fontWeight:pw.FontWeight.bold ))),
          pw.Center(child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
            pw.Text("Clinical / RMP / PGO / Intern Reception Meeting Expense bill ",style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
            pw.Text("(Please specify by tick mark)",style:const pw.TextStyle(fontSize: 8))
          ])),
          pw.SizedBox(height: 2),
          pw.Container(height: 0.5,color: PdfColors.black),
          pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.only( bottom: 6),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Row(children: [
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text("BILL SUBMISSION DATE :  ${dataListPrint.submitDate}",style: pw.TextStyle(fontSize: 8,fontWeight: pw.FontWeight.bold))
                )),
                pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.centerLeft,
                child: pw.Text(" ",style: pw.TextStyle(fontSize: 8,fontWeight: pw.FontWeight.bold))
                )),
              ]),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
              expenseTableRowWidget("SL NO", dataListPrint.sl),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
              expenseTableRowWidget("NAME & TERR.CODE OF AM/FM ", dataListPrint.fmIdName),
              expenseTableRowWidget("e-CME AMOUNT", dataListPrint.ecmeAmount),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING DATE", dataListPrint.meetingDate.toString()),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING VENUE", dataListPrint.meetingVenue),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING TOPIC", dataListPrint.meetingTopic),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("INSTITUTION NAME", dataListPrint.institutionName),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("DEPARTMENT", dataListPrint.meetingTopic),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("SPEAKER NAME DESIGNATION", dataListPrint.probableSpeakerName),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("PAY MODE", dataListPrint.payMode),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("PAY TO", dataListPrint.payTo),
               
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("NAME OF REMINDED BRANDS", dataListPrint.remindedBrand),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("TOTAL BUDGET", dataListPrint.totalBudget),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("COST PER DOCTOR", dataListPrint.costPerDoctor),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               
            ],
          ),
        ),
        expenseTableRowWidget("PARTICIPATING BREAKDOWN", ""),
    
        pw.SizedBox(height: 2),
        pw.Table.fromTextArray(
          context: context,
          data: tableData,
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
            1: pw.Alignment.centerRight,
          },
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1), 
          },
        ),
        pw.SizedBox(height: 8),
        pw.Table.fromTextArray(
          context: context,
          data: secondTable,
          headerStyle: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: 8,),
          cellStyle: pw.TextStyle(fontSize: 6.5,fontWeight:pw.FontWeight.bold),
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

        
         pw.SizedBox(height: 20),
        // pw.Container(
        //   height: 15,
        //   child: pw.Row(
        //     children:[
        //       pw.Expanded(
        //         flex: 2,
        //         child: pw.Column(
        //             children: [
        //               pw.Container(color:PdfColors.black,height: 0.6,),
        //               pw.Expanded(child: pw.Text("Checked by",style:const pw.TextStyle(fontSize: 8))),
                    

        //             ],
        //           ),
        //       ),
        //       pw.SizedBox(width: 15),
        //        pw.Expanded(
        //         flex: 2,
        //         child: pw.Column(
        //             children: [
        //               pw.Container(color:PdfColors.black,height: 0.6),
        //               pw.Expanded(child: pw.Text("Verified By",style:const pw.TextStyle(fontSize: 8))),
                      
        //             ],
        //           ),
        //       ),
        //       pw.SizedBox(width: 15),
        //        pw.Expanded(
        //         flex: 4,
        //         child: pw.Column(
        //             children: [
        //               pw.Container(color:PdfColors.black,height: 0.6),
        //               pw.Expanded(child: pw.Text("Approved for Payment",style:const pw.TextStyle(fontSize: 8))),
                     

        //             ],
        //           ),
        //       ),
               
               
        //     ]
        //   )
        // ),
        pw.SizedBox(height:8 ),
        pw.Column(
           mainAxisAlignment: pw.MainAxisAlignment.center,
           crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
         
          pw.Container(color:PdfColors.black,height: 1),
          pw.SizedBox(height: 1),
          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text("Note: Each Clinical /RMP /PGD / Intern Reception Meeting Expense bill MUST be submitted with :",style: pw.TextStyle(fontSize: 7,fontWeight:pw.FontWeight.bold),),)
          ,pw.SizedBox(height: 1),
          pw.Container(color:PdfColors.black,height: 1),
          
          pw.Padding(padding:const pw.EdgeInsets.only(left: 15),child: pw.Text("1. Copy of duty signed Approval letter (in the oofice format)",style: pw.TextStyle(fontSize: 6,fontWeight:pw.FontWeight.bold)), ),
          pw.SizedBox(height: 1),
          pw.Padding(padding:const pw.EdgeInsets.only(left: 15),child: pw.Text("2. Meeting feedback report by relevant MSO and cross signed by relevant A/FM and Regional Head",style: pw.TextStyle(fontSize: 6,fontWeight:pw.FontWeight.bold)), ),
          pw.SizedBox(height: 1),
          pw.Padding(padding:const pw.EdgeInsets.only(left: 15),child: pw.Text("3. List of Doctors who have attended the meeting (name,degree,chamber address, mobile number,email ID,)",style: pw.TextStyle(fontSize: 6,fontWeight:pw.FontWeight.bold)), ),
           pw.SizedBox(height: 1),
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
                    pw.SizedBox(height: 4.5),
                    pw.Expanded(child: pw.Text(title,style:const pw.TextStyle(fontSize: 5))),
                    pw.Expanded(child: pw.Text(designation,style: pw.TextStyle(fontSize: 6,fontWeight: pw.FontWeight.bold))),

                  ],
                ),
            );
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
         SnackBar(content: Text("Bill Expense(${dataListPrint.sl}) printed successfully")),
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
       SnackBar(content: Text("Bill Expense(${dataListPrint.sl}) shared successfully done")));
}

}