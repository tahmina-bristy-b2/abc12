import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/models/expired_dated/expired_submit_and_save_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/ui/Expired_dated_section/cancel-button.dart';
import 'package:MREPORTING/ui/Expired_dated_section/confirm_widget.dart';
import 'package:MREPORTING/ui/Expired_dated_section/each_batch_scareen.dart';

import 'package:MREPORTING/ui/Expired_dated_section/textform_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ExpiredIteminputShowDialogScreen extends StatefulWidget {
  ExpiredItemList expiredItem;
   ExpiredItemSubmitModel? expiredItemSubmitModel;
   Function(ExpiredItemSubmitModel?) callbackFunction;


  ExpiredIteminputShowDialogScreen({super.key, 
      required this.expiredItem,
      required this.expiredItemSubmitModel,
      required this.callbackFunction,
  });

  @override
  State<ExpiredIteminputShowDialogScreen> createState() => _ExpiredIteminputShowDialogScreenState();
}

class _ExpiredIteminputShowDialogScreenState extends State<ExpiredIteminputShowDialogScreen> {
  // List<
  // List<String> reasonForMarketReturn = ['Date Expired', 'Micro Leak', 'Product Damage'];
  List<DynamicItemsWidget> batchItems=[];
  List<BatchWiseItemListModel> batchWiseItemSaved=[];
   String selectedExpiredDateString=DateFormat('yyyy-MM-dd').format(DateTime.now());
  String total="";
  bool isUpdate=false;
  int remaingPcs=0;
  DateTime selectedExpiredDate=DateTime.now();
  TextEditingController pcsController=TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedExpiredDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // if(widget.itemInfoMR!=null){
    //   pcsController.text=widget.itemInfoMR!.pcs!;
    //   selectedReasonForMR=widget.itemInfoMR!.reasonforMarketR!;
    //   selectedExpiredDateString=widget.itemInfoMR!.expiredDate;
    //   total=widget.itemInfoMR!.totalPrice!;
    //   isUpdate=true;

