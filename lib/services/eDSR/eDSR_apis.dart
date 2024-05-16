class EDSRApis {
  String getDoctor(String doctorUrl, String cid, String userId, String userPass,
          String regionId, String areaId, String terroId, String dsrType) =>
      "${doctorUrl}api_dsr_settings/get_area_doctor?cid=$cid&user_id=$userId&user_pass=$userPass&region_id=$regionId&area_id=$areaId&territory_id=$terroId&dsr_type=$dsrType";

  String getEDsrSettingApi(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
  ) =>
      "${eDsrSettingsUrl}api_dsr_settings/dsr_setting?cid=$cid&user_id=$userId&user_pass=$userPass";

//=============================== eDSR Approval Section =================================
  static String eDSRfmListApi(
          String fmListUrl, String cid, String userId, String userPass) =>
      "${fmListUrl}api_dsr_approve/sup_home?cid=$cid&user_id=$userId&user_pass=$userPass";

  static String dsrDetailsApi(
          String dsrDetailsApi,
          String cid,
          String userId,
          String userPass,
          String submitedBy,
          String territoryId,
          String levelDepth) =>
      "${dsrDetailsApi}api_dsr_approve/dsr_details?cid=$cid&user_id=$userId&user_pass=$userPass&submit_by=$submitedBy&territory_id=$territoryId&level_depth_no=$levelDepth";

  static String brandAmountUpdate(String brandAmountUpdateUrl, String cid,
          String userId, String userPass, String brandAmountUpdateParams) =>
      "${brandAmountUpdateUrl}api_dsr_approve/brand_amount_update?cid=$cid&user_id=$userId&user_pass=$userPass&$brandAmountUpdateParams";

  static String approveEDSR(String approveEDSRUrl, String cid, String userId,
          String userPass, String approvedEdsrParams) =>
      "${approveEDSRUrl}api_dsr_approve/dsr_approval?cid=$cid&user_id=$userId&user_pass=$userPass&$approvedEdsrParams";
      

  String eDsrAddApi(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
    // String syncCode,
    // String brandStr,
    // String areaId,
    // String doctorId,
    // String doctorName,
    // String doctorCategory,
    // String latitude,
    // String longitude,
    // String dsrType,
    // String dsrCat,
    // String purpose,
    // String purposeSub,
    // String pDes,
    // String pDtFrom,
    // String pDtTo,
    // String noOfPatient,
    // String payFrom,
    // String payTo,
    // String schedule,
    // String payNMonth,
    // String payMode,
    // String chequeTo,
    // String rsmCash,
    // String issueTo,
  ) =>
      "${eDsrSettingsUrl}api_dsr_submit/data_submit?cid=$cid&rep_id=$userId&rep_pass=$userPass";
  // &synccode=$syncCode&brand_Str=$brandStr&areaId=$areaId&doctor_id=$doctorId&doctor_name=$doctorName&doctor_category=$doctorCategory&latitude=$latitude&longitude=$longitude&dsr_type=$dsrType&dsr_cat=$dsrCat&purpose=$purpose&purpose_sub=$purposeSub&p_des=$pDes&p_dt_from=$pDtFrom&p_dt_to=$pDtTo&no_of_patient=$noOfPatient&pay_from=$payFrom&pay_to=$payTo&schedule=$schedule&pay_n_month=$payNMonth&pay_mode=$payMode&cheque_to=$chequeTo&rsm_cash=$rsmCash&pay_mode_bill_to=$issueTo
  // ";

  static String mobileUpdateApi(
          String approveEDSRUrl,
          String cid,
          String userId,
          String userPass,
          String doctorId,
          String dsrType,
          String upMobileNumber,
          String areaId) =>
      "${approveEDSRUrl}api_dsr_approve/doc_mobile_update?cid=$cid&user_id=$userId&user_pass=$userPass&up_mobile=$upMobileNumber&area_id=$areaId&Doctor_id=$doctorId&dsr_type=$dsrType";
}

