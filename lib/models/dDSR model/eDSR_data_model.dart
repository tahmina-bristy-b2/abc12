import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

part 'eDSR_data_model.g.dart';

EdsrDataModel edsrDataModelFromJson(String str) =>
    EdsrDataModel.fromJson(json.decode(str));

String edsrDataModelToJson(EdsrDataModel data) => json.encode(data.toJson());

@HiveType(typeId: 60)
class EdsrDataModel extends HiveObject {
  @HiveField(0)
  final String status;
  @HiveField(1)
  final List<CategoryList> categoryList;
  @HiveField(2)
  final List<BrandList> brandList;
  @HiveField(3)
  final List<String> payScheduleList;
  @HiveField(4)
  final List<String> payModeList;
  @HiveField(5)
  final List<PurposeList> purposeList;
  @HiveField(6)
  final List<SubPurposeList> subPurposeList;
  @HiveField(7)
  final List<String> dsrTypeList;
  @HiveField(8)
  final List<RegionList> regionList;
  @HiveField(9)
  final List<RxDurationMonthList> rxDurationMonthList;
  @HiveField(10)
  final List<DsrDurationMonthList> dsrDurationMonthList;

  EdsrDataModel({
    required this.status,
    required this.categoryList,
    required this.brandList,
    required this.payScheduleList,
    required this.payModeList,
    required this.purposeList,
    required this.subPurposeList,
    required this.dsrTypeList,
    required this.regionList,
    required this.rxDurationMonthList,
    required this.dsrDurationMonthList,
  });

  factory EdsrDataModel.fromJson(Map<String, dynamic> json) => EdsrDataModel(
        status: json["status"],
        categoryList: List<CategoryList>.from(
            json["category_list"].map((x) => CategoryList.fromJson(x))),
        brandList: List<BrandList>.from(
            json["brand_list"].map((x) => BrandList.fromJson(x))),
        payScheduleList:
            List<String>.from(json["payScheduleList"].map((x) => x)),
        payModeList: List<String>.from(json["payModeList"].map((x) => x)),
        purposeList: List<PurposeList>.from(
            json["purpose_list"].map((x) => PurposeList.fromJson(x))),
        subPurposeList: List<SubPurposeList>.from(
            json["sub_purpose_list"].map((x) => SubPurposeList.fromJson(x))),
        dsrTypeList: List<String>.from(json["dsr_typeList"].map((x) => x)),
        regionList: List<RegionList>.from(
            json["region_list"].map((x) => RegionList.fromJson(x))),
        rxDurationMonthList: List<RxDurationMonthList>.from(
            json["rxDurationMonthList"]
                .map((x) => RxDurationMonthList.fromJson(x))),
        dsrDurationMonthList: List<DsrDurationMonthList>.from(
            json["dsrDurationMonthList"]
                .map((x) => DsrDurationMonthList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "category_list":
            List<dynamic>.from(categoryList.map((x) => x.toJson())),
        "brand_list": List<dynamic>.from(brandList.map((x) => x.toJson())),
        "payScheduleList": List<dynamic>.from(payScheduleList.map((x) => x)),
        "payModeList": List<dynamic>.from(payModeList.map((x) => x)),
        "purpose_list": List<dynamic>.from(purposeList.map((x) => x.toJson())),
        "sub_purpose_list":
            List<dynamic>.from(subPurposeList.map((x) => x.toJson())),
        "dsr_typeList": List<dynamic>.from(dsrTypeList.map((x) => x)),
        "region_list": List<dynamic>.from(regionList.map((x) => x.toJson())),
        "rxDurationMonthList":
            List<dynamic>.from(rxDurationMonthList.map((x) => x.toJson())),
        "dsrDurationMonthList":
            List<dynamic>.from(dsrDurationMonthList.map((x) => x.toJson())),
      };
}

// class PurposeList {
// }
@HiveType(typeId: 61)
class BrandList {
  @HiveField(0)
  final String brandId;
  @HiveField(1)
  final String brandName;

  BrandList({
    required this.brandId,
    required this.brandName,
  });

  factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
        brandId: json["brand_id"],
        brandName: json["brand_name"],
      );

  Map<String, dynamic> toJson() => {
        "brand_id": brandId,
        "brand_name": brandName,
      };
}

@HiveType(typeId: 62)
class CategoryList {
  @HiveField(0)
  final String catId;
  @HiveField(1)
  final String category;

