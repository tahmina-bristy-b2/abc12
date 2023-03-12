// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrap7/Pages/loginPage.dart';
import 'package:mrap7/Pages/order_sections/newOrderPage.dart';

import 'package:mrap7/Widgets/customerListWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

class CustomerListScreen extends StatefulWidget {
  List data;

  CustomerListScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  Box? box;
  String client_url = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  bool client_flag = false;
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  int _counter = 0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      cid = prefs.getString("CID")!;

      userId = prefs.getString("USER_ID")!;

      userPassword = prefs.getString("PASSWORD")!;

      client_url = prefs.getString("client_url") ?? '';
      client_flag = prefs.getBool("client_flag") ?? false;
      // print('$client_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword');
      if (prefs.getInt("_counter") != null) {
        int? a = prefs.getInt("_counter");

        setState(() {
          _counter = a!;
        });
      }
    });

    foundUsers = widget.data;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('_counter', _counter);
    });

    setState(() {});
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.data;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
    } else {
      var starts = foundUsers
          .where((s) => s['client_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['client_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) &&
              !s['client_name']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) => a['client_name']
            .toLowerCase()
            .compareTo(b['client_name'].toLowerCase()));

      results = [...starts, ...contains];
    }

    // Refresh the UI....................
    setState(() {
      foundUsers = results;
    });
  }

  // int _currentSelected = 0;

  // _onItemTapped(int index) async {
  //   if (index == 0) {
  //     Navigator.pop(context);
  //     setState(() {
  //       _currentSelected = index;
  //     });
  //   }
  //   if (index == 1) {
  //     getDrawer();
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
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     // LinearGradient
        //     gradient: LinearGradient(
        //       // colors for gradient
        //       colors: [
        //         Color(0xff70BA85),
        //         Color(0xff56CCF2),
        //       ],
        //     ),
        //   ),
        // ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text('Customer List'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 138, 201, 149)),
              child: Column(
                children: [
                  Image.asset('assets/images/mRep7_logo.png'),
                  // Expanded(
                  //   child: Text(
                  //     '${widget.clientName}',
                  //     // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                  //     style: const TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // Expanded(
                  //     child: Text(
                  //   widget.clientId,
                  //   style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold),
                  // ))
                ],
              ),
            ),
            client_flag
                ? Link(
                    uri: Uri.parse(
                        '$client_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                    target: LinkTarget.blank,
                    builder: (BuildContext ctx, FollowLink? openLink) {
                      return ListTile(
                        onTap: openLink,
                        leading: const Icon(Icons.person_add,
                            color: Colors.blueAccent),
                        title: const Text(
                          'Customer',
                          style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 15, 53, 85)),
                        ),
                      );
                    })
                : Container()
            // ListTile(
            //   leading: const Icon(Icons.document_scanner_outlined,
            //       color: Colors.black),
            //   title: const Text('Report'),
            //   onTap: () {
            //     // Update the state of the app.
            //   },
            // ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   onTap: _onItemTapped,
      //   currentIndex: _currentSelected,
      //   showUnselectedLabels: true,
      //   unselectedItemColor: Colors.grey[800],
      //   selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Drawer',
      //       icon: Icon(Icons.menu),
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) => runFilter(value),
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: ' Search',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            runFilter('');
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear)),

                  //  suffixIcon: searchController.text.isEmpty &&
                  //             searchController.text == ''
                  //         ? const Icon(Icons.search)
                  //         : IconButton(
                  //             onPressed: () {
                  //               searchController.clear();
                  //               runFilter('');
                  //               setState(() {});
                  //             },
                  //             icon: const Icon(
                  //               Icons.clear,
                  //               color: Colors.black,
                  //               // size: 28,
                  //             ),
                  //           ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: foundUsers.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchController.text.isNotEmpty
                        ? foundUsers.length
                        : widget.data.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext itemBuilder, index) {
                      return GestureDetector(
                        onTap: () {
                          _incrementCounter();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => NewOrderPage(
                                        ckey: 0,
                                        uniqueId: _counter,
                                        draftOrderItem: [],
                                        deliveryDate: '',
                                        deliveryTime: '',
                                        paymentMethod: '',
                                        outStanding: foundUsers[index]
                                                ['outstanding']
                                            .toString(),
                                        clientName: foundUsers[index]
                                            ['client_name'],
                                        clientId: foundUsers[index]
                                            ['client_id'],
                                        marketName: foundUsers[index]
                                                ['market_name'] +
                                            '(${foundUsers[index]['area_id']})' +
                                            "," +
                                            foundUsers[index]['address'],
                                      )));
                          setState(() {});
                        },
                        child: CustomerListCardWidget(
                            clientName: foundUsers[index]['client_name'] +
                                '(${foundUsers[index]['client_id']})',
                            base: foundUsers[index]['market_name'] +
                                '(${foundUsers[index]['area_id']})',
                            marketName: foundUsers[index]['address'],
                            outstanding:
                                foundUsers[index]['outstanding'].toString()),
                      );
                    })
                : const Text(
                    'No Data found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }
}
