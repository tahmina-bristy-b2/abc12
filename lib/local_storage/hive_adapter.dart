import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';

class HiveAdapter {
  hiveAdapterbox() async {
    Hive.registerAdapter(AddItemModelAdapter());
    Hive.registerAdapter(CustomerDataModelAdapter());
    Hive.registerAdapter(DcrDataModelAdapter());
    Hive.registerAdapter(DcrGSPDataModelAdapter());
    Hive.registerAdapter(RxDcrDataModelAdapter());
    Hive.registerAdapter(MedicineListModelAdapter());
    Hive.registerAdapter(DmPathDataModelAdapter());
    Hive.registerAdapter(UserLoginModelAdapter());

    await Hive.openBox<AddItemModel>('orderedItem');
    await Hive.openBox<CustomerDataModel>('customerHive');
    await Hive.openBox<DcrDataModel>('selectedDcr');
    await Hive.openBox<DcrGSPDataModel>('selectedDcrGSP');
    await Hive.openBox<RxDcrDataModel>('RxdDoctor');
    await Hive.openBox<MedicineListModel>('draftMdicinList');
    await Hive.openBox<DmPathDataModel>('DmPath');
    await Hive.openBox<UserLoginModel>('UserLoginData');
  }
}
