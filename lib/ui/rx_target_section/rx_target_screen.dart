import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:flutter/material.dart';

class RxTargetScreen extends StatefulWidget {
  final List syncDoctorList;
  const RxTargetScreen({super.key,required this.syncDoctorList});

  @override
  State<RxTargetScreen> createState() => _RxTargetScreenState();
}

class _RxTargetScreenState extends State<RxTargetScreen> {

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

    foundUsers = widget.syncDoctorList;
    for (var element in foundUsers) {
      controllers[element['doc_id']] = TextEditingController();
    }
    // for (var element in widget.tempList) {
    //   controllers.forEach((key, value) {
    //     if (key == element.item_id) {
    //       value.text = element.quantity.toString();
    //     }
    //   });
    // }

    // for (var element in widget.tempList) {
    //   total = (element.tp + element.vat) * element.quantity;

    //   orderamount = orderamount + total;
    // }

    super.initState();
  }

  @override
  void dispose() {
    for (var element in foundUsers) {
      controllers[element['doc_id']]!.dispose();
    }

    searchController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
      title: const Text('RX Target'),
      titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 27, 56, 34),
          fontWeight: FontWeight.w500,
          fontSize: 20),
      centerTitle: true,
      ),

     
        body: Column(
          children: [
            itemSearchTextFormWidget(),
            //Expanded(child: itemSearchTextFormWidget()),
            itemListViewBuilderWIdget(),
            const SizedBox(
              height: 5,
            ),
           // addtoCartButtonWidget(context)
          ],
        ),
  

    );
  }


  //==================================================== doctor seacrch===================================
   SizedBox itemSearchTextFormWidget() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  foundUsers = AllServices().searchDynamicMethod(
                      value, widget.syncDoctorList, 'doc_name');
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                 // fillColor: Colors.white,
                  fillColor: Colors.teal.shade50,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: 'Search doctor by name....',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            foundUsers = AllServices().searchDynamicMethod(
                                '', widget.syncDoctorList, 'doc_name');
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Color.fromARGB(255, 239, 242, 239),
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
                  return Column(
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                   Opacity(
                                opacity: 0.7,
                                child: Container(
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    // color: Color.fromARGB(255, 138, 201, 149),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/doctor.png',
                                      ), 
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // crossAxisAlignment: ,
                                      children: [
                                        Text(
                                          "${foundUsers[index]['doc_name']}",
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 8, 18, 20),
                                              fontSize: 16),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${foundUsers[index]['area_name']}${foundUsers[index]['area_id']}|${foundUsers[index]['address']} ',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(255, 86, 84, 84),
                                                  fontSize: 12),
                                            ),
                                          
                                          ],
                                        ),
                                       
                                      ],
                                    ),
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
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                   
                                    child: Container(
                                      
                                      color:
                                          const Color.fromARGB(255, 138, 201, 149)
                                              .withOpacity(.3),
                                      width: 60,
                                      child: TextFormField(
                                        textDirection: TextDirection.ltr,
                                       
                                        textAlign: TextAlign.center,
                                        controller: controllers[foundUsers[index]
                                            ['doc_id']],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                         
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(color: Colors.grey,
                      height: 0.7,)
                    ],
                  );
                })
            : const Text(
                'No Data found',
                style: TextStyle(fontSize: 24),
              ),
      ),
    );
  }

}