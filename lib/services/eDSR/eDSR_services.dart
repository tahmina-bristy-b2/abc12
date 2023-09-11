import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:flutter/material.dart';

class EDSRServices {
  //================================get eDSR Data Settings Info=================================

  Future<EdsrDataModel?> geteDSRDataSettingsInfo(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    EdsrDataModel? eDsrDataModelData;

    eDsrDataModelData = await EDSRRepositories()
        .getEDSRSettingsInfo(eDsrSettingsUrl, cid, userId, userPass);

    if (eDsrDataModelData != null) {
      await putEdsrSettingsData(eDsrDataModelData);
      return eDsrDataModelData;
    }

    return eDsrDataModelData;
  }

  //====================================== Load eDSR Data Settings Info=====================================
  Future putEdsrSettingsData(EdsrDataModel eDsrDataModelData) async {
    final eDsrSettingBox = Boxes.geteDSRsetData();
    eDsrSettingBox.put("eDSRSettingsData", eDsrDataModelData);
  }
}
