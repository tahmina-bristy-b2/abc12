import 'package:MREPORTING/models/hive_models/hive_data_model.dart';

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
}
