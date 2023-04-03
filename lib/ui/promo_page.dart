import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/models/promo_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/others/repositories.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key, required this.cid, required this.userPassword});
  final String cid;
  final String userPassword;

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  String cid = '';
  String userPassword = '';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Promo'),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onTap(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.refresh), label: 'Refresh'),
          ],
        ),
        body: FutureBuilder<PromoModel?>(
          future: Repositories().getPromo(dmpathData!.reportPromoUrl,
              widget.cid, userInfo!.userId, widget.userPassword),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                AllServices().toastMessage(
                    'Data Not found!', Colors.red, Colors.white, 16);
                return const Text('');
              } else if (snapshot.data!.promoList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: DataTable2(
                    border: TableBorder.all(),
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue.shade200),
                    dataRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.teal.shade50),
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns: dataColumn(),
                    rows: dataRow(snapshot.data!),
                  ),
                );
              }
            }
            return const Text('Data Not found!',
                style: TextStyle(fontSize: 16));
          },
        ));
  }

  _onTap(index) {
    if (index == 0) {
      Navigator.pop(context);
      currentIndex = index;
      setState(() {});
    }

    if (index == 1) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  List<DataColumn> dataColumn() {
    return const [
      DataColumn2(
        fixedWidth: 310,
        label: Center(
          child: Text(
            'Offer',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: 60,
        label: Text(
          'MinQty',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> dataRow(PromoModel promoData) {
    return promoData.promoList
        .map((e) => DataRow(cells: [
              DataCell(Text(e.promoDes)),
              DataCell(Text(e.minQty.toString()))
            ]))
        .toList();
  }
}
