import 'package:MREPORTING/models/appraisal/appraisal_employee_data_model.dart';
import 'package:MREPORTING/models/appraisal/appraisal_field_Force_data_model.dart';

class AppraisalServices {
  List<FfList> searchEmployee(String enterTheKey, List<FfList> ffList) {
    List<FfList> searchData = ffList;
    List<FfList> results = [];
    if (enterTheKey.isEmpty || enterTheKey == '') {
      results = searchData;
    } else {
      var starts = searchData
          .where((element) =>
              element.empName
                  .toLowerCase()
                  .startsWith(enterTheKey.toLowerCase()) ||
              element.employeeId
                  .toLowerCase()
                  .startsWith(enterTheKey.toLowerCase()) ||
              element.areaId
                  .toLowerCase()
                  .startsWith(enterTheKey.toLowerCase()))
          .toList();
      var contains = searchData
          .where((element) =>
              (element.empName
                      .toLowerCase()
                      .contains(enterTheKey.toLowerCase()) ||
                  element.employeeId
                      .toLowerCase()
                      .contains(enterTheKey.toLowerCase()) ||
                  element.areaId
                      .toLowerCase()
                      .contains(enterTheKey.toLowerCase())) &&
              !(element.empName
                      .toLowerCase()
                      .startsWith(enterTheKey.toLowerCase()) ||
                  element.employeeId
                      .toLowerCase()
                      .startsWith(enterTheKey.toLowerCase()) ||
                  element.areaId
                      .toLowerCase()
                      .startsWith(enterTheKey.toLowerCase())))
          .toList();

      results = [...starts, ...contains];
    }
    //print("result============================$result");
    return results;
  }

  List<DataList> searchFf(String enteredekeye, List<DataList> ffList) {
    List<DataList> searchData = ffList;
    List<DataList> results = [];
    if (enteredekeye.isEmpty || enteredekeye == '') {
      results = searchData;
    } else {
      var starts = searchData
          .where((element) =>
              element.employeeName
                  .toLowerCase()
                  .startsWith(enteredekeye.toLowerCase()) ||
              element.territoryId
                  .toLowerCase()
                  .startsWith(enteredekeye.toLowerCase()))
          .toList();
      var contains = searchData
          .where((element) =>
              (element.employeeName
                      .toLowerCase()
                      .contains(enteredekeye.toLowerCase()) ||
                  element.territoryId
                      .toLowerCase()
                      .contains(enteredekeye.toLowerCase())) &&
              !(element.employeeName
                      .toLowerCase()
                      .startsWith(enteredekeye.toLowerCase()) ||
                  element.territoryId
                      .toLowerCase()
                      .startsWith(enteredekeye.toLowerCase())))
          .toList();

      results = [...starts, ...contains];
    }
    return results;
  }
}
