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
  List<ECMERegionList> eCMERegionList;
  

  ECMESavedDataModel({
    required this.status,
    required this.eCMEBrandList,
    required this.eCMETypeList,
    required this.eCMERegionList,

  });

  factory ECMESavedDataModel.fromJson(Map<String, dynamic> json) => ECMESavedDataModel(
        status: json["status"] ?? "",
        eCMEBrandList: List<ECMEBrandList>.from(
            json["brand_list"].map((x) => ECMEBrandList.fromJson(x)) ?? []),
        eCMETypeList:
            List<String>.from(json["ecme_typeList"].map((x) => x) ?? []),
        eCMERegionList: List<ECMERegionList>.from(
            json["region_list"].map((x) => ECMERegionList.fromJson(x)) ?? []),
       
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "brand_list": List<dynamic>.from(eCMEBrandList.map((x) => x.toJson())),
        "ecme_typeList": List<dynamic>.from(eCMETypeList.map((x) => x)),
        "region_list": List<dynamic>.from(eCMERegionList.map((x) => x.toJson())),
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
class ECMERegionList {
  @HiveField(0)
  final String regionId;
  @HiveField(1)
  final String regionName;
  @HiveField(2)
  final List<ECMEAreaList> eCMEAreaList;

  ECMERegionList({
    required this.regionId,
    required this.regionName,
    required this.eCMEAreaList,
  });

  factory ECMERegionList.fromJson(Map<String, dynamic> json) => ECMERegionList(
        regionId: json["region_id"] ?? "",
        regionName: json["region_name"] ?? "",
        eCMEAreaList: List<ECMEAreaList>.from(
            json["area_list"].map((x) => ECMEAreaList.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "region_id": regionId,
        "region_name": regionName,
        "area_list": List<dynamic>.from(eCMEAreaList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 98)
class ECMEAreaList {
  @HiveField(0)
  final String areaId;
  @HiveField(1)
  final String areaName;
  @HiveField(2)
  final List<ECMETerritoryList> eCMEterritoryList;

  ECMEAreaList({
    required this.areaId,
    required this.areaName,
    required this.eCMEterritoryList,
  });

  factory ECMEAreaList.fromJson(Map<String, dynamic> json) => ECMEAreaList(
        areaId: json["area_id"] ?? "",
        areaName: json["area_name"] ?? "",
        eCMEterritoryList: List<ECMETerritoryList>.from(
            json["territory_list"].map((x) => ECMETerritoryList.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId,
        "area_name": areaName,
        "territory_list":
            List<dynamic>.from(eCMEterritoryList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 99)
class ECMETerritoryList {
  @HiveField(0)
  final String territoryId;
  @HiveField(1)
  final String territoryName;

  ECMETerritoryList({
    required this.territoryId,
    required this.territoryName,
  });

  factory ECMETerritoryList.fromJson(Map<String, dynamic> json) => ECMETerritoryList(
        territoryId: json["territory_id"] ?? "",
        territoryName: json["territory_name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "territory_id": territoryId,
        "territory_name": territoryName,
      };
}

