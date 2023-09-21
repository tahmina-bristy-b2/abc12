import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_FM_list_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/ui/eDSR_section/approval_eDSR.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
      body: SafeArea(
        child: isLoading
            ? dataLoadingView()
            : edsrFmList == null || edsrFmList!.resData.dataList!.isEmpty
                ? Center(
                    child: Stack(children: [
                      Image.asset(
                        'assets/images/no_data_found.png',
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width / 2.5,
                        bottom: MediaQuery.of(context).size.height * .005,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF0F0F0),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Go back',
                              style: TextStyle(color: Colors.black54),
                            )),
                      )
                    ]),
                  )
                : dataLoadedView(context),
      ),
    );
  }

  Padding dataLoadedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: double.infinity),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              // color: Colors.blue[900]
              color: const Color.fromARGB(255, 98, 158, 219),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Budget :',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          edsrFmList!.resData.budget,
                          style: const TextStyle(color: Colors.white),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Expense :',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          edsrFmList!.resData.expense,
                          style: const TextStyle(color: Colors.white),
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
            constraints: const BoxConstraints(maxHeight: double.infinity),
            // color: Colors.blue[900],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 98, 158, 219),
              // color: Colors.blue[900],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Expanded(
                      flex: 2,
                      child: Text('FM', style: TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text('Territory',
                          style: TextStyle(color: Colors.white))),
                  Expanded(
                      child: Center(
                          child: Text('Due',
                              style: TextStyle(color: Colors.white)))),
                  Expanded(
                      child: Center(
                          child: Text('Doctor',
                              style: TextStyle(color: Colors.white)))),
                  Expanded(
                      child: Center(
                          child: Text('Dcc',
                              style: TextStyle(color: Colors.white)))),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text('Amount',
                              style: TextStyle(color: Colors.white)))),
                  Expanded(
                      child: Center(
                          child: Text('Action',
                              style: TextStyle(color: Colors.white)))),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: edsrFmList!.resData.dataList!.length,
                itemBuilder: (itemBuilder, index) {
                  return Container(
                    constraints:
                        const BoxConstraints(maxHeight: double.infinity),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: index % 2 != 0 ? Colors.grey[300] : Colors.white,
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
                                  levelDepth: edsrFmList!.resData.levelDepth,
                                  submittedBy: edsrFmList!
                                      .resData.dataList![index].submitBy,
                                  territoryId: edsrFmList!
                                      .resData.dataList![index].territoryId,
                                  calledBackAction: (value) {
                                    getEdsrFm();
                                  }),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(edsrFmList!
                                    .resData.dataList![index].submitBy)),
                            Expanded(
                                child: Text(edsrFmList!
                                    .resData.dataList![index].territoryId)),
                            Expanded(
                                child: Center(
                                    child: Text(edsrFmList!
                                        .resData.dataList![index].dueCount))),
                            Expanded(
                                child: Center(
                                    child: Text(edsrFmList!.resData
                                        .dataList![index].countDoctor))),
                            Expanded(
                                child: Center(
                                    child: Text(edsrFmList!
                                        .resData.dataList![index].countDcc))),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(edsrFmList!
                                        .resData.dataList![index].amount))),
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
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
    );
  }

  Padding dataLoadingView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white38,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey[300],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white38,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey[300],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 15,
                itemBuilder: (itemBuilder, index) {
                  return Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.white38,
                        child: Container(
                          constraints:
                              const BoxConstraints(maxHeight: double.infinity),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.grey[300],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  getEdsrFm() async {
    edsrFmList = await EDSRRepositories().getEdsrFmlist(
        dmpathData!.syncUrl, widget.cid, userInfo!.userId, widget.userPass);

    if (edsrFmList != null) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }
}
