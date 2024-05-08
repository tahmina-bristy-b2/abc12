import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/models/e_CME/e_CME_submit_data_model.dart';

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


  //================================ Get Doctor String ============================
  String getDoctString(List<DocListECMEModel> docInfo){
    String docListString="";
    for (var element1 in docInfo) {
            if (docListString == "") {
              docListString +=
                  "${element1.docId}|${element1.docName}";
            } else {
              docListString +=
                  "||${element1.docId}|${element1.docName}";
            }
     }
     return docListString;
  }
  
  //=================================== Unique brand List =================================
  List<List<dynamic>> removeDuplicationForBrand(
      List<List<dynamic>> actualBrandList) {
    Map<String, List<dynamic>> uniqueBrandMap = {};
    for (var subList in actualBrandList) {
      uniqueBrandMap[subList[0]] = subList;
    }
    return uniqueBrandMap.values.toList();
  }

   //============================== Cost per doctor ======================================
   double getCostPerDoctor(double totalBudget,int noIfparticipants){
    if(totalBudget>0.0){
      double costPerDoctor= totalBudget/noIfparticipants;
      return costPerDoctor;
    }
    else{
      return 0.0;
    }
   }


   
  //=============================== get brand String ===============================
  String getbrandString(ECMESavedDataModel? eCMESettingsData,List<List<dynamic>> finalBrandListAftrRemoveDuplication,double splitedAmount) {
   String brandString = '';
    for (var element1 in eCMESettingsData!.eCMEBrandList) {
      if (finalBrandListAftrRemoveDuplication.isNotEmpty) {
        for (int i = 0; i < finalBrandListAftrRemoveDuplication.length; i++) {
          if (element1.brandName == finalBrandListAftrRemoveDuplication[i][0]) {
            if (brandString == "") {
              brandString +=
                  "${element1.brandId}|${element1.brandName}|${finalBrandListAftrRemoveDuplication[i][2]}|${splitedAmount.toStringAsFixed(2)}";
            } else {
              brandString +=
                  "||${element1.brandId}|${element1.brandName}|${finalBrandListAftrRemoveDuplication[i][2]}|${splitedAmount.toStringAsFixed(2)}";
            }
          }
        }
      } else {
        brandString = "";
      }
    }
    return brandString;
  }



  Map<String,dynamic> dynamicTotalCalculation( ECMESubmitDataModel eCMESubmitDataModel ) {
   int totalAmount = 0;
   String eCMEAmount = double.parse(eCMESubmitDataModel.eCMEAmount).toStringAsFixed(2);
    for (var element in eCMESubmitDataModel.brandList) {
      totalAmount = totalAmount + int.parse(element[2]);
    }
    return {
      "total_amount":totalAmount,
      "eCME_amount":eCMEAmount
    };
  }


}