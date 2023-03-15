import 'package:MREPORTING/services/rx/rx_apis.dart';
import 'package:http/http.dart' as http;

class RxDataProviders {
  // Future rxSubmit() async {
  //   var dt = DateFormat('HH:mm:ss').format(DateTime.now());

  //   final http.Response response;
  //   response =
  //       await http.get(Uri.parse('{submit_url!}api_rx_submit/submit_data'));
  // }

//################################ Sync Rx Item  Data ########################
  Future<http.Response> syncRxItemDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(RxApis.syncRxItemApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }
}
