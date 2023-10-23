import 'package:MREPORTING/models/appraisal/appraisal_employee_data_model.dart';

class AppraisalServices {
  List<FfList> searchEmployee(String enteredekeye, List<FfList> ffList) {
    List<FfList> searchData = ffList;
    List<FfList> results = [];
    if (enteredekeye.isEmpty || enteredekeye == '') {
      results = searchData;
    } else {
      var starts = searchData
          .where((element) =>
              element.empName
                  .toLowerCase()
                  .startsWith(enteredekeye.toLowerCase()) ||
              element.employeeId
                  .toLowerCase()
                  .startsWith(enteredekeye.toLowerCase()) ||
              element.areaId
                  .toLowerCase()
                  .startsWith(enteredekeye.toLowerCase()))
          .toList();
      var contains = searchData
          .where((element) =>
              (element.empName
                      .toLowerCase()
                      .contains(enteredekeye.toLowerCase()) ||
                  element.employeeId
                      .toLowerCase()
                      .contains(enteredekeye.toLowerCase()) ||
                  element.areaId
                      .toLowerCase()
                      .contains(enteredekeye.toLowerCase())) &&
              !(element.empName
                      .toLowerCase()
                      .startsWith(enteredekeye.toLowerCase()) ||
                  element.employeeId
                      .toLowerCase()
                      .startsWith(enteredekeye.toLowerCase()) ||
                  element.areaId
                      .toLowerCase()
                      .startsWith(enteredekeye.toLowerCase())))
          .toList();

      results = [...starts, ...contains];
    }
    return results;
  }
}
