// To parse this JSON data, do
//
//     final docSettingsModel = docSettingsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DocSettingsModel docSettingsModelFromJson(String str) =>
    DocSettingsModel.fromJson(json.decode(str));

String docSettingsModelToJson(DocSettingsModel data) =>
    json.encode(data.toJson());

class DocSettingsModel {
  DocSettingsModel({
    required this.resData,
  });

  final ResData resData;

  factory DocSettingsModel.fromJson(Map<String, dynamic> json) =>
      DocSettingsModel(
        resData: ResData.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
      };
}

class ResData {
  ResData({
    required this.status,
    required this.dCategoryList,
    required this.collarSizeList,
    required this.distThanaList,
    required this.docCategoryList,
    required this.docSpecialtyList,
    required this.docDegreeList,
    required this.brandList,
    required this.docTypeList,
  });

  final String status;
  final List<String> dCategoryList;
  final List<String> collarSizeList;
  final List<DistThanaList> distThanaList;
  final List<String> docCategoryList;
  final List<String> docSpecialtyList;
  final List<String> docDegreeList;
  final List<BrandList> brandList;
  final List<String> docTypeList;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        dCategoryList: List<String>.from(json["d_category_list"].map((x) => x)),
        collarSizeList:
            List<String>.from(json["collar_size_list"].map((x) => x)),
        distThanaList: List<DistThanaList>.from(
            json["dist_thana_list"].map((x) => DistThanaList.fromJson(x))),
        docCategoryList:
            List<String>.from(json["doc_category_list"].map((x) => x)),
        docSpecialtyList:
            List<String>.from(json["doc_specialty_list"].map((x) => x)),
        docDegreeList: List<String>.from(json["doc_degree_list"].map((x) => x)),
        brandList: List<BrandList>.from(
            json["brand_list"].map((x) => BrandList.fromJson(x))),
        docTypeList: List<String>.from(json["doc_type_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "d_category_list": List<dynamic>.from(dCategoryList.map((x) => x)),
        "collar_size_list": List<dynamic>.from(collarSizeList.map((x) => x)),
        "dist_thana_list":
            List<dynamic>.from(distThanaList.map((x) => x.toJson())),
        "doc_category_list": List<dynamic>.from(docCategoryList.map((x) => x)),
        "doc_specialty_list":
            List<dynamic>.from(docSpecialtyList.map((x) => x)),
        "doc_degree_list": List<dynamic>.from(docDegreeList.map((x) => x)),
        "brand_list": List<dynamic>.from(brandList.map((x) => x.toJson())),
        "doc_type_list": List<dynamic>.from(docTypeList.map((x) => x)),
      };
}

class BrandList {
  BrandList({
    required this.brandId,
    required this.brandName,
  });

  final String brandId;
  final String brandName;

  factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
        brandId: json["brand_id"],
        brandName: json["brand_name"],
      );

  Map<String, dynamic> toJson() => {
        "brand_id": brandId,
        "brand_name": brandName,
      };
}

class DistThanaList {
  DistThanaList({
    required this.districtName,
    required this.thanaList,
    required this.districtId,
  });

  final String districtName;
  final List<ThanaList> thanaList;
  final String districtId;

  factory DistThanaList.fromJson(Map<String, dynamic> json) => DistThanaList(
        districtName: json["district_name"],
        thanaList: List<ThanaList>.from(
            json["thana_list"].map((x) => ThanaList.fromJson(x))),
        districtId: json["district_id"],
      );

  Map<String, dynamic> toJson() => {
        "district_name": districtName,
        "thana_list": List<dynamic>.from(thanaList.map((x) => x.toJson())),
        "district_id": districtId,
      };
}

class ThanaList {
  ThanaList({
    required this.thanaId,
    required this.thanaName,
  });

  final String thanaId;
  final String thanaName;

  factory ThanaList.fromJson(Map<String, dynamic> json) => ThanaList(
        thanaId: json["thana_id"],
        thanaName: json["thana_name"],
      );

  Map<String, dynamic> toJson() => {
        "thana_id": thanaId,
        "thana_name": thanaName,
      };
}
