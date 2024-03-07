import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/ui/Expired_dated_section/expired_item_input_show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';

class ItemsExpiredDatedScreen extends StatefulWidget {
  final List<ExpiredItemList> expiredItemList;
  final List<AddItemModel> tempList;
  final Function tempListFunc;

  const ItemsExpiredDatedScreen(
      {Key? key,
      required this.expiredItemList,
      required this.tempList,
      // required this.uniqueId,
      required this.tempListFunc})
      : super(key: key);

  @override
  State<ItemsExpiredDatedScreen> createState() => _ItemsExpiredDatedScreenState();
}

class _ItemsExpiredDatedScreenState extends State<ItemsExpiredDatedScreen> {
  UserLoginModel? userLoginInfo;
  final _formkey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {};
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
  // bool promo_flag = false;

  @override
  void initState() {
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

    filteredItems = widget.expiredItemList;
    for (var element in filteredItems) {
      controllers[element.itemId] = TextEditingController();
    }
    for (var element in widget.tempList) {
      controllers.forEach((key, value) {
        if (key == element.item_id) {
          value.text = element.quantity.toString();
        }
      });
    }

    for (var element in widget.tempList) {
      total = (element.tp + element.vat) * element.quantity;

      orderamount = orderamount + total;
    }

    super.initState();
  }

  @override
  void dispose() {
    for (var element in filteredItems) {
      controllers[element.itemId]!.dispose();
    }

    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.tempListFunc(widget.tempList);
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
        incLen
            ? Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                child: Text(
                  orderamount.toStringAsFixed(2),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 27, 56, 34),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                child: Text(neworderamount.toStringAsFixed(2),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 27, 56, 34),
                        fontWeight: FontWeight.w500,
                        fontSize: 18)))
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
                      showDialog(context: context, builder:(BuildContext context){
                        return Theme( data: ThemeData(
                                 dialogBackgroundColor: Colors.white,
                                 dialogTheme: DialogTheme(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(16.0),
                                   ),
                                 ),
                                ), child: ExpiredIteminputShowDialogScreen(expiredItem: filteredItems[itemIndeex],

                               ));
                        
                      } );
                      // ExpiredIteminputShowDialogScreen()

                    },
                    child: Card(
                      // color: Colors.yellow.shade50,
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
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    // elevation: 1,
                                    child: Container(
                                      // height: 50,
                                      color:
                                          const Color.fromARGB(255, 138, 201, 149)
                                              .withOpacity(.3),
                                      width: 60,
                                      child: IconButton(onPressed: (){
                                       // batc.add(BatchItem());

                                      }, icon:const Icon(Icons.add))
                                      // TextFormField(
                                      //   textDirection: TextDirection.ltr,
                                      //   // maxLength: 1000,
                                      //   textAlign: TextAlign.center,
                                      //   controller: controllers[filteredItems[index].itemId
                                      //      ],
                                      //   keyboardType: TextInputType.number,
                                      //   decoration: const InputDecoration(
                                      //     border: OutlineInputBorder(),
                                      //   ),
                                      //   onChanged: (value) {
                                      //     itemCount(value, index);
                                      //   },
                                      // ),
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
                    // filteredItems = AllServices().searchDynamicMethod(
                    //     value, widget.expiredItemList, 'item_name');
                    // setState(() {});
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
                              // searchController.clear();
                              // foundUsers = AllServices().searchDynamicMethod(
                              //     '', widget.expiredItemList, 'item_name');
                              // setState(() {});
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
          widget.tempListFunc(widget.tempList);

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
              Icon(Icons.add_shopping_cart_outlined, size: 30),
              SizedBox(
                width: 5,
              ),
              Text(
                "AddToCart",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

//=========================================== Item count Method ===================================================
  itemCount(String value, int index) {
    // if (value != '') {
    //   final temp = AddItemModel(
    //       quantity: int.parse(controllers[foundUsers[index]['item_id']]!.text),
    //       item_name: foundUsers[index]['item_name'],
    //       tp: foundUsers[index]['tp'],
    //       item_id: foundUsers[index]['item_id'],
    //       category_id: foundUsers[index]['category_id'],
    //       vat: foundUsers[index]['vat'],
    //       manufacturer: foundUsers[index]['manufacturer'],
    //       promo: foundUsers[index]['promo'],
    //       stock: foundUsers[index]['stock'].toString());

    //   widget.tempList.removeWhere((item) => item.item_id == temp.item_id);
    //   widget.tempList.add(temp);
    //   incLen = false;
    //   neworderamount = 0.0;
    //   for (var element in widget.tempList) {
    //     total = (element.tp + element.vat) * element.quantity;

    //     neworderamount = neworderamount + total;
    //   }

    //   setState(() {});
    // } else if (value == '') {
    //   final temp = AddItemModel(
    //       quantity: value == ''
    //           ? 0
    //           : int.parse(controllers[foundUsers[index]['item_id']]!.text),
    //       item_name: foundUsers[index]['item_name'],
    //       tp: foundUsers[index]['tp'],
    //       item_id: foundUsers[index]['item_id'],
    //       category_id: foundUsers[index]['category_id'],
    //       vat: foundUsers[index]['vat'],
    //       manufacturer: foundUsers[index]['manufacturer'],
    //       promo: foundUsers[index]['promo'],
    //       stock: foundUsers[index]['stock'].toString());

    //   widget.tempList.removeWhere((item) => item.item_id == temp.item_id);
    //   // orderamount = 0.0;
    //   incLen = false;
    //   neworderamount = 0.0;
    //   for (var element in widget.tempList) {
    //     total = (element.tp + element.vat) * element.quantity;
    //     neworderamount = neworderamount + total;
    //   }

    //   setState(() {});
    // }
  }
}
