import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';

class ECMEServices{
   //====================================== Load eDSR Data Settings Info=====================================
  Future putEdsrSettingsData(ECMESavedDataModel eCMESavedDataModel) async {
    final eCMEDavedDataBox = Boxes.geteCMEsetData();
    eCMEDavedDataBox.put("eCMESavedDataSync", eCMESavedDataModel);
  }


  // List<dynamic>  getItemList(String brandName,List<dynamic>  givenDoctor,){
  // List<dynamic> machingDoctorList=[];
  // String brandId="";
  //   for(var item in givenDoctor ){
  //               if(item[]==brandName){
  //                 brandId=item.brandId;
  //       }
  //   }
  //  for (var brand in brandList) {
  //    machingItem.addAll(brand.itemList
  //     .where((item) => item.brandId.toLowerCase().contains(brandId.toLowerCase())));
  //  }
  //  return machingItem;

  // }
}