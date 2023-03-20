import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DcrServices {
  calculatingGspItemString(List<DcrGSPDataModel> addedDcrGSPList) {
    String itemString = '';

    if (addedDcrGSPList.isNotEmpty) {
      for (var element in addedDcrGSPList) {
        if (itemString == '') {
          itemString =
              '${element.giftId}|${element.quantity}|${element.giftType}';
        } else {
          itemString +=
              '||${element.giftId}|${element.quantity}|${element.giftType}';
        }
      }
    }
    return itemString;
  }

// This section for Dcr GSP delete update to Hive Table
  static deleteDcrGspFromDraft(Box<DcrDataModel> box, String docId) {
    box.toMap().forEach((key, value) {
      if (value.docId == docId) {
        box.delete(key);
      }
    });
  }

  static updateDcrWithGspToDraft(Box<DcrDataModel> dcrBox,
      List<DcrGSPDataModel> addedDcrGSPList, String docId) {
    dynamic desirekey;
    dcrBox.toMap().forEach((key, value) {
      if (value.docId == docId) {
        desirekey = key;
      }
    });
    DcrDataModel? dcrData = dcrBox.get(desirekey);

    if (dcrData!.isInBox) {
      dcrData.dcrGspList = addedDcrGSPList;
    }

    dcrBox.put(desirekey, dcrData);
  }

  // for test...........
  static singleDeleteGspItemFromDraft(
      Box<DcrDataModel> box, String docId, String id) {
    dynamic desirekey;
    box.toMap().forEach((key, value) {
      if (value.docId == docId) {
        desirekey = key;
      }
    });
    DcrDataModel? dcrData = box.get(desirekey);
    if (dcrData!.isInBox) {
      dcrData.dcrGspList.removeWhere((element) => element.giftId == id);
    }

    box.put(desirekey, dcrData);
  }
}
