import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/loginPage.dart';
import 'package:MREPORTING/ui/order_sections/newOrderPage.dart';

import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/local_storage/boxes.dart';

class DraftOrderPage extends StatefulWidget {
  const DraftOrderPage({Key? key}) : super(key: key);

  @override
  State<DraftOrderPage> createState() => _DraftOrderPageState();
}

class _DraftOrderPageState extends State<DraftOrderPage> {
  Box? box;
  double total = 0;
  List itemDraftList = [];
  List<AddItemModel> finalItemDataList = [];
  List<AddItemModel> filteredOrder = [];
  List<CustomerDataModel> customerItemDataList = [];

  @override
  void initState() {
    box = Boxes.getDraftOrderedData();
    finalItemDataList = box!.toMap().values.toList().cast<AddItemModel>();
    finalItemDataList.forEach(
      (element) {
        // print(element.item_name);
      },
    );

    box = Boxes.getCustomerUsers();
    customerItemDataList =
        box!.toMap().values.toList().cast<CustomerDataModel>();

    super.initState();
  }

  double totalCount(index) {
    double subtotal = index['tp'] * index['quantity'];
    double newVat = index['vat'] / 100;
    double total1 = subtotal * newVat;
    total = total1 + subtotal;

    return total;
  }

  int _currentSelected = 0;

  Future<void> deleteClient(CustomerDataModel customerModel) async {
    customerModel.delete();
  }

  deleteOrderItem(String id) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.item_id == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: const Text('Draft Order'),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.getCustomerUsers().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final orderCustomers =
                box.values.toList().cast<CustomerDataModel>();

            return genContent(orderCustomers);
          },
        ),
      ),
    );
  }

  Widget genContent(List<CustomerDataModel> user) {
    if (user.isEmpty) {
      return const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: Card(
              color: Colors.white,
              child: ExpansionTile(
                title: Text(
                  "${user[index].clientName} (${user[index].marketName}) ",
                  maxLines: 2,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 30, 66, 77), fontSize: 18),
                ),
                subtitle: Text(
                  "${user[index].clientId}  ${user[index].deliveryDate}   ${user[index].deliveryTime} ",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 30, 66, 77),
                  ),
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          final ckey = user[index].clientId;
                          deleteClient(user[index]);

                          deleteOrderItem(ckey);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          final ckey = user[index].clientId;
                          filteredOrder = [];
                          finalItemDataList
                              .where((item) => item.item_id == ckey)
                              .forEach((item) {
                            final temp = AddItemModel(
                              quantity: item.quantity,
                              item_name: item.item_name,
                              tp: item.tp,
                              item_id: item.item_id,
                              category_id: item.category_id,
                              vat: item.vat,
                              manufacturer: item.manufacturer,
                            );
                            filteredOrder.add(temp);
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewOrderPage(
                                //ckey: ckey,
                                draftOrderItem: user[index].itemList,
                                outStanding: user[index].outstanding,
                                deliveryDate: user[index].deliveryDate,
                                deliveryTime: user[index].deliveryTime,
                                paymentMethod: user[index].paymentMethod,
                                offer: user[index].offer,
                                note: user[index].note,
                                clientName: user[index].clientName,
                                clientId: user[index].clientId,
                                marketName: user[index].marketName,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          "Details",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
