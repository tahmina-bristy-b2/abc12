class OrderApis {
  static syncClientApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '$syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userpass';
  static syncItemApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '${syncUrl}api_item/item_list?cid=$cid&user_id=$userId&user_pass=$userpass';
}
