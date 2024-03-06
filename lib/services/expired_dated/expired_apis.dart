class ExpiredApi{
  //  static syncExpiredItemsApiLocal(
  //         String syncUrl, String cid, String userId, String userpass) =>'${syncUrl}api_item/item_list?cid=$cid&user_id=$userId&user_pass=$userpass';
      
  static syncExpiredItemsApi(
          String syncUrl, String cid, String userId, String userpass) =>
          "http://10.168.27.183:8000/skf_api/api_exp_item/item_list?cid=SKF&user_id=it003&user_pass=1234";
          //'http://10.168.27.183:8000/skf_api/api_exp_item/item_list?cid=SKF&user_id=it003&user_pass=1234';
      
}