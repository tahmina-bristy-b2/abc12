class AppraisalApis {
  static String ipPort = 'http://10.168.27.183:8000';
  static String app = 'skf_api';

  static employeeApi(
          String syncUrl, String cid, String userId, String usrPass) =>
      '${syncUrl}api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=$usrPass';
  // '$ipPort/$app/api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=1234';

  static employeeAppraisaldetails(String url, String cid, String userId,
          String userPass, String levelDepth, String employeeId) =>
      "${url}api_appraisal_skf/get_rep_details?cid=$cid&user_id=$userId&user_pass=$userPass&sup_level_depth_no=$levelDepth&employee_id=$employeeId";
  // "$ipPort/$app/api_appraisal_skf/get_rep_details?cid=$cid&user_id=$userId&user_pass=1234&sup_level_depth_no=$levelDepth&employee_id=$employeeId";

  static employeeAppraisalSubmit(
          String url,
          String cid,
          String userId,
          String userPass,
          String levelDepth,
          String employeeId,
          List kpiValus,
          String incrementAmount,
          String upgradeGrade,
          String designationChange,
          String feedback,
          String kpiKey) =>
      "${url}api_appraisal_submit/data_submit?cid=$cid&rep_id=$userId&rep_pass=$userPass&sup_level_depth_no=$levelDepth&employee_id=$employeeId&increment_amount=$incrementAmount&upgrade_grade=$upgradeGrade&designation_change=$designationChange&feedback=$feedback&kpi_key=$kpiKey";
  // "$ipPort/$app/api_appraisal_submit/data_submit?cid=$cid&rep_id=$userId&rep_pass=1234&sup_level_depth_no=$levelDepth&employee_id=$employeeId&increment_amount=$incrementAmount&upgrade_grade=$upgradeGrade&designation_change=$designationChange&feedback=$feedback&kpi_key=$kpiKey";
  // "$ipPort/$app/api_appraisal_submit/data_submit?cid=$cid&rep_id=$userId&rep_pass=1234&sup_level_depth_no=$levelDepth&employee_id=$employeeId&increment_amount=$incrementAmount&upgrade_grade=$upgradeGrade&designation_change=$designationChange&feedback=$feedback&kpi_key=$kpiKey&app_acction_button=SUBMITTED";
  static ffApi(String syncUrl, String cid, String userId, String usrPass) =>
      '${syncUrl}api_appraisal_approve/sup_home?cid=$cid&user_id=$userId&user_pass=$usrPass';
  // '$ipPort/$app/api_appraisal_approve/sup_home?cid=$cid&user_id=$userId&user_pass=1234';

  static ffDetailsApi(String syncUrl, String cid, String userId, String usrPass,
          String restParams) =>
      '${syncUrl}api_appraisal_approve/appraisal_details?cid=$cid&user_id=$userId&user_pass=$usrPass&$restParams';
  // 'http://10.168.27.183:8000/skf_api/api_appraisal_approve/appraisal_details?cid=$cid&user_id=$userId&user_pass=1234&$restParams';

  static ffapprovalSubmitApi(String syncUrl, String cid, String userId,
          String usrPass, String restParams) =>
      '${syncUrl}api_appraisal_approve/app_approval?cid=$cid&user_id=$userId&user_pass=$usrPass&$restParams';
  // 'http://10.168.27.183:8000/skf_api/api_appraisal_approve/app_approval?cid=$cid&user_id=$userId&user_pass=1234&$restParams';

  static appraisalSelfAssesment(
    String syncUrl,
    String cid,
    String userId,
    String userPass,
  ) =>
      "${syncUrl}/api_appraisal_submit/self_appraisal_details?cid=$cid&rep_id=$userId&rep_pass=$userPass";
}
