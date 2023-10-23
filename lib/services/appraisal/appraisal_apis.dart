class AppraisalApis {
  static employeeApi(String cid, String userId, String usrPass) =>
      'http://127.0.0.1:8000/skf_api/api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=$usrPass';
}
