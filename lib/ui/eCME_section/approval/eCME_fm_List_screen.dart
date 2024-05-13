import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/e_CME_ff_list_data_model_approval.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING/ui/eCME_section/approval/eCME_approval_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EcmeFFListApproval extends StatefulWidget {
  const EcmeFFListApproval({super.key, required this.cid, required this.userPass});
  final String cid;
  final String userPass;
  @override
  State<EcmeFFListApproval> createState() => _EcmeFFListApprovalState();
}

class _EcmeFFListApprovalState extends State<EcmeFFListApproval> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  ECMEffListDataModel? eCMEDataModel;

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
        title: const Text('e-CME FF List'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading
            ? dataLoadingView()
            : eCMEDataModel == null || eCMEDataModel!.resData.dataList!.isEmpty
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
         
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      constraints:
                          const BoxConstraints(maxHeight: double.infinity),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:const Color.fromARGB(255, 168, 196, 194),
                        // color: const Color.fromARGB(255, 98, 158, 219),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            SizedBox(
                                width: 150,
                                child: Text('MSO',
                                    style: TextStyle(color: Colors.black))),
                            SizedBox(
                                width: 100,
                                child: Text('Area Id',
                                    style: TextStyle(color: Colors.black))),
                            SizedBox(
                                width: 60,
                                child: Center(
                                    child: Text('Due',
                                        style:
                                            TextStyle(color: Colors.black)))),
                            
                            SizedBox(
                                width: 60,
                                child: Center(
                                    child: Text('Action',
                                        style:
                                            TextStyle(color: Colors.black)))),
                            
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .75,
                      width: 390,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: eCMEDataModel!.resData.dataList!.length,
                          itemBuilder: (itemBuilder, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              constraints: const BoxConstraints(
                                  maxHeight: double.infinity,
                                  maxWidth: double.infinity),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: index % 2 != 0
                                    ? Colors.grey[300]
                                    : Colors.white,
                              ),
                             
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EcmeApprovalScreen(
                                          cid: widget.cid,
                                          userPass: widget.userPass,
                                          levelDepth:
                                              eCMEDataModel!.resData.levelDepth,
                                          submittedBy: eCMEDataModel!.resData
                                              .dataList![index].submitBy,
                                          areaId: eCMEDataModel!.resData
                                              .dataList![index].areaId,
                                          calledBackAction: (value) {
                                            getEdsrFm();
                                          }),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 150,
                                        child: Text(eCMEDataModel!.resData
                                            .dataList![index].submitBy)),
                                    SizedBox(
                                        width: 100,
                                        child: Text(eCMEDataModel!.resData
                                            .dataList![index].areaId)),
                                    SizedBox(
                                        width: 60,
                                        child: Center(
                                            child: Text(eCMEDataModel!.resData
                                                .dataList![index].dueCount))),
                                   
                                    const SizedBox(
                                      width: 60,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
    eCMEDataModel = await ECMERepositry().getECMEFFListData(
        dmpathData!.syncUrl, widget.cid, userInfo!.userId, widget.userPass);
        print("Data $eCMEDataModel");

    if (eCMEDataModel != null) {
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
