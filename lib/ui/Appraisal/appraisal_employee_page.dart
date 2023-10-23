import 'package:MREPORTING/ui/Appraisal/appraisal_approval_details.dart';
import 'package:MREPORTING/ui/Appraisal/appraisal_screen.dart';
import 'package:flutter/material.dart';

class ApprovalAppraisal extends StatefulWidget {
  const ApprovalAppraisal({super.key, required this.pageState});
  final String pageState;

  @override
  State<ApprovalAppraisal> createState() => _ApprovalAppraisalState();
}

class _ApprovalAppraisalState extends State<ApprovalAppraisal> {
  final TextEditingController _searchController = TextEditingController();

  bool _searchExpand = false;
  bool _color = false;
  double height = 0.0;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eployee'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _searchExpand = !_searchExpand;
                  _color = true;
                  if (height == 0.0) {
                    height = 40.0;
                  } else {
                    height = 0.0;
                  }
                });
              },
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            // color: Colors.amber,
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: _color
                        ? const Color.fromARGB(255, 138, 201, 149)
                        : Colors.black)),
            height: height,
            child: _searchExpand
                ? TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    controller: _searchController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(bottom: 0, left: 10, top: 5),
                        hintText: 'Eployee name',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search)),
                  )
                : Container(),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (itemBuilder, index) {
                  return Card(
                    child: ListTile(
                        leading: Container(
                          decoration: const ShapeDecoration(
                            shape: CircleBorder(),
                            color: Color.fromARGB(255, 138, 201, 149),
                          ),
                          height: 50,
                          width: 50,
                          child: const Center(child: Text('NA')),
                        ),
                        title: const Text('Md Rahim Mia'),
                        subtitle: const Text('10/05/2023'),
                        trailing: IconButton(
                            onPressed: () {
                              if (widget.pageState == 'Approval') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            AppraisalApprovalDetails()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ApprisalScreen()));
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Color.fromARGB(255, 138, 201, 149),
                            ))
                        // TextButton(
                        //   onPressed: () {},
                        //   child: const Text(
                        //     'Details',
                        //     style: TextStyle(
                        //       color: Color.fromARGB(255, 138, 201, 149),
                        //     ),
                        //   ),
                        // ),
                        ),
                  );
                }),
          ),
        ],
      )),
    );
  }
}
