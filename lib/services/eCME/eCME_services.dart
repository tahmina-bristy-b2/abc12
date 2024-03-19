import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';

class ECMEServices{
   //====================================== Load eDSR Data Settings Info=====================================
  Future putEdsrSettingsData(ECMESavedDataModel eCMESavedDataModel) async {
    final eCMEDavedDataBox = Boxes.geteCMEsetData();
    eCMEDavedDataBox.put("eCMESavedDataSync", eCMESavedDataModel);
  }
}