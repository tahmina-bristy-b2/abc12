class Apis {
  static dmpath(String cid) =>
      'http://w03.yeapps.com/dmpath/dmpath_230503/get_dmpath?cid=$cid'; //v04
  // static dmpath(String cid) =>
  //     'http://w03.yeapps.com/dmpath/dmpath_test/get_dmpath?cid=$cid';//v03

  static attendanceApi(attendanceUrl, params) =>
      "${attendanceUrl}api_attendance_submit/submit_data?$params";

  static areaApi(areaUrl, params) => "$areaUrl?$params";

  static areaBaseClientApi(areaClientUrl, params) =>
      "$areaClientUrl/api_client/client_list?$params";

  static areaBaseDoctorApi(areaDoctorUrl, params) =>
      "$areaDoctorUrl/api_doctor/get_doctor?$params";

  static getTargerAch(tarAchUrl, params) => "$tarAchUrl?$params";

  static expenseEntryApi(expType, params) => "$expType?$params";

  static promoApi(
          String promoUrl, String cid, String userId, String uesrpass) =>
      "$promoUrl?cid=$cid&user_id=$userId&user_pass=$uesrpass"; //Promo Api

  static stockApi(String stockUrl, String cid, String userId, String uesrpass,
          String depotId) =>
      "$stockUrl?cid=$cid&user_id=$userId&user_pass=$uesrpass&depot_id=$depotId "; //Stock Api

  static approvedApi(String approvedUrl, String cid, String userId,
          String uesrpass, String clientId) =>
      "$approvedUrl?cid=$cid&user_id=$userId&user_pass=$uesrpass&client_id=$clientId"; //Approved Api

  static userDepotApi(String userDepotUrl, String? cid, String? userId,
          String? userPassword) =>
      '$userDepotUrl?cid=$cid&user_id=$userId&user_pass=$userPassword'; //user Depor Api for stock
}
