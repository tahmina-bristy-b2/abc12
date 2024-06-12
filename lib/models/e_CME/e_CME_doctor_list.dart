import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'e_CME_doctor_list.g.dart';

EcmeTerritoryWiseDoctorModel doctorListDatafromjson(String str) =>
    EcmeTerritoryWiseDoctorModel.fromJson(json.decode(str));

String doctorListDataTojson(EcmeTerritoryWiseDoctorModel data) =>
    json.encode(data.toJson());

class EcmeTerritoryWiseDoctorModel {
  final EcmeTerritoryRestDoctorModel resData;

  EcmeTerritoryWiseDoctorModel({
    required this.resData,
  });

  factory EcmeTerritoryWiseDoctorModel.fromJson(Map<String, dynamic> json) =>
      EcmeTerritoryWiseDoctorModel(
        resData: EcmeTerritoryRestDoctorModel.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
      };
}

@HiveType(typeId: 97)
class EcmeTerritoryRestDoctorModel extends HiveObject {
  @HiveField(0)
  final String status;
  @HiveField(1)
  final List<DocListECMEModel> docList;

  EcmeTerritoryRestDoctorModel({
    required this.status,
    required this.docList,
  });

  factory EcmeTerritoryRestDoctorModel.fromJson(Map<String, dynamic> json) =>
      EcmeTerritoryRestDoctorModel(
        status: json["status"],
        docList: List<DocListECMEModel>.from(
            json["doc_list"].map((x) => DocListECMEModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "doc_list": List<dynamic>.from(docList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 102)
class DocListECMEModel extends HiveObject {
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

  factory DocListECMEModel.fromJson(Map<String, dynamic> json) =>
      DocListECMEModel(
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
