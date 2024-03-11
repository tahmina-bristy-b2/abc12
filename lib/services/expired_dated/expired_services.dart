import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/models/expired_dated/expired_submit_and_save_data_model.dart';
import 'package:hive_flutter/adapters.dart';

class ExpiredServices{
  Future putExpiredDate(ExpiredItemListDataModel? expiredDatedDataModel) async {
    final expiredDatedBox = Boxes.getExpiredDatedIItems();
    expiredDatedBox.put("expiredDatedItemSync", expiredDatedDataModel!);
  }

  //================================ each item deleted===============================
  deleteEachItem(Box<ExpiredSubmitDataModel> customerExpiredItemsBox,String itemId,String clientId,String batchId, String expiredDate, String qty){
    dynamic desireKey;
    customerExpiredItemsBox.toMap().forEach((key, value) {
      if (value.clientId == clientId) {
        desireKey = key;  
      }
     });
     ExpiredSubmitDataModel? clientData = customerExpiredItemsBox.get(desireKey);
    if (clientData!.isInBox) {
      for (var element in clientData.expiredItemSubmitModel) {
        if(element.itemId==itemId){
           element.batchWiseItem.removeWhere((element1) => (element1.batchId==batchId)&&(element1.expiredDate==expiredDate)&&(element1.unitQty==qty)); 
        }  
      }
       clientData.expiredItemSubmitModel.removeWhere((element) =>element.batchWiseItem.isEmpty );
    }
    customerExpiredItemsBox.put(desireKey, clientData);
  }

  //=========================================== item Search========================================================
  List<ExpiredItemList> searchDynamicMethod(String enteredKeyword, List<ExpiredItemList>  data, ) {
    List<ExpiredItemList>  serachedData;
    serachedData = data;
    List<ExpiredItemList>  results = [];
    if (enteredKeyword.isEmpty) {
      results = serachedData;
    } else {
      var starts = serachedData
          .where((s) =>
              s.itemName.toLowerCase().startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = serachedData
          .where((s) =>
              s.itemName.toLowerCase().contains(enteredKeyword.toLowerCase()) &&
              !s.itemName
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) =>
            a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()));

      results = [...starts, ...contains];
    }
    return results;
  }
}