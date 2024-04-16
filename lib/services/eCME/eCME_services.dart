import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';

class ECMEServices{
   //====================================== Load eDSR Data Settings Info=====================================
  Future putEdsrSettingsData(ECMESavedDataModel eCMESavedDataModel) async {
    final eCMEDavedDataBox = Boxes.geteCMEsetData();
    eCMEDavedDataBox.put("eCMESavedDataSync", eCMESavedDataModel);
  }

  //************************************* This method works for ECME Doctor seraching *******************************/
  List<DocListECMEModel> doctorSearch(String enteredKeyword, List<DocListECMEModel> serachedData) {
     List<DocListECMEModel>  results = [];
    if (enteredKeyword.isEmpty || enteredKeyword == "") {
      results = serachedData;
    } else {
      var starts = serachedData
          .where((s) =>
              s.docName
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()) ||
              s.areaName
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()) ||
              s.areaId
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()) ||
              s.address
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = serachedData
          .where((s) =>
              (s.docName
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) &&
                  !s.docName
                      .toLowerCase()
                      .startsWith(enteredKeyword.toLowerCase())) ||
              (s.areaName
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) &&
                  !s.areaName
                      .toLowerCase()
                      .startsWith(enteredKeyword.toLowerCase())) ||
              (s.areaId
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) &&
                  !s.areaId
                      .toLowerCase()
                      .startsWith(enteredKeyword.toLowerCase())) ||
              (s.address
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) &&
                  !s.address
                      .toLowerCase()
                      .startsWith(enteredKeyword.toLowerCase())))
          .toList()
        ..sort((a, b) =>
            a.docName.toLowerCase().compareTo(b.docName.toLowerCase()));

      results = [...starts, ...contains];
    }
    return results;
  }
}