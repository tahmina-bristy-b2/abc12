import 'package:MREPORTING/utils/constant.dart';

class AppraisalApis {
  static employeeApi(
          String syncUrl, String cid, String userId, String usrPass) =>
      '${syncUrl}api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=$usrPass';

  static employeeAppraisaldetails(String url, String cid, String userId,
          String userPass, String levelDepth, String employeeId) =>
      "${url}api_appraisal_skf/get_rep_details?cid=$cid&user_id=$userId&user_pass=$userPass&sup_level_depth_no=$levelDepth&employee_id=$employeeId";

  static employeeAppraisalSubmit(
    String url,
    String cid,
    String userId,
    String userPass,
    String levelDepth,
    String employeeId,
    String honestyIntegrity,
    String discipline,
    String skill,
    String qualitySales,
    String incrementAmount,
    String upgradeGrade,
    String designationChange,
    String feedback,
  ) =>
      "${url}api_appraisal_submit/data_submit?cid=$cid&rep_id=$userId&rep_pass=$userPass&sup_level_depth_no=$levelDepth&employee_id=$employeeId&honesty_and_integrity=$honestyIntegrity&discipline=$discipline&skill=$skill&quality_of_sales=$qualitySales&increment_amount=$incrementAmount&upgrade_grade=$upgradeGrade&designation_change=$designationChange&feedback=$feedback";
  // "https://mreporting-mobileapi.azurewebsites.net/skf_api/api_appraisal_submit/data_submit?cid=skf&rep_id=itfm&rep_pass=1234&employee_id=2761&honesty_and_integrity=3&discipline=4&skill=5&quality_of_sales=4&increment_amount=500&upgrade_grade=1&designation_change=1&feedback=Test";
  // "mreporting-mobileapi.azurewebsites.net/skf_api/api_appraisal_submit/data_submit?cid=skf&rep_id=7585&rep_pass=4613&sup_level_depth_no=2&employee_id=24233&honesty_and_integrity=3&discipline=4&skill=5&quality_of_sales=4&increment_amount=500&upgrade_grade=1&designation_change=1&feedback=Test";
}
