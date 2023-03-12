import 'package:flutter/material.dart';
import 'package:mrap7/local_storage/hive_data_model.dart';

class DcrPpmDataPage extends StatefulWidget {
  int uniqueId;
  List doctorPpmlist;
  List<DcrGSPDataModel> tempList;
  Function tempListFunc;
  DcrPpmDataPage(
      {Key? key,
      required this.uniqueId,
      required this.doctorPpmlist,
      required this.tempList,
      required this.tempListFunc})
      : super(key: key);

  @override
  State<DcrPpmDataPage> createState() => _DcrPpmDataPageState();
}

class _DcrPpmDataPageState extends State<DcrPpmDataPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  // final List<TextEditingController> _itemController = [];
  Map<String, TextEditingController> controllers = {};
  List foundUsers = [];

  final _formkey = GlobalKey<FormState>();
  String? itemId;

  // List<AddItemModel> finalItemDataList = [];

  @override
  void initState() {
    foundUsers = widget.doctorPpmlist;
    foundUsers.forEach((element) {
      controllers[element['ppm_id']] = TextEditingController();
    });
    widget.tempList.forEach((element) {
      itemId = element.giftId;
      // print('list: ${element.item_id}');
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();

    // foundUsers.forEach((element) {
    //   controllers[element['ppm_id']]!.dispose();
    // });
    super.dispose();
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.doctorPpmlist;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
      print(results);
    } else {
      var starts = foundUsers
          .where((s) => s['ppm_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['ppm_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) &&
              !s['ppm_name']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) =>
            a['ppm_name'].toLowerCase().compareTo(b['ppm_name'].toLowerCase()));

      results = [...starts, ...contains];
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  // int _currentSelected = 0;
  // _onItemTapped(int index) async {
  //   if (index == 1) {
  //     widget.tempListFunc(widget.tempList);

  //     Navigator.pop(context);
  //     setState(() {
  //       _currentSelected = index;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        title: const Text('PPM'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
      ),
      // bottomNavigationBar: BottomNavigationBar(
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
      //         color: Colors.white,
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
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        onChanged: (value) => runFilter(value),
                        controller: searchController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
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
                      physics: const ScrollPhysics(),
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              foundUsers[index]['ppm_name'],
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 30, 66, 77),
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              foundUsers[index]['ppm_id'],
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 30, 66, 77),
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Card(
                                              elevation: 1,
                                              child: Container(
                                                height: 40,
                                                color: const Color.fromARGB(
                                                        255, 138, 201, 149)
                                                    .withOpacity(.3),
                                                width: 70,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  controller: controllers[
                                                      foundUsers[index]
                                                          ['ppm_id']],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.0)),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {});
                                                    if (value != '') {
                                                      var temp = DcrGSPDataModel(
                                                          uiqueKey: widget
                                                              .uniqueId,
                                                          quantity: int.parse(
                                                              controllers[foundUsers[
                                                                          index]
                                                                      [
                                                                      'ppm_id']]!
                                                                  .text),
                                                          giftName:
                                                              foundUsers[index]
                                                                  ['ppm_name'],
                                                          giftId:
                                                              foundUsers[index]
                                                                  ['ppm_id'],
                                                          giftType: 'PPM');

                                                      // widget.tempList
                                                      //     .forEach((element) {
                                                      //   itemId = element.giftId;
                                                      // });

                                                      String tempItemId =
                                                          temp.giftId;

                                                      widget.tempList
                                                          .removeWhere((item) =>
                                                              item.giftId ==
                                                              tempItemId);

                                                      widget.tempList.add(temp);
                                                      // } else {
                                                      //   widget.tempList
                                                      //       .add(temp);
                                                      // }
                                                    } else if (value == '') {
                                                      final temp =
                                                          DcrGSPDataModel(
                                                        uiqueKey:
                                                            widget.uniqueId,
                                                        quantity: value == ''
                                                            ? 0
                                                            : int.parse(controllers[
                                                                    foundUsers[
                                                                            index]
                                                                        [
                                                                        'ppm_id']]!
                                                                .text),
                                                        giftName:
                                                            foundUsers[index]
                                                                ['ppm_name'],
                                                        giftId:
                                                            foundUsers[index]
                                                                ['ppm_id'],
                                                        giftType: 'PPM',
                                                      );

                                                      String tempItemId =
                                                          temp.giftId;

                                                      widget.tempList
                                                          .removeWhere((item) =>
                                                              item.giftId ==
                                                              tempItemId);

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
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : const Text(
                      'No data found',
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
