class eDSRApis {
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
      "https://skfmobileapi.azurewebsites.net/skf_api/api_dsr_approve/sup_home?cid=$cid&user_id=$userId&user_pass=$userPass";

  static String dsrDetailsApi(String dsrDetailsApi, String cid, String userId,
          String userPass, String submitedBy, String territoryId) =>
      "https://skfmobileapi.azurewebsites.net/skf_api/api_dsr_approve/dsr_details?cid=$cid&user_id=$userId&user_pass=$userPass&submit_by=$submitedBy&territory_id=$territoryId";

  static String brandAmountUpdate(String brandAmountUpdateUrl, String cid,
          String userId, String userPass, String brandAmountUpdateParams) =>
      "https://skfmobileapi.azurewebsites.net/skf_api/api_dsr_approve/brand_amount_update?cid=$cid&user_id=$userId&user_pass=$userPass&$brandAmountUpdateParams";

  static String approveEDSR(String approveEDSRUrl, String cid, String userId,
          String userPass, String approvedEdsrParams) =>
      "https://skfmobileapi.azurewebsites.net/skf_api/api_dsr_approve/approved_dsr?cid=$cid&user_id=$userId&user_pass=$userPass&$approvedEdsrParams";

  String eDsrAddApi(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
    String syncCode,
    String brandStr,
    String areaId,
    String doctorId,
    String doctorName,
    String doctorCategory,
    String latitude,
    String longitude,
    String dsrType,
    String dsrCat,
    String purpose,
    String purposeSub,
    String pDes,
    String pDtFrom,
    String pDtTo,
    String noOfPatient,
    String payFrom,
    String payTo,
    String schedule,
    String payNMonth,
    String payMode,
    String chequeTo,
    String rsmCash,
    String issueTo,
  ) =>
      "${eDsrSettingsUrl}api_dsr_submit/data_submit?cid=$cid&rep_id=$userId&rep_pass=$userPass&synccode=$syncCode&brand_Str=$brandStr&areaId=$areaId&doctor_id=$doctorId&doctor_name=$doctorName&doctor_category=$doctorCategory&latitude=$latitude&longitude=$longitude&dsr_type=$dsrType&dsr_cat=$dsrCat&purpose=$purpose&purpose_sub=$purposeSub&p_des=$pDes&p_dt_from=$pDtFrom&p_dt_to=$pDtTo&no_of_patient=$noOfPatient&pay_from=$payFrom&pay_to=$payTo&schedule=$schedule&pay_n_month=$payNMonth&pay_mode=$payMode&cheque_to=$chequeTo&rsm_cash=$rsmCash&pay_mode_bill_to=$issueTo";
}
