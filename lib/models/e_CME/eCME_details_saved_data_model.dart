import 'package:MREPORTING_OFFLINE/models/e_CME/e_CME_doctor_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

part 'eCME_details_saved_data_model.g.dart';

ECMESavedDataModel eCMEDataModelFromJson(String str) =>
    ECMESavedDataModel.fromJson(json.decode(str));

String eCMEDataModelToJson(ECMESavedDataModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 95)
class ECMESavedDataModel extends HiveObject {
  @HiveField(0)
  String status;
  @HiveField(1)
  List<ECMEBrandList> eCMEBrandList;
  @HiveField(2)
  List<String> eCMETypeList;
  @HiveField(3)
  final List<DocListECMEModel> eCMEdocList;
  @HiveField(4)
  final List<String> payModeList;
  @HiveField(5)
  final List<String> docCategoryList;
  @HiveField(6)
  final String supAreaId;
  @HiveField(7)
  final List<String> departmentList;
  @HiveField(8)
  final List<String> payToDataList;

  ECMESavedDataModel(
      {required this.status,
      required this.eCMEBrandList,
      required this.eCMETypeList,
      required this.eCMEdocList,
      required this.docCategoryList,
      required this.payModeList,
      required this.supAreaId,
      required this.departmentList,
      required this.payToDataList});
  factory ECMESavedDataModel.fromJson(Map<String, dynamic> json) =>
      ECMESavedDataModel(
          status: json["status"] ?? "",
          eCMEBrandList: List<ECMEBrandList>.from(
              json["brand_list"].map((x) => ECMEBrandList.fromJson(x)) ?? []),
          eCMETypeList:
              List<String>.from(json["ecme_typeList"].map((x) => x) ?? []),
          eCMEdocList: List<DocListECMEModel>.from(
              json["doc_list"].map((x) => DocListECMEModel.fromJson(x))),
          payModeList: List<String>.from(json["payModeList"].map((x) => x)),
          docCategoryList: List<String>.from(json["doc_category_list"].map((x) =>
              x)),
          supAreaId: json["sup_area_id"] ?? "",
          departmentList:
              List<String>.from(json["doc_department"].map((x) => x) ?? []),
          payToDataList:
              List<String>.from(json["payToList"].map((x) => x) ?? []));

  Map<String, dynamic> toJson() => {
        "status": status,
        "brand_list": List<dynamic>.from(eCMEBrandList.map((x) => x.toJson())),
        "ecme_typeList": List<dynamic>.from(eCMETypeList.map((x) => x)),
        "doc_list": List<dynamic>.from(eCMEdocList.map((x) => x.toJson())),
        "payModeList": List<dynamic>.from(payModeList.map((x) => x)),
        "doc_category_list": List<dynamic>.from(docCategoryList.map((x) => x)),
        "sup_area_id": supAreaId,
        "doc_department": List<dynamic>.from(departmentList.map((x) => x)),
        "payToList": List<dynamic>.from(payToDataList.map((x) => x)),
      };
}

@HiveType(typeId: 96)
class ECMEBrandList {
  @HiveField(0)
  final String brandId;
  @HiveField(1)
  final String brandName;

  ECMEBrandList({
    required this.brandId,
    required this.brandName,
  });

  factory ECMEBrandList.fromJson(Map<String, dynamic> json) => ECMEBrandList(
        brandId: json["brand_id"] ?? '',
        brandName: json["brand_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "brand_id": brandId,
        "brand_name": brandName,
      };
}
