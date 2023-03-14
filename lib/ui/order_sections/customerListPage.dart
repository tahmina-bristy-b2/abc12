import 'package:MREPORTING/services/order/order_services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/order_sections/newOrderPage.dart';
import 'package:MREPORTING/ui/Widgets/customerListWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

class CustomerListScreen extends StatefulWidget {
  final List data;

  const CustomerListScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  Box? box;
  String clientUrl = '';
  String cid = '';
  String userId = '';
  String userPassword = '';
  bool clientFlag = false;
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
      clientUrl = prefs.getString("client_url") ?? '';
      clientFlag = prefs.getBool("client_flag") ?? false;
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

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  //   SharedPreferences.getInstance().then((prefs) {
  //     prefs.setInt('_counter', _counter);
  //   });

  //   setState(() {});
  // }

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
        child: endDrawerListViewBuilderWidget(),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: customerSearchTextFieldWidget(),
            ),
          ),
          Expanded(
            flex: 7,
            child: foundUsers.isNotEmpty
                ? customerListviewbuilder(context)
                : const Text(
                    'No Data found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }

  ListView endDrawerListViewBuilderWidget() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 138, 201, 149)),
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
        clientFlag
            ? Link(
                uri: Uri.parse(
                    '$clientUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                target: LinkTarget.blank,
                builder: (BuildContext ctx, FollowLink? openLink) {
                  return ListTile(
                    onTap: openLink,
                    leading:
                        const Icon(Icons.person_add, color: Colors.blueAccent),
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
      ],
    );
  }

  TextFormField customerSearchTextFieldWidget() {
    return TextFormField(
      /************************************ SEARCH NEW CODE DONE BY BRIISTY ********************************************/
      onChanged: (value) {
        setState(() {
          foundUsers = OrderServices().customerSearchMethod(value, widget.data);
        });
      },
      /************************************ END ******************************************* */

      controller: searchController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: ' Search',
        suffixIcon: searchController.text.isEmpty && searchController.text == ''
            ? const Icon(Icons.search)
            : IconButton(
                onPressed: () {
                  searchController.clear();

                  /************************************ SEARCH NEW CODE DONE BY BRIISTY ******************************************* */
                  foundUsers = OrderServices().customerSearchMethod('', []);
                  setState(() {});
                  /************************************ END ******************************************* */
                },
                icon: const Icon(Icons.clear)),
      ),
    );
  }

  ListView customerListviewbuilder(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: searchController.text.isNotEmpty
            ? foundUsers.length
            : widget.data.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext itemBuilder, index) {
          return GestureDetector(
            onTap: () {
              //*********************************** NEW ADDED DONE BY BRISTY ************************************** */
              setState(() {
                _counter = OrderServices().incrementCounter(_counter);
              });
              //*********************************** END **********************************************************/

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
                            outStanding:
                                foundUsers[index]['outstanding'].toString(),
                            clientName: foundUsers[index]['client_name'],
                            clientId: foundUsers[index]['client_id'],
                            marketName: foundUsers[index]['market_name'] +
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
                outstanding: foundUsers[index]['outstanding'].toString()),
          );
        });
  }
}
