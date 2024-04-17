class ECMEApis{
  String getECMEDataDetails( String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,)=>
    "http://10.168.27.183:8000/skf_api/api_eCME_settings/ecme_setting?cid=$cid&user_id=$userId&user_pass=$userPass";
    //"${eDsrSettingsUrl}api_eCME_settings/ecme_setting?cid=$cid&user_id=$userId&user_pass=$userPass";


    String getECMEAddDoctorApi(String doctorUrl, String cid, String userId, String userPass,
          String regionId, String areaId, String terroId, String dsrType) =>
          "http://10.168.27.183:8000/skf_api/api_eCME_settings/get_area_doctor?cid=SKF&user_id=IT003&user_pass=1234&region_id=CF&area_id=CF20&territory_id=CF22";
     // "${doctorUrl}api_dsr_settings/get_area_doctor?cid=$cid&user_id=$userId&user_pass=$userPass&region_id=$regionId&area_id=$areaId&territory_id=$terroId&dsr_type=$dsrType";
  
   static String getEcmeFFList(
          String fmListUrl, String cid, String userId, String userPass) =>
    //  "${fmListUrl}api_dsr_approve/sup_home?cid=$cid&user_id=$userId&user_pass=$userPass";
       "http://10.168.27.183:8000/skf_api/api_ecme_approve/sup_home?cid=$cid&user_id=$userId&user_pass=$userPass";

  static String eCMEDetailsApi(
          String dsrDetailsApi,
          String cid,
          String userId,
          String userPass,
          String submitedBy,
          String territoryId,
          String levelDepth) =>
    // "${dsrDetailsApi}api_ecme_approve/ecme_details?cid=$cid&user_id=$userId&user_pass=$userPass&submit_by=$submitedBy&territory_id=$territoryId&level_depth_no=$levelDepth";
   "http://10.168.27.183:8000/skf_api/api_ecme_approve/ecme_details?cid=$cid&user_id=$userId&user_pass=$userPass&submit_by=$submitedBy&area_id=ZAREA&level_depth_no=$levelDepth";

   static String eCMEApproved(
    String sl,
         String approveEDSRUrl, String cid, String userId,
          String userPass, String approvedEdsrParams)=>
        // "${approveEDSRUrl}api_ecme_approve/ecme_approval?cid=$cid&user_id=$userId&user_pass=$userPass&sl=$sl&status=$approvedEdsrParams";
          "http://10.168.27.183:8000/skf_api/api_ecme_approve/ecme_approval?cid=$cid&user_id=$userId&user_pass=$userPass&sl=$sl&status=$approvedEdsrParams";

}