class RxApis {
  static syncRxItemApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '${syncUrl}api_medicine/get_rx_medicine?cid=$cid&user_id=$userId&user_pass=$userpass';
}
