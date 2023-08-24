import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_FM_list_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/ui/eDSR_section/approve_eDSR.dart';
import 'package:flutter/material.dart';

class EdsrFmList extends StatefulWidget {
  const EdsrFmList({super.key, required this.cid, required this.userPass});
  final String cid;
  final String userPass;
  @override
  State<EdsrFmList> createState() => _EdsrFmListState();
}

class _EdsrFmListState extends State<EdsrFmList> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  EdsrFmListModel? edsrFmList;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getEdsrFm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eDSR FM List'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : edsrFmList!.resData.dataList!.isEmpty
              ? const Center(
                  child: Text("No Data Found!"),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          constraints:
                              const BoxConstraints(maxHeight: double.infinity),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.blue[900]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Budget :',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        edsrFmList!.resData.budget,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const VerticalDivider(
                                  color: Colors.white,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Expense :',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        edsrFmList!.resData.expense,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints:
                              const BoxConstraints(maxHeight: double.infinity),
                          // color: Colors.blue[900],
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blue[900]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Expanded(
                                    child: Text('FM',
                                        style: TextStyle(color: Colors.white))),
                                Expanded(
                                    child: Text('Territory',
                                        style: TextStyle(color: Colors.white))),
                                Expanded(
                                    child: Center(
                                        child: Text('Due',
                                            style: TextStyle(
                                                color: Colors.white)))),
                                Expanded(
                                    child: Center(
                                        child: Text('Doctor',
                                            style: TextStyle(
                                                color: Colors.white)))),
                                Expanded(
                                    child: Center(
                                        child: Text('Dcc',
                                            style: TextStyle(
                                                color: Colors.white)))),
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text('Amount',
                                            style: TextStyle(
                                                color: Colors.white)))),
                                Expanded(
                                    child: Center(
                                        child: Text('Action',
                                            style: TextStyle(
                                                color: Colors.white)))),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: edsrFmList!.resData.dataList!.length,
                              itemBuilder: (itemBuilder, index) {
                                return Container(
                                  constraints: const BoxConstraints(
                                      maxHeight: double.infinity),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: index % 2 != 0
                                        ? Colors.grey[300]
                                        : Colors.white,
                                  ),
                                  // color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ApproveEDSR(
                                              cid: widget.cid,
                                              userPass: widget.userPass,
                                              submittedBy: edsrFmList!.resData
                                                  .dataList![index].submitBy,
                                              territoryId: edsrFmList!.resData
                                                  .dataList![index].territoryId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(edsrFmList!.resData
                                                  .dataList![index].submitBy)),
                                          Expanded(
                                              child: Text(edsrFmList!
                                                  .resData
                                                  .dataList![index]
                                                  .territoryId)),
                                          Expanded(
                                              child: Center(
                                                  child: Text(edsrFmList!
                                                      .resData
                                                      .dataList![index]
                                                      .dueCount))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(edsrFmList!
                                                      .resData
                                                      .dataList![index]
                                                      .countDoctor))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(edsrFmList!
                                                      .resData
                                                      .dataList![index]
                                                      .countDcc))),
                                          Expanded(
                                              flex: 2,
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(edsrFmList!
                                                      .resData
                                                      .dataList![index]
                                                      .amount))),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }

  getEdsrFm() async {
    edsrFmList = await eDSRRepository()
        .getEdsrFmlist("", widget.cid, userInfo!.userId, widget.userPass);

    if (edsrFmList != null) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
