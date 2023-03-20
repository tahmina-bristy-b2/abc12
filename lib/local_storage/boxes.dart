import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:hive/hive.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:path_provider/path_provider.dart';

class Boxes {
  static Box<AddItemModel> getDraftOrderedData() => Hive.box('orderedItem');
  static Box<CustomerDataModel> getCustomerUsers() => Hive.box('customerHive');
  static Box<DcrDataModel> dcrUsers() => Hive.box('selectedDcr');
  static Box<DcrGSPDataModel> selectedDcrGSP() => Hive.box('selectedDcrGSP');
  static Box<RxDcrDataModel> rxdDoctor() => Hive.box('RxdDoctor');
  static Box<MedicineListModel> getMedicine() => Hive.box('draftMdicinList');
  static Box<DmPathDataModel> getDmpath() => Hive.box('DmPath');
  static Box<UserLoginModel> getLoginData() => Hive.box('UserLoginData');

  // This method Used for only sync Data
  Future openAndAddDataToBox(String tableName, List syncData) async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box box = await Hive.openBox(tableName);
    await box.clear();
    for (var d in syncData) {
      box.add(d);
    }
  }

  Future<Box> openBox(String tableName) async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box box = await Hive.openBox(tableName);
    return box;
  }

  static deleteItemFromBoxTable(Box box, int id) {
    box.toMap().forEach((key, value) {
      if (value.uiqueKey == id) {
        box.delete(key);
      }
    });
  }

  // for dcr test...........
  // static deleteDcrGspFromDraft(Box<DcrDataModel> box, String docId) {
  //   box.toMap().forEach((key, value) {
  //     if (value.docId == docId) {
  //       box.delete(key);
  //     }
  //   });
  // }

  // static updateDcrWithGspToDraft(Box<DcrDataModel> dcrBox,
  //     List<DcrGSPDataModel> addedDcrGSPList, String docId) {
  //   dynamic desirekey;
  //   dcrBox.toMap().forEach((key, value) {
  //     if (value.docId == docId) {
  //       desirekey = key;
  //     }
  //   });
  //   DcrDataModel? dcrData = dcrBox.get(desirekey);

  //   if (dcrData!.isInBox) {
  //     dcrData.dceGspList = addedDcrGSPList;
  //   }

  //   dcrBox.put(desirekey, dcrData);
  // }

  // // for test...........
  // static singleDeleteGspItemFromDraft(
  //     Box<DcrDataModel> box, String docId, String id) {
  //   dynamic desirekey;
  //   box.toMap().forEach((key, value) {
  //     if (value.docId == docId) {
  //       desirekey = key;
  //     }
  //   });
  //   DcrDataModel? dcrData = box.get(desirekey);
  //   if (dcrData!.isInBox) {
  //     dcrData.dceGspList.removeWhere((element) => element.giftId == id);
  //   }

  //   box.put(desirekey, dcrData);
  // }

  static clearBox() {
    Hive.openBox('data').then((value) => value.clear());
    Hive.openBox('syncItemData').then((value) => value.clear());
    Hive.openBox('dcrListData').then((value) => value.clear());
    Hive.openBox('dcrGiftListData').then((value) => value.clear());
    Hive.openBox('dcrSampleListData').then((value) => value.clear());
    Hive.openBox('dcrPpmListData').then((value) => value.clear());
    Hive.openBox('medicineList').then((value) => value.clear());
  }
}
