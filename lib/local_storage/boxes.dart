import 'package:hive/hive.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';

class Boxes {
  static Box<AddItemModel> getDraftOrderedData() => Hive.box('orderedItem');
  static Box<CustomerDataModel> getCustomerUsers() => Hive.box('customerHive');
  static Box<DcrDataModel> dcrUsers() => Hive.box('selectedDcr');
  static Box<DcrGSPDataModel> selectedDcrGSP() => Hive.box('selectedDcrGSP');
  static Box<RxDcrDataModel> rxdDoctor() => Hive.box('RxdDoctor');
  static Box<MedicineListModel> getMedicine() => Hive.box('draftMdicinList');
}
