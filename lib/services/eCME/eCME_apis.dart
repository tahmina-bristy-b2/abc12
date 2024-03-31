class ECMEApis{
  String getECMEDataDetails( String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,)=>"http://10.168.27.183:8000/skf_api/api_eCME_settings/ecme_setting?cid=SKF&user_id=IT003&user_pass=1234";


    String getECMEAddDoctorApi(String doctorUrl, String cid, String userId, String userPass,
          String regionId, String areaId, String terroId, String dsrType) =>
          "http://10.168.27.183:8000/skf_api/api_eCME_settings/get_area_doctor?cid=SKF&user_id=IT003&user_pass=1234&region_id=CF&area_id=CF20&territory_id=CF22";
     // "${doctorUrl}api_dsr_settings/get_area_doctor?cid=$cid&user_id=$userId&user_pass=$userPass&region_id=$regionId&area_id=$areaId&territory_id=$terroId&dsr_type=$dsrType";


    //  String submitApi(String doctorUrl, String cid, String userId, String userPass,
    //       String regionId, String areaId, String terroId, String dsrType) =>
    //       "http://10.168.27.183:8000/skf_api/api_eCME_settings/get_area_doctor?cid=SKF&user_id=IT003&user_pass=1234&region_id=CF&area_id=CF20&territory_id=CF22";
    //  // "${doctorUrl}api_dsr_settings/get_area_doctor?cid=$cid&user_id=$userId&user_pass=$userPass&region_id=$regionId&area_id=$areaId&territory_id=$terroId&dsr_type=$dsrType";

}