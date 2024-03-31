class ExpiredApi{
   static syncExpiredItemsApi(
          String syncUrl, String cid, String userId, String userpass) =>'${syncUrl}api_exp_item/item_list?cid=$cid&user_id=$userId&user_pass=$userpass';
      
  // static syncExpiredItemsApi(
  //         String syncUrl, String cid, String userId, String userpass) =>
  //         "http://10.168.27.183:8000/skf_api/api_exp_item/item_list?cid=SKF&user_id=it003&user_pass=1234";


  static orderSubmitApi(String submitUrl) =>
      '$submitUrl/api_exp_item_submit/submit_data';
    // static orderExpiredItemsSubmitApi(String submitUrl) =>
    //   'http://10.168.27.183:8000/skf_api/api_exp_item_submit/submit_data?';


    
      
}