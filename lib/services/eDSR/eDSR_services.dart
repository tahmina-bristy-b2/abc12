import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EDsrServices {
  //================================get eDSR Data Settings Info=================================

  Future<EdsrDataModel?> geteDSRDataSettingsInfo(
      String cid, String userId, String userPassward) async {
    EdsrDataModel? eDsrDataModelData;
    try {
      eDsrDataModelData =
          await eDSRRepository().getEDSRSettingsInfo(cid, userId, userPassward);
      if (eDsrDataModelData.status == "Success") {
        await putEdsrSettingsData(eDsrDataModelData);
        return eDsrDataModelData;
      } else {
        AllServices().toastMessage(
            'eDSR Settings data load Failed', Colors.red, Colors.white, 16);

        return eDsrDataModelData;
      }
    } on Exception catch (e) {
      print(e);
    }
    return eDsrDataModelData;
  }

  //====================================== Load eDSR Data Settings Info=====================================
  Future putEdsrSettingsData(EdsrDataModel eDsrDataModelData) async {
    final eDsrSettingBox = Boxes.geteDSRsetData();
    eDsrSettingBox.put("eDSRSettingsData", eDsrDataModelData);
  }
}
