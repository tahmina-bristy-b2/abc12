import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/order/order_services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING_OFFLINE/ui/order_sections/newOrderPage.dart';
import 'package:MREPORTING_OFFLINE/ui/Widgets/customerListWidget.dart';
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
  UserLoginModel? userLoginInfo;
  DmPathDataModel? dmPathData;
  String cid = '';
  String userId = '';
  String userPassword = '';
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmPathData = Boxes.getDmpath().get('dmPathData');

    SharedPreferences.getInstance().then((prefs) {
      cid = prefs.getString("CID")!;
      userId = prefs.getString("USER_ID")!;
      userPassword = prefs.getString("PASSWORD")!;
    });

    foundUsers = widget.data;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
            // color: Colors.white,
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
          SizedBox(
            height: 60,
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

//************************************ WIDGETS **********************************************************/
//*******************************************************************************************************/
//*******************************************************************************************************/
  ListView endDrawerListViewBuilderWidget() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 138, 201, 149)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/logo-black.png'),
              ),
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
        userLoginInfo!.clientFlag ? clientWebLink() : Container()
      ],
    );
  }

  Link clientWebLink() {
    return Link(
        uri: Uri.parse(
            '${dmPathData!.clientUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
        target: LinkTarget.blank,
        builder: (BuildContext ctx, FollowLink? openLink) {
          return ListTile(
            onTap: openLink,
            leading: const Icon(Icons.person_add, color: Colors.blueAccent),
            title: const Text(
              'Customer',
              style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 15, 53, 85)),
            ),
          );
        });
  }

  TextFormField customerSearchTextFieldWidget() {
    return TextFormField(
      /************************************ SEARCH NEW CODE DONE BY BRIISTY ********************************************/
      onChanged: (value) {
        setState(() {
          foundUsers = AllServices()
              .searchDynamicMethod(value, widget.data, 'client_name');
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
                  foundUsers = AllServices()
                      .searchDynamicMethod('', widget.data, 'client_name');
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
              setState(() {
                _counter = OrderServices().incrementCounter(_counter);
              });

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => NewOrderPage(
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
                            note: '',
                          )));
              setState(() {});
            },
            child: CustomerListCardWidget(
              clientName: foundUsers[index]['client_name'] +
                  '(${foundUsers[index]['client_id']})',
              base: foundUsers[index]['market_name'] +
                  '(${foundUsers[index]['area_id']})',
              marketName: foundUsers[index]['address'],
              outstanding: foundUsers[index]['outstanding'].toString(),
              icon: const Icon(null),
              boolIcon: false,
              onPressed: () {},
            ),
          );
        });
  }
}
