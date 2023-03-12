// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mrap7/Pages/loginPage.dart';
import 'package:mrap7/local_storage/hive_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSyncItemData extends StatefulWidget {
  List syncItemList;
  List<AddItemModel> tempList;
  int uniqueId;
  Function tempListFunc;

  ShowSyncItemData(
      {Key? key,
      required this.syncItemList,
      required this.tempList,
      required this.uniqueId,
      required this.tempListFunc})
      : super(key: key);

  @override
  State<ShowSyncItemData> createState() => _ShowSyncItemDataState();
}

class _ShowSyncItemDataState extends State<ShowSyncItemData> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();

  List foundUsers = [];
  List temp = [];
  var orderamount = 0.0;
  var neworderamount = 0.0;
  String? itemId;
  int amount = 0;
  int uniqueId = 0;
  bool isInList = false;
  var total = 0.0;
  bool incLen = true;
  bool promo_flag = false;
  // bool? offer_flag;
  final _formkey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {};

  sharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    offer_flag = prefs.getBool("offer_flag") ?? false;
    promo_flag = prefs.getBool("promo_flag") ?? false;
  }

  @override
  void initState() {
    foundUsers = widget.syncItemList;
    foundUsers.forEach((element) {
      controllers[element['item_id']] = TextEditingController();
    });
    for (var element in widget.tempList) {
      controllers.forEach((key, value) {
        if (key == element.item_id) {
          value.text = element.quantity.toString();
        }
      });
    }
    if (widget.tempList.isNotEmpty) {
      // print("templist ${widget.tempList.first.quantity}");
    }
    widget.tempList.forEach((element) {
      total = (element.tp + element.vat) * element.quantity;

      orderamount = orderamount + total;
    });
    // widget.tempList.forEach((element) {
    //   print(element.tp);
    // });
    // orderamount = orderamount + total;

    // widget.tempList.forEach((element) {
    //   itemId = element.item_id;
    // });
    sharedpref();
    // print(offer_flag);
    super.initState();
  }

  @override
  void dispose() {
    foundUsers.forEach((element) {
      controllers[element['item_id']]!.dispose();
    });

    searchController.dispose();
    super.dispose();
  }

  int _currentSelected = 0;
  _onItemTapped(int index) async {
    if (index == 1) {
      // _formkey.currentState!.save();
      widget.tempListFunc(widget.tempList);

      Navigator.pop(context);
      setState(() {
        _currentSelected = index;
      });
    }
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.syncItemList;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
      // print(results);
    } else {
      var starts = foundUsers
          .where((s) => s['item_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['item_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) &&
              !s['item_name']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) => a['item_name']
            .toLowerCase()
            .compareTo(b['item_name'].toLowerCase()));

      results = [...starts, ...contains];
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  void runFilter2(String enteredKeyword) {
    foundUsers = widget.syncItemList;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
    } else {
      results = foundUsers
          .where((user) => user['category_id'].contains(enteredKeyword))
          .toList();

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.greenAccent,
      //   // type: BottomNavigationBarType.fixed,
      //   onTap: (index) {
      //     _onItemTapped(index);
      //   },
      //   currentIndex: 1,
      //   // showUnselectedLabels: true,
      //   unselectedItemColor: Colors.grey[800],
      //   selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       label: '',
      //       icon: Icon(
      //         Icons.save,
      //         color: Colors.greenAccent,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       // activeIcon: Icon(Icons.add_shopping_cart_outlined),
      //       label: 'AddtoCart',
      //       icon: Icon(Icons.add_shopping_cart_outlined),
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 70,
                      child: TextFormField(
                        onChanged: (value) => runFilter(value),
                        controller: searchController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: 'Item Search',
                          suffixIcon: searchController.text.isEmpty &&
                                  searchController.text == ''
                              ? const Icon(Icons.search)
                              : IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    runFilter('');
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
          ),
          Expanded(
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
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color.fromARGB(108, 255, 255, 255),
                                width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // crossAxisAlignment: ,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            foundUsers[index]['item_name'],
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 18, 20),
                                                fontSize: 17),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            foundUsers[index]['category_id'],
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 18, 20),
                                                fontSize: 14),
                                          ),
                                        ),
                                        promo_flag == true
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: AnimatedTextKit(
                                                  repeatForever: true,
                                                  animatedTexts: [
                                                    ColorizeAnimatedText(
                                                      foundUsers[index]
                                                          ['promo'],
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      8,
                                                                      18,
                                                                      20),
                                                              fontSize: 15),
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 18, 137, 235),
                                                        Colors.red
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Text(""),
                                        //   !foundUsers.contains(
                                        //           foundUsers[index]["promo"])
                                        //       ? Flexible(
                                        //           child: Container(
                                        //             // width: double.infinity,
                                        //             decoration: BoxDecoration(
                                        //                 color:
                                        //                     Colors.lightBlue[100],
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(
                                        //                         10)),
                                        //             child: Padding(
                                        //               padding:
                                        //                   const EdgeInsets.all(
                                        //                       4.0),
                                        //               child: AnimatedTextKit(
                                        //                 repeatForever: true,
                                        //                 animatedTexts: [
                                        //                   ColorizeAnimatedText(
                                        //                     foundUsers[index]
                                        //                         ['promo'],
                                        //                     textStyle:
                                        //                         const TextStyle(
                                        //                             color: Color
                                        //                                 .fromARGB(
                                        //                                     255,
                                        //                                     8,
                                        //                                     18,
                                        //                                     20),
                                        //                             fontSize: 15),
                                        //                     colors: [
                                        //                       const Color
                                        //                               .fromARGB(
                                        //                           255, 0, 0, 0),
                                        //                       Colors.red
                                        //                     ],
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         )
                                        //       : Container(
                                        //           color: Colors.white,
                                        //         ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Card(
                                          elevation: 1,
                                          child: Container(
                                            // height: 50,
                                            color: const Color.fromARGB(
                                                    255, 138, 201, 149)
                                                .withOpacity(.3),
                                            width: 70,
                                            child: TextFormField(
                                              textDirection: TextDirection.ltr,
                                              // maxLength: 1000,
                                              textAlign: TextAlign.center,
                                              controller: controllers[
                                                  foundUsers[index]['item_id']],
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: (value) {
                                                if (value != '') {
                                                  final temp = AddItemModel(
                                                    uiqueKey1: widget.uniqueId,
                                                    quantity: int.parse(
                                                        controllers[foundUsers[
                                                                    index]
                                                                ['item_id']]!
                                                            .text),
                                                    item_name: foundUsers[index]
                                                        ['item_name'],
                                                    tp: foundUsers[index]['tp'],
                                                    item_id: foundUsers[index]
                                                        ['item_id'],
                                                    category_id:
                                                        foundUsers[index]
                                                            ['category_id'],
                                                    vat: foundUsers[index]
                                                        ['vat'],
                                                    manufacturer:
                                                        foundUsers[index]
                                                            ['manufacturer'],
                                                  );
//********************************************************************************** */
//********************************************************************************** */
// //********************************************************************************** */

                                                  String tempItemId =
                                                      temp.item_id;

                                                  widget.tempList.removeWhere(
                                                      (item) =>
                                                          item.item_id ==
                                                          tempItemId);

                                                  widget.tempList.add(temp);

                                                  final text = controllers[
                                                          foundUsers[index]
                                                              ['item_id']]!
                                                      .text;

                                                  incLen = false;
                                                  neworderamount = 0.0;
                                                  widget.tempList
                                                      .forEach((element) {
                                                    total = (element.tp +
                                                            element.vat) *
                                                        element.quantity;

                                                    neworderamount =
                                                        neworderamount + total;
                                                  });

                                                  setState(() {});

                                                  //********************************************************************************** */
//********************************************************************************** */
// //********************************************************************************** */
                                                  // setState(() {});
                                                } else if (value == '') {
                                                  final temp = AddItemModel(
                                                    uiqueKey1: widget.uniqueId,
                                                    quantity: value == ''
                                                        ? 0
                                                        : int.parse(controllers[
                                                                foundUsers[
                                                                        index][
                                                                    'item_id']]!
                                                            .text),
                                                    item_name: foundUsers[index]
                                                        ['item_name'],
                                                    tp: foundUsers[index]['tp'],
                                                    item_id: foundUsers[index]
                                                        ['item_id'],
                                                    category_id:
                                                        foundUsers[index]
                                                            ['category_id'],
                                                    vat: foundUsers[index]
                                                        ['vat'],
                                                    manufacturer:
                                                        foundUsers[index]
                                                            ['manufacturer'],
                                                  );

                                                  String tempItemId =
                                                      temp.item_id;

                                                  widget.tempList.removeWhere(
                                                      (item) =>
                                                          item.item_id ==
                                                          tempItemId);
                                                  // orderamount = 0.0;
                                                  incLen = false;
                                                  neworderamount = 0.0;
                                                  widget.tempList
                                                      .forEach((element) {
                                                    total = (element.tp +
                                                            element.vat) *
                                                        element.quantity;
                                                    neworderamount =
                                                        neworderamount + total;
                                                  });

                                                  // var t = orderamount;
                                                  // print(
                                                  //     "orderamount ashbe ${neworderamount}");
                                                  setState(() {});
                                                }
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
                          ),
                        );
                      })
                  : const Text(
                      'No Data found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                widget.tempListFunc(widget.tempList);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                maximumSize: const Size(200, 50),
                primary: const Color.fromARGB(255, 4, 60, 105),
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
          )
        ],
      ),
    );
  }
}
