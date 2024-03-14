import 'package:hive_flutter/adapters.dart';
part 'expired_submit_and_save_data_model.g.dart';

@HiveType(typeId: 81)
class ExpiredSubmitDataModel extends HiveObject {
  @HiveField(0)
  String clientName;
  @HiveField(1)
  String marketName;
  @HiveField(2)
  String areaId;
  @HiveField(3)
  String clientId;
  @HiveField(4)
  String outstanding;
  @HiveField(5)
  String thana;
  @HiveField(6)
  String address;
  @HiveField(7)
  List<ExpiredItemSubmitModel> expiredItemSubmitModel;

  ExpiredSubmitDataModel(
      {required this.clientName,
      required this.marketName,
      required this.areaId,
      required this.clientId,
      required this.outstanding,
      required this.thana,
      required this.address,
      required this.expiredItemSubmitModel,
    });
}

@HiveType(typeId: 82)
class ExpiredItemSubmitModel extends HiveObject {
  @HiveField(0)
  String itemName ;
  @HiveField(1)
  String quantity;
  @HiveField(2)
  String tp;
  @HiveField(3)
  String itemId;
  @HiveField(4)
  String categoryId;
  @HiveField(5)
  String vat;
  @HiveField(6)
  String manufacturer;
  @HiveField(7)
  String itemString;
  @HiveField(8)
  List<BatchWiseItemListModel> batchWiseItem;

  ExpiredItemSubmitModel(
      {required this.itemName ,
      required this.quantity,
      required this.tp,
      required this.itemId,
      required this.categoryId,
      required this.vat,
      required this.manufacturer,
      required this.itemString,
      required this.batchWiseItem,
     });
}
@HiveType(typeId: 83)
class BatchWiseItemListModel extends HiveObject {
  @HiveField(0)
  String batchId ;
  @HiveField(1)
  String unitQty;
  @HiveField(2)
  String expiredDate;
  @HiveField(3)
  DateTime expiredDateTime;

  BatchWiseItemListModel(
      { 
        required this.batchId,
        required this.unitQty,
        required this.expiredDate, 
        required this.expiredDateTime, 
      }
    );
}