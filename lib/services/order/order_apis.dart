class OrderApis {
  static syncClientApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '$syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userpass';
  static syncItemApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '${syncUrl}api_item/item_list?cid=$cid&user_id=$userId&user_pass=$userpass';

  static lastInvoiceApi(String reportLastInvUrl, String? cid, String? userId,
          String? userPassword, String clientId) =>
      '$reportLastInvUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=$clientId';

  // static lastOrderInvoice(String reportLastOrdUrl, String? cid, String? userId,
  //         String? userPassword, String clientId) =>
  //     '$reportLastOrdUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=$clientId';

  // static outstandingReport(String reportOutstUrl, String? cid, String? userId,
  //         String? userPassword, String clientId) =>
  //     '$reportOutstUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=$clientId';

  static cutomerEditUrlApi(String clientEditUrl, String? cid, String? userId,
          String? userPassword) =>
      '$clientEditUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword';

  static showOutstandingApi(String clientOutstUrl, String? cid, String? userId,
          String? userPassword, String? deviceId, String clientId) =>
      '$clientOutstUrl?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=$clientId';

  static orderSubmitApi(String submitUrl) =>
      '$submitUrl/api_order_submit/submit_data';

  static orderDynamicReportApi(String reportUrl, String? cid, String? userId,
          String? userPassword, String clientId) =>
      '$reportUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=$clientId';
}
