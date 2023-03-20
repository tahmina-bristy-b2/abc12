// To parse this JSON data, do
//
//     final doctorEditModel = doctorEditModelFromJson(jsonString);

import 'dart:convert';

DoctorEditModel doctorEditModelFromJson(String str) =>
    DoctorEditModel.fromJson(json.decode(str));

String doctorEditModelToJson(DoctorEditModel data) =>
    json.encode(data.toJson());

class DoctorEditModel {
  DoctorEditModel({
    required this.status,
    required this.docRecords,
  });

  final String status;
  final List<DocRecord> docRecords;

  factory DoctorEditModel.fromJson(Map<String, dynamic> json) =>
      DoctorEditModel(
        status: json["status"],
        docRecords: List<DocRecord>.from(
            json["docRecords"].map((x) => DocRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "docRecords": List<dynamic>.from(docRecords.map((x) => x.toJson())),
      };
}

class DocRecord {
  DocRecord({
    required this.areaId,
    required this.arroundChemistId,
    required this.thirdPartyId,
    required this.fourPDocAddress,
    required this.marDay,
    required this.doctorsCategory,
    required this.district,
    required this.clientName,
    required this.thana,
    required this.dobChild2,
    required this.collarSize,
    required this.dobChild1,
    required this.brand,
    required this.degree,
    required this.areaName,
    required this.specialty,
    required this.docName,
    required this.latitude,
    required this.clientId,
    required this.address,
    required this.postGrandDegree,
    required this.nop,
    required this.fourPDocName,
    required this.addressType,
    required this.designation,
    required this.dob,
    required this.dCategory,
    required this.longitude,
    required this.mobile,
    required this.docId,
    required this.fourPDocSpecialty,
    required this.depotId,
  });

  final String areaId;
  final String arroundChemistId;
  final String thirdPartyId;
  final String fourPDocAddress;
  final String marDay;
  final String doctorsCategory;
  final String district;
  final String clientName;
  final String thana;
  final String dobChild2;
  final String collarSize;
  final String dobChild1;
  final String brand;
  final String degree;
  final String areaName;
  final String specialty;
  final String docName;
  final String latitude;
  final String clientId;
  final String address;
  final String postGrandDegree;
  final int nop;
  final String fourPDocName;
  final String addressType;
  final String designation;
  final String dob;
  final String dCategory;
  final String longitude;
  final int mobile;
  final String docId;
  final String fourPDocSpecialty;
  final String depotId;

  factory DocRecord.fromJson(Map<String, dynamic> json) => DocRecord(
        areaId: json["area_id"],
        arroundChemistId: json["arround_chemist_id"],
        thirdPartyId: json["third_party_id"],
        fourPDocAddress: json["fourP_doc_address"],
        marDay: json["mar_day"],
        doctorsCategory: json["doctors_category"],
        district: json["district"],
        clientName: json["client_name"],
        thana: json["thana"],
        dobChild2: json["dob_child2"],
        collarSize: json["collar_size"],
        dobChild1: json["dob_child1"],
        brand: json["brand"],
        degree: json["degree"],
        areaName: json["area_name"],
        specialty: json["specialty"],
        docName: json["doc_name"],
        latitude: json["latitude"],
        clientId: json["client_id"],
        address: json["address"],
        postGrandDegree: json["post_grand_degree"],
        nop: json["nop"],
        fourPDocName: json["fourP_doc_name"],
        addressType: json["address_type"],
        designation: json["designation"],
        dob: json["dob"],
        dCategory: json["d_category"],
        longitude: json["longitude"],
        mobile: json["mobile"],
        docId: json["doc_id"],
        fourPDocSpecialty: json["fourP_doc_specialty"],
        depotId: json["depot_id"],
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId,
        "arround_chemist_id": arroundChemistId,
        "third_party_id": thirdPartyId,
        "fourP_doc_address": fourPDocAddress,
        "mar_day": marDay,
        // "mar_day": "${marDay.year.toString().padLeft(4, '0')}-${marDay.month.toString().padLeft(2, '0')}-${marDay.day.toString().padLeft(2, '0')}",
        "doctors_category": doctorsCategory,
        "district": district,
        "client_name": clientName,
        "thana": thana,
        "dob_child2": dobChild2,
        "collar_size": collarSize,
        "dob_child1": dobChild1,
        "brand": brand,
        "degree": degree,
        "area_name": areaName,
        "specialty": specialty,
        "doc_name": docName,
        "latitude": latitude,
        "client_id": clientId,
        "address": address,
        "post_grand_degree": postGrandDegree,
        "nop": nop,
        "fourP_doc_name": fourPDocName,
        "address_type": addressType,
        "designation": designation,
        "dob": dob,
        "d_category": dCategory,
        "longitude": longitude,
        "mobile": mobile,
        "doc_id": docId,
        "fourP_doc_specialty": fourPDocSpecialty,
        "depot_id": depotId,
      };
}
