import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/models/expired_dated/expired_submit_and_save_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/expired_dated/expired_services.dart';
import 'package:MREPORTING/ui/Expired_dated_section/cancel-button.dart';
import 'package:MREPORTING/ui/Expired_dated_section/confirm_widget.dart';
import 'package:MREPORTING/ui/Expired_dated_section/each_batch_scareen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ExpiredIteminputShowDialogScreen extends StatefulWidget {
  ExpiredItemList expiredItem;
  String itemId;
  String clinetId;
  ExpiredItemSubmitModel? expiredItemSubmitModel;
  Function(ExpiredItemSubmitModel?) callbackFunction;


  ExpiredIteminputShowDialogScreen({super.key, 
      required this.expiredItem,
      required this.itemId,
      required this.clinetId,
      required this.expiredItemSubmitModel,
      required this.callbackFunction,
  });

  @override
  State<ExpiredIteminputShowDialogScreen> createState() => _ExpiredIteminputShowDialogScreenState();
}

class _ExpiredIteminputShowDialogScreenState extends State<ExpiredIteminputShowDialogScreen> {
  List<DynamicItemsWidget> batchItems=[];
  List<BatchWiseItemListModel> batchWiseItemSaved=[];
    final customerExpiredItemsBox = Boxes.getExpiredItemSubmitItems();
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
    if(widget.expiredItemSubmitModel!=null){
      for (var element in widget.expiredItemSubmitModel!.batchWiseItem) {
        batchItems.add(DynamicItemsWidget(
          batchWiseItemListModel:element, 
          itemName: widget.expiredItem.itemName,
          batchwiseItemList:batchWiseItemSaved,
          isDelete: false, onTap: () { 
            int index= batchItems.length;
            batchItems.removeAt(index-1);
           ExpiredServices().  deleteEachItem(customerExpiredItemsBox,widget.itemId,widget.clinetId,element.batchId, element.expiredDate, element.unitQty);
            setState(() { });
           }, 
           )); 
           batchWiseItemSaved.add(element);
           print("*************save init ${batchWiseItemSaved.length}******************");
      }
    }
  }
  deleteItem(String batchId, String expiredDate, String qty){
    dynamic desireKey;
    customerExpiredItemsBox.toMap().forEach((key, value) {
      if (value.clientId == widget.clinetId) {
        desireKey = key;  
      }
     });
     ExpiredSubmitDataModel? clientData = customerExpiredItemsBox.get(desireKey);
    if (clientData!.isInBox) {
      for (var element in clientData.expiredItemSubmitModel) {
        if(element.itemId==widget.itemId){
           element.batchWiseItem.removeWhere((element1) => (element1.batchId==batchId)&&(element1.expiredDate==expiredDate)&&(element1.unitQty==qty)); 
        }  
      }
       clientData.expiredItemSubmitModel.removeWhere((element) =>element.batchWiseItem.isEmpty );
    }
    customerExpiredItemsBox.put(desireKey, clientData);
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
                                                      print("*************save show dialog 1 ${batchWiseItemSaved.length}******************");
                                                      return EachBtachItemWidget(
                                                        itemName:widget.expiredItem.itemName , 
                                                        batchWiseItemSaved: null, 
                                                        callbackFunction: (BatchWiseItemListModel? value ) {
                                                          batchWiseItemSaved.add(value!) ;
                                                          print("*************save show dialog vitor ${batchWiseItemSaved.length}******************");
                                                          var dynamicWidget=  DynamicItemsWidget(
                                                                    batchWiseItemListModel:value,
                                                                     itemName: widget.expiredItem.itemName, 
                                                                     batchwiseItemList:batchWiseItemSaved, 
                                                                     onTap: (){
                                                                      int index= batchItems.length;
                                                                      batchItems.removeAt(index-1);
                                                                      deleteItem(value.batchId, value.expiredDate, value.unitQty);
                                                                      setState(() { 
                                                                      });
                                                                    },
                                                                    isDelete: false,
                                                                   );
                                                                batchItems.add(
                                                                  dynamicWidget
                                                                  );
                                                                setState(() {
                                                                  
                                                                });
                                                        
                                                        setState(() {
                                                          
                                                        });
                                                       }, routeName: false,

                                                      );

                                                    },
                                                    );
                                                   
                                                  }, icon:const Icon(Icons.add,color:  Color.fromARGB(255, 82, 179, 98),))))
                                             ],
                                           ),
                                        
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
                            else{
                              final eachItemtemList=ExpiredItemSubmitModel(itemName: widget.expiredItem.itemName.toString(), quantity: widget.expiredItem.stock.toString(), tp:widget.expiredItem.tp.toString()
                               , itemId: widget.expiredItem.itemId.toString(), categoryId: widget.expiredItem.categoryId.toString(), vat: widget.expiredItem.vat.toString(), manufacturer: widget.expiredItem.manufacturer.toString(), itemString: "", batchWiseItem: batchWiseItemSaved);
                               widget.expiredItemSubmitModel= eachItemtemList;
                               widget.callbackFunction(widget.expiredItemSubmitModel);
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
  List<BatchWiseItemListModel> batchwiseItemList;
  void Function()? onTap;
  
  bool isDelete; 
  String itemName;
  DynamicItemsWidget({
    super.key, 
    required this.itemName,
    required this.batchWiseItemListModel,
    required this.batchwiseItemList,
    required this.onTap,
   
    required this.isDelete,
 
  });

  @override
  State<DynamicItemsWidget> createState() => _DynamicItemsWidgetState();
}

class _DynamicItemsWidgetState extends State<DynamicItemsWidget> {
  @override
  Widget build(BuildContext context) {
                return GestureDetector(
                  onTap: (){
                   
                                    showDialog(context: context, builder: (BuildContext context){
                                                      return EachBtachItemWidget(
                                                        itemName:widget.itemName, 
                                                        batchWiseItemSaved: widget.batchWiseItemListModel, 
                                                        callbackFunction: (BatchWiseItemListModel? value ) {

                                                          widget.batchWiseItemListModel=value;
                                                          setState(() {
                                                            
                                                          });
                                                         // print("data");
                                                      
                                                       }, routeName: true,

                                                      );

                                                    },);
                  },
                  
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 1,),
                    child:Column(
                      children: [
                        SizedBox(
                  height: 35,
                  child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(child: Text(widget.batchWiseItemListModel!.batchId,style:const TextStyle(fontSize: 14),)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(child: Text(widget.batchWiseItemListModel!.expiredDate,style:const TextStyle(fontSize: 14),)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Center(child: Text(widget.batchWiseItemListModel!.unitQty,style:const TextStyle(fontSize: 14),)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Center(
                                child: IconButton(
                                  onPressed:widget.onTap,
                                 
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 15),
                                ),
                              ),
                            ),
                          ),
                        ],
                  ),
                ),
                Divider(thickness: 0.7,)
                      ],
                    )
                 
                    ),
                );
  }

  //  
}