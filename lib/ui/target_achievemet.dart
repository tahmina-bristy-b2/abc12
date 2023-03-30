import 'package:flutter/material.dart';

class TargetAchievement extends StatefulWidget {
  List tarAchievementList;

  TargetAchievement({Key? key, required this.tarAchievementList})
      : super(key: key);

  @override
  State<TargetAchievement> createState() => _TargetAchievementState();
}

class _TargetAchievementState extends State<TargetAchievement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Achievement'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              // flex: 8,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.tarAchievementList.length,
                  itemBuilder: (builder, index) {
                    return Card(
                      elevation: 10,
                      color: const Color.fromARGB(255, 217, 224, 250),
                      shadowColor: const Color(0xff70BA85),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white70, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black54, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: const Color.fromARGB(255, 194, 235, 147),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 8, 0, 8),
                                        child: Text(
                                            'GRP : ${widget.tarAchievementList[index]['GRP']}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                          'ID :  ${widget.tarAchievementList[index]['FP_ID']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    // const SizedBox(
                                    //   width: 20,
                                    // ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 8, 0, 8),
                                        child: Text(
                                            'BS_CD : ${widget.tarAchievementList[index]['BS_CD']}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                // color: Color.fromARGB(255, 208, 189, 224),
                                color: const Color.fromARGB(255, 183, 206, 233),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 8, 0, 8),
                                        child: Text('',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 8, 0, 8),
                                        child: Text('Target:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 8, 0, 8),
                                        child: Text(
                                            widget.tarAchievementList[index]
                                                    ['TARGET']
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: const Color.fromARGB(255, 165, 197, 243),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 8, 0, 8),
                                        child: Text('',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 8, 0, 8),
                                        child: Text('Sales :',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 8, 0, 8),
                                        child: Text(
                                            widget.tarAchievementList[index]
                                                    ['SALES']
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: const Color.fromARGB(255, 183, 206, 233),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text('',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    const Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 8, 0, 8),
                                        child: Text('Sales Achievement :',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 8, 0, 8),
                                        child: Text(
                                            widget.tarAchievementList[index]
                                                        ['SALES_ACHV']
                                                    .toString() +
                                                ' % '.toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: const Color.fromARGB(255, 165, 197, 243),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 8, 0, 8),
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 8, 0, 8),
                                        child: Text('      Collection   : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 8, 0, 8),
                                        child: Text(
                                            widget.tarAchievementList[index]
                                                    ['COLLECTION']
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: const Color.fromARGB(255, 183, 206, 233),
                                child: Row(
                                  children: [
                                    const Text('',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500)),
                                    const Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(4, 8, 0, 8),
                                        child: Text(
                                            '   Collection Achievement   :',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 8, 0, 8),
                                        child: Text(
                                            '${widget.tarAchievementList[index]['COLL_ACHV']} % ',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
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
      )),
    );
  }
}
