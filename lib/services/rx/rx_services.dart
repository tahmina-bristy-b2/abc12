import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RxServices {
  String calculateRxItemString(finalMedicineList) {
    String itemString = "";
    if (finalMedicineList.isNotEmpty) {
      finalMedicineList.forEach((element) {
        if (itemString == '') {
          itemString = '${element.itemId}|${element.quantity}';
        } else {
          itemString += '||${element.itemId}|${element.quantity}';
        }
      });
    }

    return itemString;
  }

  static updateRxDcrImageToDraft(
      Box<RxDcrDataModel> rxDcrBox, String imagePath, String uid) {
    dynamic desirekey;
    rxDcrBox.toMap().forEach((key, value) {
      if (value.uid == uid) {
        desirekey = key;
      }
    });
    RxDcrDataModel? rxDcrData = rxDcrBox.get(desirekey);

    if (rxDcrData!.isInBox) {
      rxDcrData.presImage = imagePath.toString();
    }

    rxDcrBox.put(desirekey, rxDcrData);
  }

  static updateRxDcrMedicineToDraft(
      Box<RxDcrDataModel> rxDcrBox,
      List<RxDcrDataModel> rxDcrlist,
      List<MedicineListModel> addedDcrMedList,
      String uid) {
    dynamic desirekey;
    rxDcrBox.toMap().forEach((key, value) {
      if (value.uid == uid) {
        desirekey = key;
      }
    });
    RxDcrDataModel? rxDcrData = rxDcrBox.get(desirekey);

    if (rxDcrData!.isInBox) {
      rxDcrData.docName = rxDcrlist.first.docName;
      rxDcrData.docId = rxDcrlist.first.docId;
      rxDcrData.areaName = rxDcrlist.first.areaName;
      rxDcrData.areaId = rxDcrlist.first.areaId;
      rxDcrData.address = rxDcrlist.first.address;
      rxDcrData.presImage = rxDcrlist.first.presImage;
      rxDcrData.rxMedicineList = addedDcrMedList;
      // rxDcrData.visitedWith = visitedWith;
      // rxDcrData.notes = notes;
    }

    rxDcrBox.put(desirekey, rxDcrData);
  }

  static deleteRxDataFromDraft(Box<RxDcrDataModel> box, String uid) {
    box.toMap().forEach((key, value) {
      if (value.uid == uid) {
        box.delete(key);
      }
    });
  }

  static singleDeleteRxMedicineFromDraft(
      Box<RxDcrDataModel> box, String uid, String medId) {
    dynamic desirekey;
    box.toMap().forEach((key, value) {
      if (value.uid == uid) {
        desirekey = key;
      }
    });
    RxDcrDataModel? dcrData = box.get(desirekey);
    if (dcrData!.isInBox) {
      dcrData.rxMedicineList.removeWhere((element) => element.itemId == medId);
    }

    box.put(desirekey, dcrData);
  }
}
    // var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    // String time = dt.replaceAll(":", '');