class eDSRApis {
  String regionListUri(String areaUrl, String cid, String userId,
          String userPass, String deviceId) =>
      // '$areaUrl?cid=$cid&user_id=$userId&user_pass=$userPass&device_id=$deviceId';
      "http://w03.yeapps.com/skf_rx_api_101/api_area/get_region_list?cid=SKF&user_id=it006&user_pass=1900&device_id=a5581593ed4adf8b";

  String getDoctor(String doctorUrl, String cid, String userId, String userPass,
          String regionId, String areaId, String terroId, String dsrType) =>
      // "$doctorUrl?cid=$cid&user_id=$userId&user_pass=$userPass&region_id=$regionId&area_id=$areaId&territory_id=$terroId";
      "${doctorUrl}api_dsr_settings/get_area_doctor?cid=$cid&user_id=$userId&user_pass=$userPass&region_id=$regionId&area_id=$areaId&territory_id=$terroId&dsr_type=$dsrType";

  String getEDsrSettingApi(
    String cid,
    String userId,
    String userPass,
  ) =>
      "https://skfmobileapi.azurewebsites.net/skf_api/api_dsr_settings/dsr_setting?cid=SKF&user_id=IT006&user_pass=1900";

//=============================== eDSR Approval Section =================================
  static eDSRfmListApi(
          String fmListUrl, String cid, String userId, String userPass) =>
      "https://skfmobileapi.azurewebsites.net/skf_api/api_dsr_approve/sup_home?cid=$cid&user_id=$userId&user_pass=$userPass";

  static dsrDetailsApi(String dsrDetailsApi, String cid, String userId,
          String userPass, String submitedBy, String territoryId) =>
      "https://skfmobileapi.azurewebsites.net/skf_api/api_dsr_approve/dsr_details?cid=$cid&user_id=$userId&user_pass=$userPass&submit_by=$submitedBy&territory_id=$territoryId";
}
