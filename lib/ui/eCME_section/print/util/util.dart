import 'dart:io';
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


Future<Uint8List> generatePdf(final PdfPageFormat format,  ApprovedPrintDataModel wholeData, DataListPrint dataListPrint) async {

  final doc = pw.Document(title: 'Bill Expense(${dataListPrint.sl})');
  final  logoUint8List = pw.MemoryImage(
      (await rootBundle.load('assets/images/comp_logo1.png')).buffer.asUint8List());
 
  List<List<String>> tableData = [
    ['Expense Particulars ', 'Expense amount(Taka)', 'Remarks'],
    ['1. Hall Rent', dataListPrint.hallRent.toString(), ''],
    ['2. Food Expense', dataListPrint.foodExpense.toString(), ''],
    ['3. Speaker Gift or Souvenir', dataListPrint.giftsSouvenirs.toString(), ''],
    ['4. Stationaries or Others (Pen,Photocopies etc)', dataListPrint.stationnaires.toString(), ''],

     ['TOTAL :', dataListPrint.totalBudget.toString(), ''],
     ['IN WORDS :', dataListPrint.totalBudgetInWords, ''],
  ];
  List<String> header = ['Brand Name ', 'Amount',dataListPrint.ecmeDoctorCategory=="RMP Meeting"? "Sales Qty*" :"Rx objective per day"];
  
  List<List<String>> brandData(){
    List<List<String>> brandData =[];
     dataListPrint.brandList.forEach((element) { 
      brandData.add(element as List<String>);
     });
   return brandData;
  }
  
  List<List<String>> secondTable = [
    ['', 'Amount'],
    ['Advance Recieved (MI Number:......, Date:.......)[If approprite]', '' ],
    ["Total Expense",""],
    ['Amount Payable by/Refundable to the Company(TK)', ''],
    ['In words :', '', ],
    
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
          pw.Center(child: pw.Text("Top sheet on",style:const pw.TextStyle(fontSize: 9 ))),
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
                child: pw.Text("ID NUMBER OF ASM/RSM:   ${wholeData.resData.rsmId.toUpperCase()}",style: pw.TextStyle(fontSize: 8,fontWeight: pw.FontWeight.bold))
                )),
              ]),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
               expenseTableRowWidget("SL NO", dataListPrint.sl),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("NAME & TERR.CODE OF AM/FM ", dataListPrint.fmIdName),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("NAME & REGION OF ASM/RSM  ", "${wholeData.resData.rsmName}(${wholeData.resData.supLevelIds.toUpperCase()})"),
               pw.Padding(padding: const pw.EdgeInsets.only(top:2)),
               expenseTableRowWidget("ESKAYEF PERSONS ATTENDED", dataListPrint.skfAttendance),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               ((dataListPrint.ecmeType=="Intern Reception")||(dataListPrint.ecmeType=="Intern Reception"))?pw.SizedBox(): expenseTableRowWidget("PARTICIPATING DOCTORS BELONG TO", dataListPrint.doctorList.length.toString()),
               ((dataListPrint.ecmeType=="Intern Reception")||(dataListPrint.ecmeType=="Intern Reception"))?pw.SizedBox():  pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING VENUE", dataListPrint.meetingVenue),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING DATE", dataListPrint.meetingDate),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("TOTAL NO. OF PARTICIPATING DOCTORS", dataListPrint.doctorsCount),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
               expenseTableRowWidget("MEETING TOPIC", dataListPrint.meetingTopic),
               pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
            ],
          ),
        ),
        pw.Row(children: [
          pw.Expanded(flex: 2,
                child: pw.Align(alignment: pw.Alignment.topLeft,
                child: pw.Text("REMINDED BRANDS DETAIL",style: pw.TextStyle(fontSize: 7.5,fontWeight: pw.FontWeight.bold))
                )),
                pw.SizedBox(child: pw.Text(": ")),
                pw.Expanded(flex: 3,
                child: pw.Table.fromTextArray(
                  context: context,
                  headers:header ,
                  data: dataListPrint.brandList.map((brand) => [brand.brandName, brand.amount, brand.qty]).toList(),
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
                    2: pw.Alignment.center,
                  },
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(1), 
                    2:const pw.FlexColumnWidth(2), 
                  },
                 ),
                ),


        ]),
    
        pw.SizedBox(height: 8),
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
            2: pw.Alignment.center,
          },
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1), 
            2:const pw.FlexColumnWidth(2), 
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

        pw.SizedBox(height: 30),
        
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
         pw.SizedBox(height: 20),
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
