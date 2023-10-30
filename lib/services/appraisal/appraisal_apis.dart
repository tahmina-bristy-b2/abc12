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

  static ffApi(String syncUrl, String cid, String userId, String usrPass) =>
      '${syncUrl}api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=$usrPass';

  static ffDetailsApi(
          String syncUrl, String cid, String userId, String usrPass) =>
      '${syncUrl}api_appraisal_skf/get_area_rep?cid=$cid&user_id=$userId&user_pass=$usrPass';
}
