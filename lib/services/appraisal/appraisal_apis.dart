class AppraisalApis {
  static employeeApi(
          String syncUrl, String cid, String userId, String usrPass) =>
      '${syncUrl}api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=$usrPass';
  static employeeAppraisaldetails(String url, String cid, String userId,
          String userPass, String levelDepth, String employeeId) =>
      "mreporting-mobileapi.azurewebsites.net/skf_api/api_appraisal_skf/get_rep_details?cid=SKF&user_id=7585&user_pass=4613&sup_level_depth_no=2&employee_id=24233";

  static ffApi(String syncUrl, String cid, String userId, String usrPass) =>
      '${syncUrl}api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=$usrPass';
}
