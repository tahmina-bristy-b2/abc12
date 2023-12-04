import 'package:MREPORTING/services/order/order_services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  final customerBox = Boxes.getCustomerUsers();
  final draftOrderData = Boxes.getDraftOrderedData();
  List<AddItemModel> finalItemDataList = [];

  @override
  void initState() {
    finalItemDataList =
        draftOrderData.toMap().values.toList().cast<AddItemModel>();

    super.initState();
  }

  //int _currentSelected = 0;

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
          valueListenable: customerBox.listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final orderCustomers =
                customerBox.values.toList().cast<CustomerDataModel>();

            return genContent(orderCustomers);
          },
        ),
      ),
    );
  }

//=============================================widget===============================================================
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
            child: Card(
              color: Colors.white,
              child: ExpansionTile(
                title: Text(
                  "${user[index].clientName} (${user[index].clientId}) ",
                  maxLines: 2,
                  // style: const TextStyle(
                  //     color: Color.fromARGB(255, 30, 66, 77), fontSize: 18),
                ),
                subtitle: Text(
                  "${user[index].marketName} ${user[index].deliveryDate} ${user[index].deliveryTime}",
                  // style: const TextStyle(
                  //   color: Color.fromARGB(255, 30, 66, 77),
                  // ),
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          OrderServices().deleteEachClient(customerBox,
                              finalItemDataList, user[index].clientId);
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
                          OrderServices().showDetailsDraftItem(
                              finalItemDataList, user, index);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewOrderPage(
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
