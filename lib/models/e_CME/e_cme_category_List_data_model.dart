import 'dart:convert';

import 'package:hive/hive.dart';
part 'e_cme_category_List_data_model.g.dart';

EcmeDoctorCategoryDataModel ecmeDoctorCategoryDataModelFromJson(String str) =>
    EcmeDoctorCategoryDataModel.fromJson(json.decode(str));

String ecmeDoctorCategoryDataModelToJson(EcmeDoctorCategoryDataModel data) =>
    json.encode(data.toJson());

class EcmeDoctorCategoryDataModel {
  final DoctorCategoryRestData resData;

  EcmeDoctorCategoryDataModel({
    required this.resData,
  });

  factory EcmeDoctorCategoryDataModel.fromJson(Map<String, dynamic> json) =>
      EcmeDoctorCategoryDataModel(
        resData: DoctorCategoryRestData.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
      };
}

@HiveType(typeId: 99)
class DoctorCategoryRestData extends HiveObject {
  @HiveField(0)
  final String status;
  @HiveField(1)
  final List<String> docSpecialtyList;

  DoctorCategoryRestData({
    required this.status,
    required this.docSpecialtyList,
  });

  factory DoctorCategoryRestData.fromJson(Map<String, dynamic> json) =>
      DoctorCategoryRestData(
        status: json["status"],
        docSpecialtyList:
            List<String>.from(json["doc_specialty_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "doc_specialty_list":
            List<dynamic>.from(docSpecialtyList.map((x) => x)),
      };
}
