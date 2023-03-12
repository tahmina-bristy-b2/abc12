import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrap7/local_storage/hive_data_model.dart';

class HiveAdapter {
  HiveAdapterbox() async {
    Hive.registerAdapter(AddItemModelAdapter());
    Hive.registerAdapter(CustomerDataModelAdapter());
    Hive.registerAdapter(DcrDataModelAdapter());
    Hive.registerAdapter(DcrGSPDataModelAdapter());
    Hive.registerAdapter(RxDcrDataModelAdapter());
    Hive.registerAdapter(MedicineListModelAdapter());

    await Hive.openBox<AddItemModel>('orderedItem');
    await Hive.openBox<CustomerDataModel>('customerHive');
    await Hive.openBox<DcrDataModel>('selectedDcr');
    await Hive.openBox<DcrGSPDataModel>('selectedDcrGSP');
    await Hive.openBox<RxDcrDataModel>('RxdDoctor');
    await Hive.openBox<MedicineListModel>('draftMdicinList');
  }
}