  CategoryList({
    required this.catId,
    required this.category,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        catId: json["cat_id"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "cat_id": catId,
        "category": category,
      };
}

@HiveType(typeId: 63)
class RegionList {
  @HiveField(0)
  final String regionId;
  @HiveField(1)
  final String regionName;
  @HiveField(2)
  final List<AreaList> areaList;

  RegionList({
    required this.regionId,
    required this.regionName,
    required this.areaList,
  });

  factory RegionList.fromJson(Map<String, dynamic> json) => RegionList(
        regionId: json["region_id"],
        regionName: json["region_name"],
        areaList: List<AreaList>.from(
            json["area_list"].map((x) => AreaList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "region_id": regionId,
        "region_name": regionName,
        "area_list": List<dynamic>.from(areaList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 64)
class AreaList {
  @HiveField(0)
  final String areaId;
  @HiveField(1)
  final String areaName;
  @HiveField(2)
  final List<TerritoryList> territoryList;

  AreaList({
    required this.areaId,
    required this.areaName,
    required this.territoryList,
  });

  factory AreaList.fromJson(Map<String, dynamic> json) => AreaList(
        areaId: json["area_id"],
        areaName: json["area_name"],
        territoryList: List<TerritoryList>.from(
            json["territory_list"].map((x) => TerritoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId,
        "area_name": areaName,
        "territory_list":
            List<dynamic>.from(territoryList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 65)
class TerritoryList {
  @HiveField(0)
  final String territoryId;
  @HiveField(1)
  final String territoryName;

  TerritoryList({
    required this.territoryId,
    required this.territoryName,
  });

  factory TerritoryList.fromJson(Map<String, dynamic> json) => TerritoryList(
        territoryId: json["territory_id"],
        territoryName: json["territory_name"],
      );

  Map<String, dynamic> toJson() => {
        "territory_id": territoryId,
        "territory_name": territoryName,
      };
}

@HiveType(typeId: 66)
class PurposeList {
  @HiveField(0)
  final String dsrType;
  @HiveField(1)
  final String dsrCategory;
  @HiveField(2)
  final String purposeId;
  @HiveField(3)
  final String purposeName;

  PurposeList({
    required this.dsrType,
    required this.dsrCategory,
    required this.purposeId,
    required this.purposeName,
  });

  factory PurposeList.fromJson(Map<String, dynamic> json) => PurposeList(
        dsrType: json["dsr_type"],
        dsrCategory: json["dsr_category"],
        purposeId: json["purpose_id"],
        purposeName: json["purpose_name"],
      );

  Map<String, dynamic> toJson() => {
        "dsr_type": dsrType,
        "dsr_category": dsrCategory,
        "purpose_id": purposeId,
        "purpose_name": purposeName,
      };
}

@HiveType(typeId: 67)
class SubPurposeList {
  @HiveField(0)
  final String sDsrType;
  @HiveField(1)
  final String sDsrCategory;
  @HiveField(2)
  final String sPurposeId;
  @HiveField(3)
  final String sPurposeName;
  @HiveField(4)
  final String sPurposeSubId;
  @HiveField(5)
  final String sPurposeSubName;

  SubPurposeList({
    required this.sDsrType,
    required this.sDsrCategory,
    required this.sPurposeId,
    required this.sPurposeName,
    required this.sPurposeSubId,
    required this.sPurposeSubName,
  });

  factory SubPurposeList.fromJson(Map<String, dynamic> json) => SubPurposeList(
        sDsrType: json["s_dsr_type"],
        sDsrCategory: json["s_dsr_category"],
        sPurposeId: json["s_purpose_id"],
        sPurposeName: json["s_purpose_name"],
        sPurposeSubId: json["s_purpose_sub_id"],
        sPurposeSubName: json["s_purpose_sub_name"],
      );

  Map<String, dynamic> toJson() => {
        "s_dsr_type": sDsrType,
        "s_dsr_category": sDsrCategory,
        "s_purpose_id": sPurposeId,
        "s_purpose_name": sPurposeName,
        "s_purpose_sub_id": sPurposeSubId,
        "s_purpose_sub_name": sPurposeSubName,
      };
}

@HiveType(typeId: 68)
class RxDurationMonthList {
  @HiveField(0)
  final String nextDate;
  @HiveField(1)
  final String nextDateV;

  RxDurationMonthList({
    required this.nextDate,
    required this.nextDateV,
  });

  factory RxDurationMonthList.fromJson(Map<String, dynamic> json) =>
      RxDurationMonthList(
        nextDate: json["nextDate"],
        nextDateV: json["nextDateV"],
      );

  Map<String, dynamic> toJson() => {
        "nexDate": nextDate,
        "nextDateV": nextDateV,
      };
}

@HiveType(typeId: 69)
class DsrDurationMonthList {
  @HiveField(0)
  final String nextDate;
  @HiveField(1)
  final String nextDateV;

  DsrDurationMonthList({
    required this.nextDate,
    required this.nextDateV,
  });

  factory DsrDurationMonthList.fromJson(Map<String, dynamic> json) =>
      DsrDurationMonthList(
        nextDate: json["nextDate"],
        nextDateV: json["nextDateV"],
      );

  Map<String, dynamic> toJson() => {
        "nexDate": nextDate,
        "nextDateV": nextDateV,
      };
}
