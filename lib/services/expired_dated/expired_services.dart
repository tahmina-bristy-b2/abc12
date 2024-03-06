import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';

class ExpiredServices{
  Future putExpiredDate(ExpiredItemListDataModel? expiredDatedDataModel) async {
    final expiredDatedBox = Boxes.getExpiredDatedIItems();
    expiredDatedBox.put("expiredDatedItemSync", expiredDatedDataModel!);
  }
}