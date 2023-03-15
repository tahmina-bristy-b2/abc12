import 'dart:convert';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/services/rx/rx_data_providers.dart';
import 'package:http/http.dart' as http;

class RxRepositories {
  //################################ Sync Medicine  Data########################
  Future<List> syncRxItem(
      String syncUrl, String cid, String userId, String userpass) async {
    List rxItemList = [];
    try {
      final http.Response response =
          await RxDataProviders().syncRxItemDP(syncUrl, cid, userId, userpass);
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> medicineData = jsonResponse['res_data'];
      rxItemList = medicineData['rxItemList'];
      final status = medicineData['status'];
      if (status == 'Success') {
        await Boxes().openAndAddDataToBox('medicineList', rxItemList);
        return rxItemList;

        // Timer(const Duration(seconds: 3), () => Navigator.pop(context));
      }
    } catch (e) {
      print('doctorList: $e');
    }

    return rxItemList;
  }
}
