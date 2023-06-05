import 'dart:io';

import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RxServices {
  String calculateRxItemString(List<MedicineListModel> finalMedicineList) {
    String itemString = "";
    if (finalMedicineList.isNotEmpty) {
      for (var element in finalMedicineList) {
        if (itemString == '') {
          itemString = '${element.itemId}|${element.quantity}';
        } else {
          itemString += '||${element.itemId}|${element.quantity}';
        }
      }
    }

    return itemString;
  }

  // static updateRxDcrImageToDraft(
  //     Box<RxDcrDataModel> rxDcrBox, String imagePath, String uid) {
  //   dynamic desirekey;
  //   rxDcrBox.toMap().forEach((key, value) {
  //     if (value.uid == uid) {
  //       desirekey = key;
  //     }
  //   });
  //   RxDcrDataModel? rxDcrData = rxDcrBox.get(desirekey);

  //   if (rxDcrData!.isInBox) {
  //     rxDcrData.presImage = imagePath.toString();
  //   }

  //   rxDcrBox.put(desirekey, rxDcrData);
  // }

  static updateRxDcrMedicineToDraft(
      Box<RxDcrDataModel> rxDcrBox,
      List<RxDcrDataModel> rxDcrlist,
      List<MedicineListModel> addedDcrMedList,
      String uid,
      String rxType) {
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
      rxDcrData.rxType = rxType;
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

  Future<File?> getImageFrom({required File? imageFile}) async {
    if (imageFile != null) {
      var image = File(imageFile.path.toString());
      final _sizeInKbBefore = image.lengthSync() / 1024;
      print('Before Compress $_sizeInKbBefore kb');
      var _compressedImage = await compress(image: image);
      final _sizeInKbAfter = _compressedImage.lengthSync() / 1024;
      print('After Compress $_sizeInKbAfter kb');
      // var _croppedImage = await AppHelper.cropImage(_compressedImage);
      // if (_croppedImage == null) {
      //   return;
      // }

      return _compressedImage;
    }
  }

  static Future<File> compress({
    required File image,
    int quality = 80,
    int percentage = 20,
  }) async {
    var path = await FlutterNativeImage.compressImage(
      image.absolute.path,
      quality: quality,
      percentage: percentage,
      // targetWidth: targetW, //user for heigght

      // targetHeight: targetW, // used for width
    );
    return path;
  }

  static Future<File> compress2(
      {required File image,
      int quality = 70,
      int percentage = 20,
      targetW = 600,
      targetH = 450}) async {
    var path = await FlutterNativeImage.compressImage(
      image.absolute.path,
      quality: quality,
      percentage: percentage,
      targetWidth: targetW, //user for heigght

      targetHeight: targetH, // used for width
    );
    final _sizeInKbAfter = path.lengthSync() / 1024;
    print('After Compress $_sizeInKbAfter kb');
    return path;
  }
}
    // var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    // String time = dt.replaceAll(":", '');