// class EDSRApis {
//   static const _api = 'http://10.168.27.183:8000';
//   static const _app = 'skf_api';
//   static const _userPass = '1234';
//   static const _userID = 'ITFM';
//   String getDoctor(String doctorUrl, String cid, String userId, String userPass,
//           String regionId, String areaId, String terroId, String dsrType) =>
//       "$_api/$_app/api_dsr_settings/get_area_doctor?cid=$cid&user_id=$userId&user_pass=$_userPass&region_id=$regionId&area_id=$areaId&territory_id=$terroId&dsr_type=$dsrType";

//   String getEDsrSettingApi(
//     String eDsrSettingsUrl,
//     String cid,
//     String userId,
//     String userPass,
//   ) =>
//       "${eDsrSettingsUrl}api_dsr_settings/dsr_setting?cid=$cid&user_id=$userId&user_pass=$userPass";

// //=============================== eDSR Approval Section =================================
//   static String eDSRfmListApi(
//           String fmListUrl, String cid, String userId, String userPass) =>
//       "${fmListUrl}api_dsr_approve/sup_home?cid=$cid&user_id=$userId&user_pass=$userPass";

//   static String dsrDetailsApi(
//           String dsrDetailsApi,
//           String cid,
//           String userId,
//           String userPass,
//           String submitedBy,
//           String territoryId,
//           String levelDepth) =>
//       "${dsrDetailsApi}api_dsr_approve/dsr_details?cid=$cid&user_id=$userId&user_pass=$userPass&submit_by=$submitedBy&territory_id=$territoryId&level_depth_no=$levelDepth";

//   static String brandAmountUpdate(String brandAmountUpdateUrl, String cid,
//           String userId, String userPass, String brandAmountUpdateParams) =>
//       "${brandAmountUpdateUrl}api_dsr_approve/brand_amount_update?cid=$cid&user_id=$userId&user_pass=$userPass&$brandAmountUpdateParams";

//   static String approveEDSR(String approveEDSRUrl, String cid, String userId,
//           String userPass, String approvedEdsrParams) =>
//       "${approveEDSRUrl}api_dsr_approve/dsr_approval?cid=$cid&user_id=$userId&user_pass=$userPass&$approvedEdsrParams";

//   String eDsrAddApi(
//     String eDsrSettingsUrl,
//     String cid,
//     String userId,
//     String userPass,
//     String syncCode,
//     String brandStr,
//     String areaId,
//     String doctorId,
//     String doctorName,
//     String doctorCategory,
//     String latitude,
//     String longitude,
//     String dsrType,
//     String dsrCat,
//     String purpose,
//     String purposeSub,
//     String pDes,
//     String pDtFrom,
//     String pDtTo,
//     String noOfPatient,
//     String payFrom,
//     String payTo,
//     String schedule,
//     String payNMonth,
//     String payMode,
//     String chequeTo,
//     String rsmCash,
//     String issueTo,
//   ) =>
//       "$_api/$_app/api_dsr_submit/data_submit?cid=$cid&rep_id=$userId&rep_pass=$_userPass";
//   // "${eDsrSettingsUrl}api_dsr_submit/data_submit?cid=$cid&rep_id=$userId&rep_pass=$userPass";
//   // &synccode=$syncCode&brand_Str=$brandStr&areaId=$areaId&doctor_id=$doctorId&doctor_name=$doctorName&doctor_category=$doctorCategory&latitude=$latitude&longitude=$longitude&dsr_type=$dsrType&dsr_cat=$dsrCat&purpose=$purpose&purpose_sub=$purposeSub&p_des=$pDes&p_dt_from=$pDtFrom&p_dt_to=$pDtTo&no_of_patient=$noOfPatient&pay_from=$payFrom&pay_to=$payTo&schedule=$schedule&pay_n_month=$payNMonth&pay_mode=$payMode&cheque_to=$chequeTo&rsm_cash=$rsmCash&pay_mode_bill_to=$issueTo
//   // ";

//   static String mobileUpdateApi(
//           String approveEDSRUrl,
//           String cid,
//           String userId,
//           String userPass,
//           String doctorId,
//           String dsrType,
//           String upMobileNumber,
//           String areaId) =>
//       "${approveEDSRUrl}api_dsr_approve/doc_mobile_update?cid=$cid&user_id=$userId&user_pass=$userPass&up_mobile=$upMobileNumber&area_id=$areaId&Doctor_id=$doctorId&dsr_type=$dsrType";
// }
