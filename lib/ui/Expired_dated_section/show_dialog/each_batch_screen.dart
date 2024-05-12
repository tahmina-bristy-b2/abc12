// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:MREPORTING/services/all_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:MREPORTING/models/expired_dated/expired_submit_and_save_data_model.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/cancel-button.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/confirm_widget.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/textform_field_custom.dart';

class EachBtachItemWidget extends StatefulWidget {
  bool routeName;
  String itemName;
  BatchWiseItemListModel? batchWiseItemSaved;
  Function(BatchWiseItemListModel) callbackFunction;
  EachBtachItemWidget({
    Key? key,
    required this.routeName,
    required this.itemName,
    required this.batchWiseItemSaved,
    required this.callbackFunction,
  }) : super(key: key);
  @override
  State<EachBtachItemWidget> createState() => _EachBtachItemWidgetState();
}

class _EachBtachItemWidgetState extends State<EachBtachItemWidget> {
  DateTime selectedExpiredDate=DateTime.now();
  String selectedExpiredDateString=DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController batchcontroller=TextEditingController();
  TextEditingController qtyController=TextEditingController();
  

  @override
  void initState() {
    super.initState();
    selectedExpiredDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if(widget.routeName==true){
      batchcontroller.text=widget.batchWiseItemSaved!.batchId;
      qtyController.text=widget.batchWiseItemSaved!.unitQty;
      selectedExpiredDateString=widget.batchWiseItemSaved!.expiredDate;
      selectedExpiredDate=widget.batchWiseItemSaved!.expiredDateTime;
    }
  }
  @override
  void dispose() {
    super.dispose();
    batchcontroller.dispose();
    qtyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    
    return SizedBox(
      child: AlertDialog(
        insetPadding:const EdgeInsets.all(20),
         contentPadding: EdgeInsets.zero,
                  content: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                       
                               Row(
                                children: [
                                                     
                                       Expanded(child:Center(child: Text(widget.itemName.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)))
                                           ],
                                         ),
                                         
                                      
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow:const [
                                              BoxShadow(
                                                color :Colors.white ,
                                                spreadRadius : 2,
                                                blurStyle :BlurStyle.outer,
                                                blurRadius: 1,
                                              ),
                                            ],
                                            
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.white ,
                                            
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Column(
                                              children: [   
                                             const SizedBox(height: 10,),
                                             Row(
                                             children: [
                                           const  Expanded(child: Text("Batch Id",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                             const Text(" :  "),
                                             Expanded(flex: 3,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:  Center(child: TextFormFieldCustomOrderInput(readOnly: false,
                                                    controller: batchcontroller, borderColor: Colors.teal, 
                                                  hintText: "---batch id---", 
                                                  textAlign: TextAlign.center, 
                                                  validator: (value) { 
                                                   }, afterClickingDone: () {  },)),
                                                ), ),
                                                  ],
                                             ),
                                          
                                           
                                         Row(
                                            children: [
                                             const Expanded(child: Text("Unit Quantity",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                                      const Text(" :  "),
                                                       Expanded(flex: 3,
                                                        child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:  Center(child: TextFormFieldCustomOrderInput(readOnly: false,
                                                    controller: qtyController, 
                                                    borderColor: Colors.teal, 
                                                  hintText: "---Qty---", 
                                                  textAlign: TextAlign.center, 
                                                  validator: (value) { 
                                                   }, afterClickingDone: () {  },)),
                                                ),)
                                            ],
                                          ),
                                          
                                            Row(
                                              children: [
                                                      const Expanded(child: Text("Exp. Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                                       const Text(" :  "),
                                                         Expanded(flex: 3,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: TextFormField(
                                                              autofocus: false,
                                                              controller: initialValue(selectedExpiredDateString),
                                                              focusNode: AlwaysDisabledFocusNode(),
                                                              style:const TextStyle(fontSize: 14,color: Color.fromARGB(255, 82, 179, 98),),
                                                              textAlign: TextAlign.left,
                                                              decoration:const InputDecoration(
                                                                suffixIcon: Icon(Icons.calendar_month_outlined,color: Color.fromARGB(255, 82, 179, 98),),
                                                                focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1, 
                                                                    color:  Colors.white,
                                                                ), 
                                                                ),
                                                                enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1, 
                                                                    color:  Color.fromARGB(255, 227, 227, 227), 
                                                                ), 
                                                                ),
                                                                
                                                              ),
                                                              
                                                              onChanged: (String value) {
                                                                setState(() {});
                                                                selectedExpiredDateString  = value;
                                                            
                                                              },
                                                              onTap: () {
                                                                pickDate();
                                                              },
                                                            ),
                                                          )
                                                        
                                                          )
                                              ],
                                            ),
                                              const SizedBox(height: 10,),
                                              ],
                                            ),
                                          ),
                                        )
                        ],
                      ),
                    ),
                    
                  ),
                  actions: [
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10 ),
                     child: Row(
                          children: [
                            Expanded(child: CancelButtonWidget(buttonHeight: 50, fontColor: const Color.fromARGB(255, 82, 179, 98), buttonName: "Cancel", fontSize: 16, onTapFuction:  () { 
                              Navigator.pop(context) ;
                              
                            },borderColor: const Color.fromARGB(255, 82, 179, 98),)),
                           const SizedBox(width: 10,),
                        widget.routeName==true?  Expanded(child: ConfirmButtonWidget(buttonHeight: 50, fontColor: Colors.white, buttonName: "Update", fontSize: 16, 
                         onTapFuction: () {
                          if(batchcontroller.text!="" && qtyController.text !=""){
                           final item= BatchWiseItemListModel(batchId:batchcontroller.text , expiredDateTime: selectedExpiredDate, expiredDate: selectedExpiredDateString, unitQty: qtyController.text);
                            widget.batchWiseItemSaved=item;
                            widget.callbackFunction(widget.batchWiseItemSaved!);
                            Navigator.pop(context);
                          }
                          else if(batchcontroller.text=="" ||  qtyController.text ==""){
                            if(batchcontroller.text==""){
                              AllServices().toastMessage("Please enter batch id ", Colors.red, Colors.white, 15);
                            }
                            else{
                              AllServices().toastMessage("Please enter unit quantity ", Colors.red, Colors.white, 15);
                            }
                          }
                          else{
                            AllServices().toastMessage("Please fill up all information", Colors.red, Colors.black, 15);
                          }
                        
                            
                             },)) :Expanded(child: ConfirmButtonWidget(buttonHeight: 50, fontColor: Colors.white, buttonName: "Add", fontSize: 16, 
                                        onTapFuction: () {
                                          if(batchcontroller.text!="" && qtyController.text !=""){
                                          final item= BatchWiseItemListModel(batchId:batchcontroller.text , expiredDateTime: selectedExpiredDate, expiredDate: selectedExpiredDateString, unitQty: qtyController.text);
                                            widget.batchWiseItemSaved=item;
                                            widget.callbackFunction(widget.batchWiseItemSaved!);
                                            Navigator.pop(context);
                                          }
                                          else if(batchcontroller.text=="" ||  qtyController.text ==""){
                                            if(batchcontroller.text==""){
                                              AllServices().toastMessageForSubmitData("Please enter batch id ", Colors.red, Colors.white, 15);
                                            }
                                            else{
                                              AllServices().toastMessageForSubmitData("Please enter unit quantity ", Colors.red, Colors.white, 15);
                                            }
                                          }
                                          else{
                                            AllServices().toastMessageForSubmitData("Please fill up all information", Colors.red, Colors.white, 15);
                                          }
                                        
                                            
                                            },
                             
                             ))
                         
                           
                          ],
                        ),
                   ),
                   
                  ],
                ),
    );
  }

    initialValue(String val) {
    return TextEditingController(text: val);
  }
  pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate:selectedExpiredDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.white,
            colorScheme: const ColorScheme.light(primary: Colors.teal),
            canvasColor: Colors.teal,
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;
    selectedExpiredDate = newDate;
    selectedExpiredDateString = DateFormat('yyyy-MM-dd').format(selectedExpiredDate);
    setState(() => selectedExpiredDate = newDate);
  
  }
 
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}