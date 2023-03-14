class OrderApis {
  static syncClientApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '$syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userpass';
}
