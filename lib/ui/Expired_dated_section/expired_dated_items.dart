import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/models/expired_dated/expired_submit_and_save_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/expired_dated/expired_services.dart';
import 'package:MREPORTING/ui/Expired_dated_section/expired_item_input_show_dialog.dart';
import 'package:flutter/material.dart';

class ItemsExpiredDatedScreen extends StatefulWidget {
  final List<ExpiredItemList> syncItem;
  Map<String,dynamic> customerInfo;
  List<ExpiredItemSubmitModel> expiredItemSubmitModel;
  final Function(List<ExpiredItemSubmitModel>?) callbackMethod;

   ItemsExpiredDatedScreen(
      {Key? key,
      required this.syncItem,
      required this.customerInfo,
      required this.expiredItemSubmitModel,
      // required this.uniqueId,
      required this.callbackMethod})
      : super(key: key);

  @override
  State<ItemsExpiredDatedScreen> createState() => _ItemsExpiredDatedScreenState();
}

class _ItemsExpiredDatedScreenState extends State<ItemsExpiredDatedScreen> {
  UserLoginModel? userLoginInfo;
  final _formkey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {}; 
  int batchwiseCount=0;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();

  DmPathDataModel? dmpathData;
  List<ExpiredItemList> filteredItems=[];
  var orderamount = 0.0;
  var neworderamount = 0.0;
  int amount = 0;
  bool isInList = false;
  var total = 0.0;
  bool incLen = true;
  @override
  void initState() {
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

    filteredItems = widget.syncItem;
    itemCount();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.callbackMethod(widget.expiredItemSubmitModel);
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBarWidget(),
        body: Column(
          children: [
            itemSearchTextFormWidget(),
            itemListViewBuilderWIdget(),
            const SizedBox(
              height: 5,
            ),
            addtoCartButtonWidget(context)
          ],
        ),
      ),
    );
  }

//=================================================================================================================
//======================================= All Widget ===============================================================
//==================================================================================================================
  AppBar appBarWidget() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 138, 201, 149),
      title: const Text('Product List'),
      titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 27, 56, 34),
          fontWeight: FontWeight.w500,
          fontSize: 20),
      centerTitle: true,
      actions: [
         Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                child: Text(
                  batchwiseCount.toStringAsFixed(0),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 27, 56, 34),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              )
            // : Padding(
            //     padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
            //     child: Text(neworderamount.toStringAsFixed(2),
            //         style: const TextStyle(
            //             color: Color.fromARGB(255, 27, 56, 34),
            //             fontWeight: FontWeight.w500,
            //             fontSize: 18)))
      ],
    );
  }

//=======================================================ListView Builder=================================================
  Expanded itemListViewBuilderWIdget() {
    return Expanded(
      flex: 9,
      child: Form(
        key: _formkey,
        child: filteredItems.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: filteredItems.length,
                itemBuilder: (context, itemIndeex) {
                  return GestureDetector(
                    onTap: (){
                      ExpiredItemSubmitModel? expiredItemModel;
                      for (var element in widget.expiredItemSubmitModel) {
                        if(element.itemId==filteredItems[itemIndeex].itemId ){
                          expiredItemModel=element;
                        }
                        
                      }

                      showDialog(context: context, builder:(BuildContext context){
                        return Theme( data: ThemeData(
                                 dialogBackgroundColor: Colors.white,
                                 dialogTheme: DialogTheme(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(16.0),
                                   ),
                                 ),
                                ), 
                               child: ExpiredIteminputShowDialogScreen(
                                  expiredItem: filteredItems[itemIndeex],
                                  expiredItemSubmitModel: expiredItemModel, 

                                  callbackFunction: (value ) { 
                                    if(value!=null){
                                     widget.expiredItemSubmitModel.removeWhere((element) => element.itemId==value.itemId);
                                     widget. expiredItemSubmitModel.add(value);
                                     itemCount() ;
                                     widget.callbackMethod(widget.expiredItemSubmitModel);
                                     Navigator.pop(context) ;
                                    
                                    }
                                    
                                   }, clinetId: widget.customerInfo["client_id"], itemId: filteredItems[itemIndeex].itemId, 

                               ));
                        
                      } );
                     

                    },
                    child: Card(
                      elevation: 0.3,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromARGB(108, 255, 255, 255), width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          
                          children: [
                            Expanded(
                              flex: 9,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                 
                                  children: [
                                    Text(
                                      filteredItems[itemIndeex].itemName,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 8, 18, 20),
                                          fontSize: 15),
                                    ),
                                   const SizedBox(height: 2,),
                                    Row(
                                      children: [
                                        Text(
                                          '${filteredItems[itemIndeex].categoryId} ',
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 8, 18, 20),
                                              fontSize: 11),
                                        ),
                                        
                                      ],
                                    ),
                                  
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    child: Container(
                                      color:
                                          const Color.fromARGB(255, 138, 201, 149)
                                              .withOpacity(.3),
                                      width: 60,
                                      child:const IconButton(onPressed: null, icon: Icon(Icons.add,color: Colors.black,))
                                     
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : const Text(
                'No Data found',
                style: TextStyle(fontSize: 24),
              ),
      ),
    );
  }

//================================================ Item search============================================================
  SizedBox itemSearchTextFormWidget() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),color: Colors.teal.shade50,
                ),
                child: TextFormField(
                  onChanged: (value) {
                    filteredItems = ExpiredServices().searchDynamicMethod(
                        value, widget.syncItem);
                    setState(() {});
                  },
                  
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText:" Search Items here.....",
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    
                    // border: const OutlineInputBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(5))),
                   // labelText: 'Item Search',
                    suffixIcon: searchController.text.isEmpty &&
                            searchController.text == ''
                        ? const Icon(Icons.search)
                        : IconButton(
                            onPressed: () {
                              searchController.clear();
                              filteredItems = ExpiredServices().searchDynamicMethod(
                                  '', widget.syncItem);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black,
                              // size: 28,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//====================================================== Add to Cart ====================================================
  Align addtoCartButtonWidget(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
        
          widget.expiredItemSubmitModel=widget.expiredItemSubmitModel;
          widget.callbackMethod(widget.expiredItemSubmitModel);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
          backgroundColor: const Color.fromARGB(255, 4, 60, 105),
          maximumSize: const Size(200, 50),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(5))),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              //Icon(Icons.add_shopping_cart_outlined, size: 30),
              SizedBox(
                width: 5,
              ),
              Text(
                "Add as Expired",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

//=========================================== Item count Method ===================================================
  itemCount() {
    batchwiseCount=0;
    widget.expiredItemSubmitModel.forEach((element) {
      element.batchWiseItem.forEach((element) { 
        batchwiseCount+=1;
        print("data $batchwiseCount");

      });

     });
     print("batchwise counter=$batchwiseCount");
   
  }
}
