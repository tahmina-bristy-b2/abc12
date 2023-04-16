// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class NoticeScreen extends StatefulWidget {
  List noticelist;
  NoticeScreen({
    Key? key,
    required this.noticelist,
  }) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  var noticeDate;
  @override
  void initState() {
    // for (var e in widget.noticelist) {
    //   String first = e["notice_date"].replaceAll(" ", "\n");
    //   print(first);
    // }
    // noticeDate = widget.noticelist[index]["notice_date"].replaceAll(" ", "\n");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.noticelist.length,
                itemBuilder: (context, index) {
                  // noticeDate = widget.noticelist[index]["notice_date"]
                  //     .replaceAll(" ", "\n\n");
                  var str = widget.noticelist[index]["notice_date"];
                  var parts = str.split(' ');
                  var prefix = parts[0].trim();
                  var prefixTime = parts[1].trim();
                  var prefixSplit = prefix.split("-");
                  var lastPart = prefixSplit[2];
                  var secPart = prefixSplit[1];
                  var firstPart = prefixSplit[0];
                  // print(prefixSplit[2]);

                  // prefix: "date"
                  // var date =
                  //     parts.sublist(1).join(':').trim(); // date: "'2019:04:01'"
                  return Card(
                    elevation: 6,
                    child: Container(
                      color: const Color.fromARGB(255, 189, 247, 237),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 8, 0, 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color.fromARGB(255, 241, 52, 38),
                                    Color.fromARGB(255, 209, 143, 44),
                                  ],
                                  // colors: [
                                  //   Color.fromARGB(255, 189, 247, 237),
                                  //   Color.fromARGB(255, 212, 245, 190)
                                  // ],
                                ),
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 8, 0, 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lastPart,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          secPart,
                                          // + "," + firstPart
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          firstPart,
                                          // + "," + firstPart
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prefixTime,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    widget.noticelist[index]["notice"],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
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
}
