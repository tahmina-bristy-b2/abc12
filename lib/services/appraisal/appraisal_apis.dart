class AppraisalApis {
  static employeeApi(
          String syncUrl, String cid, String userId, String usrPass) =>
      '${syncUrl}api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=$usrPass';
}
