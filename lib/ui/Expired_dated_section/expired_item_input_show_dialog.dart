import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/ui/Expired_dated_section/cancel-button.dart';
import 'package:MREPORTING/ui/Expired_dated_section/confirm_widget.dart';
import 'package:MREPORTING/ui/Expired_dated_section/textform_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ExpiredIteminputShowDialogScreen extends StatefulWidget {
  ExpiredItemList expiredItem; 
//  List<ExpiredItemList> savedData;
//  ExpiredItemList? itemInfoMR;
//  final ItemListStock marketReturnSyncItem;
//  Function(MarketReturnItem?) callbackFunction;

  ExpiredIteminputShowDialogScreen({super.key, required this.expiredItem
  // required this.savedData, required this.itemInfoMR,
  // required this.marketReturnSyncItem,required this.callbackFunction
  });

  @override
  State<ExpiredIteminputShowDialogScreen> createState() => _ExpiredIteminputShowDialogScreenState();
}

class _ExpiredIteminputShowDialogScreenState extends State<ExpiredIteminputShowDialogScreen> {
  // List<
  // List<String> reasonForMarketReturn = ['Date Expired', 'Micro Leak', 'Product Damage'];
  List<DynamicItemsWidget> batchItems=[];
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                               Row(
                                children: [        
                                             Expanded(
                                              flex: 8,
                                              child:Center(child: Text(widget.expiredItem.itemName,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),))),Expanded(
                                                child:Center(child: IconButton(onPressed: (){
                                                  batchItems.add(DynamicItemsWidget());
                                                  setState(() {
                                                    
                                                  });
                                                   print(batchItems.length);
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
                             if(pcsController.text.isEmpty  ){
                                AllServices().toastMessageForSubmitData("Please add something", Colors.red, Colors.white, 16);
                              }
                            //  else  if(selectedReasonForMR==null)  {
                            //     AllServices().toastMessageForSubmitData("Please add reason for market return ", Colors.red, Colors.white, 16);
                            //   }
                            //   else if(pcsController.text.isEmpty)  {
                            //     AllServices().toastMessageForSubmitData("Please add quantity ", Colors.red, Colors.white, 16); 
                            //   }
                              
                            else{
                              // final getSyncItem=Boxes.marketReturnSavedata().get('MarketReturnSavedData');
                              //if(getSyncItem!.clientId==widget.) 

                              
                              //  MarketReturnItem? marketReturnItem=  AllServices().addMarketReturnItem(pcsController.text,selectedReasonForMR.toString(),selectedExpiredDateString,widget.savedData, widget.marketReturnSyncItem ); 
                               
                              //  widget.callbackFunction(marketReturnItem);
                               Navigator.pop(context) ;
                             

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
                                               Expanded(child: Padding(
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



class DynamicItemsWidget extends StatelessWidget {
  DateTime selectedExpiredDate=DateTime.now();
  String selectedExpiredDateString=DateFormat('yyyy-MM-dd').format(DateTime.now());
  
  TextEditingController batchcontroller=TextEditingController();
  
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
                                                  child:  Center(child: TextFormFieldCustomOrderInput(controller: batchcontroller, borderColor: Colors.teal, hintText: "Batch id", textAlign: TextAlign.center, validator: (value) {  }, afterClickingDone: () {  },)),
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
                                                              textAlign: TextAlign.left,
                                                              
                                                              decoration:const InputDecoration(
                                                                suffixIcon: Icon(Icons.calendar_month_outlined,color: Colors.teal,),
                                                                focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1, 
                                                                    color:  Colors.white
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
                                                                setState2(() {});
                                                                selectedExpiredDateString  = value;
                                                            
                                                              },
                                                              onTap: () {
                                                                pickDate(context,setState2);
                                                              },
                                                            ), ),
                                                );
                                                    
                                                  },) ),
                                               Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                  padding:const  EdgeInsets.all(8.0),
                                                  child:  Center(child: TextFormFieldCustomOrderInput(controller: batchcontroller, borderColor: Colors.teal, hintText: "value", textAlign: TextAlign.center, validator: (value) {  }, afterClickingDone: () {  },)),
                                                )),
                                                 Expanded(child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:  Center(child: IconButton(onPressed: (){
                                                  //  batchItems.add(DynamicItemsWidget())

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
            colorScheme: ColorScheme.light(primary: Colors.teal,),
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