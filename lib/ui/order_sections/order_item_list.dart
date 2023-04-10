import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:flutter/material.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';

class ShowSyncItemData extends StatefulWidget {
  final List syncItemList;
  final List<AddItemModel> tempList;
  final Function tempListFunc;

  const ShowSyncItemData(
      {Key? key,
      required this.syncItemList,
      required this.tempList,
      // required this.uniqueId,
      required this.tempListFunc})
      : super(key: key);

  @override
  State<ShowSyncItemData> createState() => _ShowSyncItemDataState();
}

class _ShowSyncItemDataState extends State<ShowSyncItemData> {
  UserLoginModel? userLoginInfo;
  final _formkey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {};
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();

  DmPathDataModel? dmpathData;

  List foundUsers = [];
  var orderamount = 0.0;
  var neworderamount = 0.0;
  int amount = 0;
  bool isInList = false;
  var total = 0.0;
  bool incLen = true;
  bool promo_flag = false;

  @override
  void initState() {
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

    foundUsers = widget.syncItemList;
    for (var element in foundUsers) {
      controllers[element['item_id']] = TextEditingController();
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
    for (var element in foundUsers) {
      controllers[element['item_id']]!.dispose();
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
        child: foundUsers.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: foundUsers.length,
                itemBuilder: (context, index) {
                  return Card(
                    // color: Colors.yellow.shade50,
                    // elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color.fromARGB(108, 255, 255, 255), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // crossAxisAlignment: ,
                              children: [
                                Text(
                                  foundUsers[index]['item_name'],
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 8, 18, 20),
                                      fontSize: 16),
                                ),
                                Text(
                                  foundUsers[index]['category_id'],
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 8, 18, 20),
                                      fontSize: 14),
                                ),
                                userLoginInfo!.promoFlag &&
                                        foundUsers[index]['promo'] != ''
                                    ? Card(
                                        color: Colors.yellow,
                                        child: Text(
                                          foundUsers[index]['promo'],
                                          style: const TextStyle(
                                              color:
                                                  // Colors.teal,
                                                  Color.fromARGB(
                                                      255, 238, 4, 4),
                                              fontSize: 14),
                                        ),
                                      )
                                    // ? Padding(
                                    //     padding: const EdgeInsets.all(4.0),
                                    //     child: AnimatedTextKit(
                                    //       repeatForever: true,
                                    //       animatedTexts: [
                                    //         ColorizeAnimatedText(
                                    //           foundUsers[index]['promo'],
                                    //           textStyle: const TextStyle(
                                    //               color: Color.fromARGB(
                                    //                   255, 8, 18, 20),
                                    //               fontSize: 15),
                                    //           colors: [
                                    //             const Color.fromARGB(
                                    //                 255, 18, 137, 235),
                                    //             Colors.red
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   )
                                    : Container(),
                              ],
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
                                    child: TextFormField(
                                      textDirection: TextDirection.ltr,
                                      // maxLength: 1000,
                                      textAlign: TextAlign.center,
                                      controller: controllers[foundUsers[index]
                                          ['item_id']],
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        itemCount(value, index);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
  Expanded itemSearchTextFormWidget() {
    return Expanded(
      flex: 1,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  foundUsers = AllServices().searchDynamicMethod(
                      value, widget.syncItemList, 'item_name');
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: 'Item Search',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            foundUsers = AllServices().searchDynamicMethod(
                                '', widget.syncItemList, 'item_name');
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
    if (value != '') {
      final temp = AddItemModel(
        quantity: int.parse(controllers[foundUsers[index]['item_id']]!.text),
        item_name: foundUsers[index]['item_name'],
        tp: foundUsers[index]['tp'],
        item_id: foundUsers[index]['item_id'],
        category_id: foundUsers[index]['category_id'],
        vat: foundUsers[index]['vat'],
        manufacturer: foundUsers[index]['manufacturer'],
      );

      widget.tempList.removeWhere((item) => item.item_id == temp.item_id);
      widget.tempList.add(temp);
      incLen = false;
      neworderamount = 0.0;
      for (var element in widget.tempList) {
        total = (element.tp + element.vat) * element.quantity;

        neworderamount = neworderamount + total;
      }

      setState(() {});
    } else if (value == '') {
      final temp = AddItemModel(
        quantity: value == ''
            ? 0
            : int.parse(controllers[foundUsers[index]['item_id']]!.text),
        item_name: foundUsers[index]['item_name'],
        tp: foundUsers[index]['tp'],
        item_id: foundUsers[index]['item_id'],
        category_id: foundUsers[index]['category_id'],
        vat: foundUsers[index]['vat'],
        manufacturer: foundUsers[index]['manufacturer'],
      );

      widget.tempList.removeWhere((item) => item.item_id == temp.item_id);
      // orderamount = 0.0;
      incLen = false;
      neworderamount = 0.0;
      for (var element in widget.tempList) {
        total = (element.tp + element.vat) * element.quantity;
        neworderamount = neworderamount + total;
      }

      setState(() {});
    }
  }
}
