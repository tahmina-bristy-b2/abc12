import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

part 'eCME_details_saved_data_model.g.dart';

ECMESavedDataModel eCMEDataModelFromJson(String str) =>
    ECMESavedDataModel.fromJson(json.decode(str));

String eCMEDataModelToJson(ECMESavedDataModel data) => json.encode(data.toJson());

@HiveType(typeId:95 )
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

  ECMESavedDataModel({
    required this.status,
    required this.eCMEBrandList,
    required this.eCMETypeList,
    required this.eCMEdocList,
    required this.docCategoryList,
    required this.payModeList
  });
  factory ECMESavedDataModel.fromJson(Map<String, dynamic> json) => ECMESavedDataModel(
        status: json["status"] ?? "",
        eCMEBrandList: List<ECMEBrandList>.from(
            json["brand_list"].map((x) => ECMEBrandList.fromJson(x)) ?? []),
        eCMETypeList:
            List<String>.from(json["ecme_typeList"].map((x) => x) ?? []),
        eCMEdocList: List<DocListECMEModel>.from(json["doc_list"].map((x) => DocListECMEModel.fromJson(x))),
        payModeList: List<String>.from(json["payModeList"].map((x) => x)),
        docCategoryList: List<String>.from(json["doc_category_list"].map((x) => x)),   
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "brand_list": List<dynamic>.from(eCMEBrandList.map((x) => x.toJson())),
        "ecme_typeList": List<dynamic>.from(eCMETypeList.map((x) => x)),
        "doc_list": List<dynamic>.from(eCMEdocList.map((x) => x.toJson())),
        "payModeList": List<dynamic>.from(payModeList.map((x) => x)),
        "doc_category_list": List<dynamic>.from(docCategoryList.map((x) => x)),  
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

 @HiveType(typeId: 97)
class DocListECMEModel {
  @HiveField(0)
    final String docId;
    @HiveField(1)
    final String docName;
    @HiveField(2)
    final String areaId;
    @HiveField(3)
    final String areaName;
    @HiveField(4)
    final String address;
    @HiveField(5)
    final String thirdPartyId;
    @HiveField(6)
    final String degree;
    @HiveField(7)
    final String specialty;
    @HiveField(8)
    final String mobile;

    DocListECMEModel({
        required this.docId,
        required this.docName,
        required this.areaId,
        required this.areaName,
        required this.address,
        required this.thirdPartyId,
        required this.degree,
        required this.specialty,
        required this.mobile,
    });

    factory DocListECMEModel.fromJson(Map<String, dynamic> json) => DocListECMEModel(
        docId: json["doc_id"],
        docName: json["doc_name"],
        areaId: json["area_id"],
        areaName: json["area_name"],
        address: json["address"],
        thirdPartyId: json["third_party_id"],
        degree: json["degree"],
        specialty: json["specialty"],
        mobile: json["mobile"],
    );

    Map<String, dynamic> toJson() => {
        "doc_id": docId,
        "doc_name": docName,
        "area_id": areaId,
        "area_name": areaName,
        "address": address,
        "third_party_id": thirdPartyId,
        "degree": degree,
        "specialty": specialty,
        "mobile": mobile,
    };
}
