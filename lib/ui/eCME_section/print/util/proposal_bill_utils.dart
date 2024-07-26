import 'dart:io';
import 'package:MREPORTING_OFFLINE/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProposalBillPrintUtil {
  Future<Uint8List> generatePdf(final PdfPageFormat format,
      ApprovedPrintDataModel wholeData, DataListPrint dataListPrint) async {
    final doc = pw.Document(title: 'Proposal Bill(${dataListPrint.sl})');
    final logoUint8List = pw.MemoryImage(
        (await rootBundle.load('assets/icons/skf_logo_2.png'))
            .buffer
            .asUint8List());

    List<List<String>> tableData = [
      [
        'Expense Particulars ',
        'Expense amount(Taka)',
      ],
      ['1. Hall Rent', dataListPrint.proHallRent],
      ['2. Food Expense', dataListPrint.proFoodExpense],
      ['3. Gift / Souvenir', dataListPrint.proGiftsSouvenirs],
      [
        '4. Stationaries and Others (Pen , Photocopies etc)',
        dataListPrint.proStationnaires
      ],
    ];
    List<String> totalRow = [
      'Total :',
      dataListPrint.proTotalBudget.toString()
    ];

    List<List<String>> secondTable = [
      [
        'Participants ',
        'Count',
      ],
      ['1. Doctors (MBBS & Above)', dataListPrint.proDoctorsCount.toString()],
      ['2. Intern Doctors', dataListPrint.proInternDoctors.toString()],
      ['3. DMF / RMP Doctors', dataListPrint.proDmfDoctors.toString()],
      ['4. Nurses / Staffs', dataListPrint.proNurses.toString()],
      ['5. SKF Attendees', dataListPrint.proSkfAttendance.toString()],
      ['6. Others', dataListPrint.proOthersParticipants.toString()],
    ];

    List<String> totalRow2 = [
      'Total : ',
      dataListPrint.proTotalNumbersOfParticipants.toString()
    ];

    List<String> header = [
      'Brand Name ',
      'Amount',
      dataListPrint.ecmeDoctorCategory == "RMP Meeting"
          ? "Sales Qty*"
          : "Rx Objective / Day"
    ];
    List<List<String>> brandData() {
      List<List<String>> brandData = [];
      int totalSalesQty = 0;
      for (var brand in dataListPrint.brandList) {
        totalSalesQty += int.parse(brand.qty);
        brandData.add([brand.brandName, brand.amountPro.toString(), brand.qty]);
      }
      brandData.add(
          ['Total : ', dataListPrint.proTotalBudget, totalSalesQty.toString()]);
      return brandData;
    }

    doc.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        build: (final context) => [
          pw.Center(
              child: pw.Center(
            child: pw.Container(
              child: pw.Image(logoUint8List),
              height: 60,
            ),
          )),

          pw.Center(
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                pw.Text(
                    "Proposal for Continuing Medical Education Program (CME) ",
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ])),
          pw.SizedBox(height: 2),
          pw.Container(height: 0.5, color: PdfColors.black),
          pw.SizedBox(height: 3),
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(children: [
                  pw.Expanded(
                      child: expenseTableRowWidget("SL ", dataListPrint.sl)),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "BILL SUBMISSION DATE ", dataListPrint.submitDate),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
                pw.Row(children: [
                  pw.Expanded(
                    child: expenseTableRowWidget("PARTICIPATING DOCTORS",
                        dataListPrint.doctorList.length.toString()),
                  ),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "NAME & TERR.CODE  ", dataListPrint.fmIdName),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
                pw.Row(children: [
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "TOTAL BUDGET", dataListPrint.proTotalBudget),
                  ),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget("NAME & REGION OF RSM  ",
                        "${wholeData.resData.rsmName}(${wholeData.resData.supLevelIds.toUpperCase()})"),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
                pw.Row(children: [
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "CME TYPE", dataListPrint.ecmeType),
                  ),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "DOCTOR CATEGORY", dataListPrint.ecmeDoctorCategory),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
                pw.Row(children: [
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "MEETING DATE", dataListPrint.meetingDate),
                  ),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "MEETING VENUE", dataListPrint.meetingVenue),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
                pw.Row(children: [
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "MEETING TOPIC", dataListPrint.meetingTopic),
                  ),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "INSTITUTION NAME", dataListPrint.institutionName),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
                pw.Row(children: [
                  pw.Expanded(
                      child: expenseTableRowWidget(
                          "DEPARTMENT", dataListPrint.department)),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "SPEAKER NAME ", dataListPrint.probableSpeakerName),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
                pw.Row(children: [
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "PAY MODE", dataListPrint.payMode),
                  ),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget("PAY TO", dataListPrint.payTo),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
                pw.Row(children: [
                  pw.Expanded(
                    child: expenseTableRowWidget("TOTAL NO. OF PARTICIPANTS ",
                        dataListPrint.proTotalNumbersOfParticipants),
                  ),
                  pw.SizedBox(
                    width: 70,
                  ),
                  pw.Expanded(
                    child: expenseTableRowWidget(
                        "COST PER DOCTOR", dataListPrint.proCostPerDoctor),
                  ),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 2)),
              ],
            ),
          ),
          pw.Row(children: [
            pw.Expanded(
              flex: 2,
              child: pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Text(
                  "BRANDS DETAILS :\n\n\n\n\n\n\n\n",
                  style:
                      pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.SizedBox(child: pw.Text(" ")),
            pw.Expanded(
              flex: 7,
              child: pw.Table.fromTextArray(
                context: context,
                data: [header, ...brandData()],
                headerStyle:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                cellStyle: const pw.TextStyle(
                  fontSize: 6.5,
                ),
                border: pw.TableBorder.all(width: 0.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey100),
                cellHeight: 6,
                headerHeight: 10,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                },
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(2),
                },
              ),
            ),
          ]),
          pw.SizedBox(height: 8),
          pw.Row(children: [
            pw.Expanded(
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text("BUDGET BREAKDOWN  :",
                        style: pw.TextStyle(
                            fontSize: 7.5, fontWeight: pw.FontWeight.bold)))),
            pw.SizedBox(width: 20),
            pw.Expanded(
                child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text("PARTICIPANTS  :",
                        style: pw.TextStyle(
                            fontSize: 7.5, fontWeight: pw.FontWeight.bold))))
          ]),

          pw.SizedBox(height: 5),

          pw.Row(
            children: [
              pw.Flexible(
                flex: 1,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 25),
                  child: pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Column(
                      children: [
                        pw.Table.fromTextArray(
                          context: context,
                          data: tableData,
                          headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                          cellStyle: const pw.TextStyle(
                            fontSize: 6.5,
                          ),
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
                          columnWidths: {
                            0: const pw.FlexColumnWidth(2),
                            1: const pw.FlexColumnWidth(1),
                          },
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(width: 0.5),
                          columnWidths: {
                            0: const pw.FlexColumnWidth(2),
                            1: const pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  padding: const pw.EdgeInsets.all(3),
                                  child: pw.Text(
                                    totalRow[0],
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 6.5,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  height: 10,
                                  alignment: pw.Alignment.centerRight,
                                  padding: const pw.EdgeInsets.all(3),
                                  child: pw.Text(
                                    totalRow[1],
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 6.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                flex: 1,
                child: pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Column(
                    children: [
                      pw.Table.fromTextArray(
                        context: context,
                        data: secondTable,
                        headerStyle: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        ),
                        cellStyle: const pw.TextStyle(
                          fontSize: 6.5,
                        ),
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
                        columnWidths: {
                          0: const pw.FlexColumnWidth(2),
                          1: const pw.FlexColumnWidth(1),
                        },
                      ),
                      pw.Table(
                        border: pw.TableBorder.all(width: 0.5),
                        columnWidths: {
                          0: const pw.FlexColumnWidth(2),
                          1: const pw.FlexColumnWidth(1),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.all(3),
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                  totalRow2[0],
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    fontSize: 6.5,
                                  ),
                                ),
                              ),
                              pw.Container(
                                height: 10,
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                  "${totalRow2[1]}  ",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    fontSize: 6.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
          // pw.Table.fromTextArray(
          //   context: context,
          //   data: tableData,
          //   headerStyle:
          //       pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
          //   cellStyle: const pw.TextStyle(
          //     fontSize: 6.5,
          //   ),
          //   border: pw.TableBorder.all(width: 0.5),
          //   headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
          //   cellHeight: 6,
          //   headerHeight: 10,
          //   cellAlignments: {
          //     0: pw.Alignment.centerLeft,
          //     1: pw.Alignment.centerRight,
          //   },
          //   columnWidths: {
          //     0: const pw.FlexColumnWidth(2),
          //     1: const pw.FlexColumnWidth(1),
          //   },
          // ),
          ,
          pw.SizedBox(height: 8),
          // expenseTableRowWidget("ATTENDEES", ""),
          // pw.SizedBox(height: 2),
          // pw.Table.fromTextArray(
          //   context: context,
          //   data: secondTable,
          //   headerStyle: pw.TextStyle(
          //     fontWeight: pw.FontWeight.bold,
          //     fontSize: 8,
          //   ),
          //   cellStyle:
          //       pw.TextStyle(fontSize: 6.5, fontWeight: pw.FontWeight.bold),
          //   border: pw.TableBorder.all(width: 0.5),
          //   headerDecoration: const pw.BoxDecoration(
          //     color: PdfColors.grey100,
          //   ),
          //   cellHeight: 6,
          //   headerHeight: 10,
          //   cellAlignments: {
          //     0: pw.Alignment.centerLeft,
          //     1: pw.Alignment.centerRight,
          //   },
          // ),

          pw.SizedBox(height: 40),

          pw.Container(
              height: 14,
              child: pw.Row(children: [
                signatureWIdget(
                  "Signed by",
                  "MSO",
                ),
                pw.SizedBox(
                  width: 10,
                ),
                signatureWIdget(
                  "Signed by",
                  "Area / Field Manager",
                ),
                pw.SizedBox(
                  width: 10,
                ),
                signatureWIdget(
                  "Endorsed by",
                  "Regional Head",
                ),
                pw.SizedBox(
                  width: 10,
                ),
                signatureWIdget(
                  "Checked by",
                  "Zonal Head",
                ),
                pw.SizedBox(
                  width: 10,
                ),
                signatureWIdget(
                  "Checked by",
                  "Dpt. of Medical Affairs",
                ),
              ])),
          pw.SizedBox(height: 50),
          pw.Container(
              height: 14,
              child: pw.Row(children: [
                signatureWIdget(
                  "Recommended by",
                  "AGM, Medical Affairs",
                ),
                pw.SizedBox(
                  width: 10,
                ),
                signatureWIdget(
                  "Approved By",
                  "HOS / GM Sales",
                ),
                pw.SizedBox(
                  width: 10,
                ),
                signatureWIdget(
                  "Approved By",
                  "GM Marketing",
                ),
                pw.SizedBox(
                  width: 10,
                ),
                signatureWIdget(
                  "Approved By",
                  "Additional Director Marketing & Sales",
                ),
              ])),
          // pw.SizedBox(height: 10),
          // pw.Container(
          //   padding: const pw.EdgeInsets.only(left: 5, bottom: 8),
          //   child: pw.Column(
          //     crossAxisAlignment: pw.CrossAxisAlignment.center,
          //     mainAxisAlignment: pw.MainAxisAlignment.start,
          //     children: [
          //       pw.Padding(padding: const pw.EdgeInsets.only(top: 7)),
          //       pw.Row(children: [
          //         pw.Expanded(
          //             flex: 2,
          //             child: pw.Align(
          //                 alignment: pw.Alignment.centerLeft,
          //                 child: pw.Text("Finance & Administration Department",
          //                     style: pw.TextStyle(
          //                         fontWeight: pw.FontWeight.bold,
          //                         fontSize: 9)))),
          //         pw.SizedBox(child: pw.Text(":")),
          //         pw.Expanded(flex: 3, child: pw.Text("")),
          //       ]),
          //     ],
          //   ),
          // ),
          // pw.SizedBox(height: 20),
          // pw.Container(
          //     height: 15,
          //     child: pw.Row(children: [
          //       pw.Expanded(
          //         flex: 2,
          //         child: pw.Column(
          //           children: [
          //             pw.Container(
          //               color: PdfColors.black,
          //               height: 0.6,
          //             ),
          //             pw.Expanded(
          //                 child: pw.Text("Checked by",
          //                     style: const pw.TextStyle(fontSize: 8))),
          //           ],
          //         ),
          //       ),
          //       pw.SizedBox(width: 15),
          //       pw.Expanded(
          //         flex: 2,
          //         child: pw.Column(
          //           children: [
          //             pw.Container(color: PdfColors.black, height: 0.6),
          //             pw.Expanded(
          //                 child: pw.Text("Verified By",
          //                     style: const pw.TextStyle(fontSize: 8))),
          //           ],
          //         ),
          //       ),
          //       pw.SizedBox(width: 15),
          //       pw.Expanded(
          //         flex: 4,
          //         child: pw.Column(
          //           children: [
          //             pw.Container(color: PdfColors.black, height: 0.6),
          //             pw.Expanded(
          //                 child: pw.Text("Approved for Payment",
          //                     style: const pw.TextStyle(fontSize: 8))),
          //           ],
          //         ),
          //       ),
          //     ])),
          // pw.SizedBox(height: 8),

          // pw.SizedBox(height: 40),
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
          pw.SizedBox(height: 8),
          pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(color: PdfColors.black, height: 1),
                pw.SizedBox(height: 2),
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(
                    "Special Note :",
                    style: pw.TextStyle(
                      fontSize: 7,
                    ),
                  ),
                ),
                pw.SizedBox(height: 1),
                pw.Container(color: PdfColors.black, height: 1),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 15),
                  child: pw.Text(
                      "1 . SHARING DOCTOR\’S PRESENTATION IS A MUST for CME/ MORNING SESSION",
                      style: pw.TextStyle(
                        fontSize: 6,
                      )),
                ),
                pw.SizedBox(height: 1),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 15),
                  child: pw.Text(
                      "2 . A/FM or RH will send a Feedback Message, Photo & Presentation of CME to 'DMA with RH' WhatsApp group after completion of the meeting to ensure either the meeting is completed.",
                      style: pw.TextStyle(
                        fontSize: 6,
                      )),
                ),
                pw.SizedBox(height: 1),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 15),
                  child: pw.Text(
                    "3 . Proposal must be sent to DMA at least 7 days before the meeting date for ensuring the logistic supports for successful meeting outcome.",
                    style: pw.TextStyle(
                      fontSize: 6,
                    ),
                  ),
                ),
                pw.SizedBox(height: 1),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 15),
                  child: pw.Text(
                      "4 . Please attach the list of doctors who will be attending the program. (Name, degree, address)",
                      style: pw.TextStyle(
                        fontSize: 6,
                      )),
                ),
                pw.SizedBox(height: 2),
                pw.Container(color: PdfColors.black, height: 1),
              ])
        ],
      ),
    );
    return doc.save();
  }

  pw.Expanded signatureWIdget(String title, String designation) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          pw.Container(color: PdfColors.black, height: 0.6),
          pw.SizedBox(height: 4.5),
          pw.Expanded(
              child: pw.Text(title, style: const pw.TextStyle(fontSize: 5))),
          pw.SizedBox(height: 2),
          pw.Expanded(
              child: pw.Text(designation, style: pw.TextStyle(fontSize: 6))),
        ],
      ),
    );
  }

  pw.Row expenseTableRowWidget(String title, String value) {
    return pw.Row(children: [
      pw.Expanded(
          flex: 1,
          child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(title,
                  style: pw.TextStyle(
                    fontSize: 8,
                  )))),
      pw.SizedBox(child: pw.Text(":")),
      pw.Expanded(
          flex: 1,
          child:
              pw.Text("    $value", style: const pw.TextStyle(fontSize: 7.5))),
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
      print("Error saving file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving PDF: $e")),
      );
    }
  }

  void showPrintedToast(
    final BuildContext context,
    ApprovedPrintDataModel wholeData,
    DataListPrint dataListPrint,
  ) async {
    try {
      final result = await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return generatePdf(
            format,
            wholeData,
            dataListPrint,
          );
        },
      );
      if (result) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Proposal Bill(${dataListPrint.sl}) printed successfully")),
          );
        }
      } else {}
    } catch (e) {
      print("Error printing document: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error printing document: $e")),
      );
    }
  }

  void showSharedToast(final BuildContext context,
      ApprovedPrintDataModel wholeData, DataListPrint dataListPrint) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Proposal Bill(${dataListPrint.sl}) shared successfully done")));
  }
}