    // }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        insetPadding:const EdgeInsets.all(5),
         contentPadding: EdgeInsets.zero,
                  content: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (context, setState2) {
                        return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                                 Row(
                                  children: [        
                                               Expanded(
                                                flex: 8,
                                                child:Center(child: Text(widget.expiredItem.itemName,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),))),Expanded(
                                                  child:Center(child: IconButton(onPressed: (){
                                                    showDialog(context: context, builder: (BuildContext context){
                                                      return EachBtachItemWidget(itemName:widget.expiredItem.itemName , batchWiseItemSaved: null, 
                                                        callbackFunction: (BatchWiseItemListModel? value ) { 
                                                                //batchWiseItemSaved=value;
                                                                batchItems.add(
                                                                  DynamicItemsWidget(
                                                                    batchWiseItemListModel:value
                                                                     //batchItems: value, indexNum: 2, setState2: setState2, callbackFunction: callbackFunction
                                                                  
                                                                   )
                                                                  );
                                                                setState(() {
                                                                  
                                                                });
                                                        
                                                       setState(() {
                                                         
                                                       });
                                                       },

                                                      );

                                                    });
                                                    // batchItems.add(DynamicItemsWidget( 
                                                    //   batchItems: batchItems,
                                                    //   indexNum: batchItems.length,
                                                    //   setState2: setState2, 
                                                    //   callbackFunction: (BatchWiseItemListModel? value ) { 
                                                    //     if(value!.batchId!=null && value!.expiredDate!=null && value!.unitQty!=null && value!.eachbatchWiseItemString!=null){
                                                    //       batchWiseItemSaved.add(value);
                                                    //       print("eo j $batchWiseItemSaved");

                                                    //     }
                                                    //   },));
                                                    // setState(() {
                                                      
                                                    // });
                                                    //  print(batchItems.length);
                                                  }, icon:const Icon(Icons.add,color:  Color.fromARGB(255, 82, 179, 98),))))
                                             ],
                                           ),
                                          //  const SizedBox(height: 10,),
                                          fixedRowWidget(),
                                          Column(
                                            children: batchItems,
                                          )
                          ],
                        ),
                      );
                      },
                    ),
                
                    
                  ),
                  actions: [
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10 ),
                     child: Row(
                          children: [
                            Expanded(child: CancelButtonWidget(buttonHeight: 50, fontColor:const Color.fromARGB(255, 82, 179, 98)
                                            , buttonName: "Cancel", fontSize: 16, onTapFuction:  () { 
                              Navigator.pop(context) ;

                              
                            },borderColor:const Color.fromARGB(255, 82, 179, 98))),
                           const SizedBox(width: 10,),
                         Expanded(child: ConfirmButtonWidget(buttonHeight: 50, fontColor: Colors.white, buttonName: "Add", fontSize: 16, onTapFuction: () {
                             if(batchItems.isEmpty){
                                AllServices().toastMessageForSubmitData("Please add something", Colors.red, Colors.white, 16);
                              }
                             
                              
                            //  else  if(selectedReasonForMR==null)  {
                            //     AllServices().toastMessageForSubmitData("Please add reason for market return ", Colors.red, Colors.white, 16);
                            //   }
                            //   else if(pcsController.text.isEmpty)  {
                            //     AllServices().toastMessageForSubmitData("Please add quantity ", Colors.red, Colors.white, 16); 
                            //   }
                              
                            else{
                              final eachItemtemList=ExpiredItemSubmitModel(itemName: widget.expiredItem.itemName.toString(), quantity: widget.expiredItem.stock.toString(), tp:widget.expiredItem.tp.toString()
                               , itemId: widget.expiredItem.itemId.toString(), categoryId: widget.expiredItem.categoryId.toString(), vat: widget.expiredItem.vat.toString(), manufacturer: widget.expiredItem.manufacturer.toString(), itemString: "", batchWiseItem: batchWiseItemSaved);
                               widget.expiredItemSubmitModel= eachItemtemList;
                               widget.callbackFunction(widget.expiredItemSubmitModel!);
                               Navigator.pop(context) ;
                               setState(() {
                                 
                               });
                             

                            }
                            
                             

                             },))
                           
                          ],
                        ),
                   ),
                   
                  ],
                ),
    );
  }

                Container fixedRowWidget() {
                  return Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color : const Color.fromARGB(255, 138, 201, 149)
                                          .withOpacity(.3) ,
                                              spreadRadius : 2,
                                              blurStyle :BlurStyle.outer,
                                              blurRadius: 1,
                                            ),
                                          ], 
                                          borderRadius: BorderRadius.circular(12),
                                          color:  const Color.fromARGB(255, 138, 201, 149)
                                          .withOpacity(.3),
                                          
                                        ),
                                        
                                          child: Row(
                                            children:const [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child:  Center(child: Text("Batch Id",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                              )),
                                               Expanded(
                                                flex: 2,
                                                child: Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child:  Center(child: Text("Expired Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                              )),
                                               Expanded(flex: 1,
                                                child: Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child:  Center(child: Text("Qty",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                              )),
                                               Expanded(child: Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child:  Center(child: Text("Ac",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                              )),
                                            ],  
                                          )
                                          
                                       
                                      );
  }

 

  
  void updateTotal() {
    // setState(() {
    //   total = AllServices().getItemMReturnEachItemCount(
    //     widget.marketReturnSyncItem,pcsController.text.toString(),
       
    //   );
      
    // });
  }
 
    initialValue(String val) {
    return TextEditingController(text: val);
  }
  pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate:selectedExpiredDate,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:  Colors.teal,
            colorScheme:const ColorScheme.light(primary: Colors.teal,),
            canvasColor:  Colors.teal,
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



class DynamicItemsWidget extends StatefulWidget {
  BatchWiseItemListModel? batchWiseItemListModel;
  // List<DynamicItemsWidget> batchItems;
  // int indexNum;
  // void Function(void Function()) setState2;
  // Function(BatchWiseItemListModel?) callbackFunction;
  

  DynamicItemsWidget({super.key, required this.batchWiseItemListModel
  // required this.batchItems,required this.indexNum,required this.setState2,required this.callbackFunction
  });

  @override
  State<DynamicItemsWidget> createState() => _DynamicItemsWidgetState();
}

class _DynamicItemsWidgetState extends State<DynamicItemsWidget> {
  DateTime selectedExpiredDate=DateTime.now();
  String selectedExpiredDateString=DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController batchcontroller=TextEditingController();
  TextEditingController qtyController=TextEditingController();
 // BatchWiseItemListModel batchWiseItem=BatchWiseItemListModel();

  @override
  void initState() {
    super.initState();
    // BatchWiseItemListModel batchWiseItem=BatchWiseItemListModel(
    //   expiredDate:selectedExpiredDateString,
    //   unitQty:qtyController.text,
    //   batchId:batchcontroller.text, eachbatchWiseItemString: ''
    // );
    batchcontroller.text=widget.batchWiseItemListModel!.batchId.toString();
    qtyController.text=widget.batchWiseItemListModel!.unitQty.toString();
   // batchcontroller.text=widget.batchWiseItemListModel!.batchId.toString();
    
    
  }
  //BatchWiseItemListModel? batchWiseItemListModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1,),
      child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:  Center(child: TextFormFieldCustomOrderInput(controller: batchcontroller, borderColor: Colors.teal, 
                                                  hintText: "---id---", 
                                                  textAlign: TextAlign.center, 
                                                  validator: (value) { 
                                                    // if(batchcontroller.text!="" && qtyController.text!="" && selectedExpiredDateString!=""){
                                                    
                                                    //  widget.callbackFunction(BatchWiseItemListModel(batchId: batchcontroller.text, unitQty: qtyController.text, expiredDate: selectedExpiredDateString, eachbatchWiseItemString: ''));

                                                    // }
                                                    
                                                    
                                                   }, afterClickingDone: () {  },)),
                                                )),
                                                 Expanded(
                                                  flex: 2,
                                                  child:StatefulBuilder(builder: (context, setState2) {
                                                    return Padding(
                                                  padding:const  EdgeInsets.all(8.0),
                                                  child:  Center(child:TextFormField(
                                                              autofocus: false,
                                                              controller: initialValue(selectedExpiredDateString),
                                                              focusNode: AlwaysDisabledFocusNode(),
                                                              style:const TextStyle(fontSize: 14,color: Colors.teal,),
                                                              textAlign: TextAlign.center,
                                                              decoration:const InputDecoration(
                                                                hintText: "select",
                                                                //suffixIcon: Icon(Icons.calendar_month_outlined,color: Colors.teal,),
                                                                focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1, 
                                                                    color:  Colors.white
                                                                ), 
                                                                ),
                                                                enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1, 
                                                                    color:  Colors.teal, 
                                                                ), 
                                                                ),
                                                                
                                                              ),
                                                              
                                                              onChanged: (String value) {
                                                    //             setState2(() {});
                                                    //             selectedExpiredDateString  = value;
                                                    //              if(batchcontroller.text!="" && qtyController.text!="" && selectedExpiredDateString!=""){
                                                    
                                                    //                widget.callbackFunction(BatchWiseItemListModel(batchId: batchcontroller.text, unitQty: qtyController.text, expiredDate: selectedExpiredDateString, eachbatchWiseItemString: ''));

                                                    // }
                                                    //             //  widget.callbackFunction(BatchWiseItemListModel(
                                                    //             //       expiredDate: selectedExpiredDateString,
                                                    //             //       unitQty: qtyController.text,
                                                    //             //       batchId: batchcontroller.text,
                                                    //             //       eachbatchWiseItemString: '',
                                                    //             //     ));
                                                                        
                                                              },
                                                              onTap: () {
                                                                pickDate(context,setState2);
                                                              },
                                                            ), ),
                                                );
                                                    
                                                  },) ),
                                               Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                  padding:const  EdgeInsets.all(8.0),
                                                  child:  Center(child: TextFormFieldCustomOrderInput(controller: qtyController, borderColor: Colors.teal, hintText: "-qty-", textAlign: TextAlign.center, 
                                                  validator: (value) { 
                                                    //   if(batchcontroller.text!="" && qtyController.text!="" && selectedExpiredDateString!=""){
                                                    
                                                    //  widget.callbackFunction(BatchWiseItemListModel(batchId: batchcontroller.text, unitQty: qtyController.text, expiredDate: selectedExpiredDateString, eachbatchWiseItemString: ''));
                                                    //   batchcontroller.clear();
                                                    //   qtyController.clear();
                                                    //   setState(() {});

                                                    // }
                                                   }, afterClickingDone: () {  },)),
                                                )),
                                                 Expanded(child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:  Center(child: IconButton(onPressed: (){
                                                
                                                  //  widget.batchItems.removeAt(widget.indexNum);
                                                  //  widget.setState2;
                                                  //  setState(() {
                                                     
                                                  //  });
                                                 
                                                    
                                                   

                                                  }, icon:const Icon(Icons.delete,color: Colors.redAccent,size:20))),
                                                )),
                                              ],  
                                            ),
    );
  }

   initialValue(String val) {
    return TextEditingController(text: val);
  }

  pickDate(BuildContext context,void Function(void Function()) setState2) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate:selectedExpiredDate,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            colorScheme:const ColorScheme.light(primary: Colors.teal,),
            canvasColor: Colors.teal,
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;

    selectedExpiredDate = newDate;
    selectedExpiredDateString = DateFormat('yyyy-MM-dd').format(selectedExpiredDate);
    setState2(() => selectedExpiredDate = newDate);
  
  }
}