import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING_OFFLINE/services/eDSR/eDSr_repository.dart';

class EDSRServices {
  //================================get eDSR Data Settings Info=================================

  Future<EdsrDataModel?> geteDSRDataSettingsInfo(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
    String path,
  ) async {
    EdsrDataModel? eDsrDataModelData;

    eDsrDataModelData = await EDSRRepositories()
        .getEDSRSettingsInfo(eDsrSettingsUrl, cid, userId, userPass, path);

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
