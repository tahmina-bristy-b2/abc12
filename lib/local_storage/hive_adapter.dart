import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
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
    Hive.registerAdapter(EdsrDataModelAdapter());
    Hive.registerAdapter(BrandListAdapter());
    Hive.registerAdapter(RegionListAdapter());
    Hive.registerAdapter(AreaListAdapter());
    Hive.registerAdapter(TerritoryListAdapter());
    Hive.registerAdapter(PurposeListAdapter());
    Hive.registerAdapter(SubPurposeListAdapter());
    Hive.registerAdapter(RxDurationMonthListAdapter());
    Hive.registerAdapter(DsrDurationMonthListAdapter());
    //================= expired Dated ================
    Hive.registerAdapter(ExpiredItemListDataModelAdapter());
    Hive.registerAdapter(ExpiredItemListAdapter());


    await Hive.openBox<AddItemModel>('orderedItem');
    await Hive.openBox<CustomerDataModel>('customerHive');
    await Hive.openBox<DcrDataModel>('selectedDcr');
    await Hive.openBox<DcrGSPDataModel>('selectedDcrGSP');
    await Hive.openBox<RxDcrDataModel>('RxdDoctor');
    await Hive.openBox<MedicineListModel>('draftMdicinList');
    await Hive.openBox<DmPathDataModel>('DmPath');
    await Hive.openBox<UserLoginModel>('UserLoginData');

    await Hive.openBox<EdsrDataModel>('eDSRSettingsData');
    await Hive.openBox('doctorList');

    /// [DcrRxTarget] this table name used for Dcr Rx target value
    await Hive.openBox('DcrRxTarget');

    /// [ChemistRxTarget] this table name used for Chemist Rx target value
    await Hive.openBox('ChemistRxTarget');

    //========================= expired sync data =========================
    await Hive.openBox<ExpiredItemListDataModel>('expiredDatedItemSync');


  }
}
