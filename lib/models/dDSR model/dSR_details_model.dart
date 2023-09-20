// To parse this JSON data, do
//
//     final dsrDetailsModel = dsrDetailsModelFromJson(jsonString);

import 'dart:convert';

DsrDetailsModel dsrDetailsModelFromJson(String str) =>
    DsrDetailsModel.fromJson(json.decode(str));

String dsrDetailsModelToJson(DsrDetailsModel data) =>
    json.encode(data.toJson());

class DsrDetailsModel {
  final ResData resData;

  DsrDetailsModel({
    required this.resData,
  });

  factory DsrDetailsModel.fromJson(Map<String, dynamic> json) =>
      DsrDetailsModel(
        resData: ResData.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
      };
}

class ResData {
  final String status;
  final List<DataList> dataList;

  ResData({
    required this.status,
    required this.dataList,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        dataList: List<DataList>.from(
            json["data_list"].map((x) => DataList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data_list": List<dynamic>.from(dataList.map((x) => x.toJson())),
      };
}

class DataList {
  final String lastAction;
  final String rsmCash;
  final String payMode;
  final String payNOfMonth;
  final String scheduleType;
  final String payToFirstDate;
  final String payFromFirstDate;
  final String noOfPatient;
  final String purposeDurationTo;
  final String purposeDurationFrom;
  final String purposeDes;
  final String purposeSub;
  final String purpose;
  final String dsrType;
  final String submitDate;
  final String sl;
  final String refId;
  final String doctorId;
  final String doctorName;
  final String degree;
  final String specialty;
  final List<BrandList> brandList;
  final String step;
  final String mobile;

  DataList({
    required this.lastAction,
    required this.rsmCash,
    required this.payMode,
    required this.payNOfMonth,
    required this.scheduleType,
    required this.payToFirstDate,
    required this.payFromFirstDate,
    required this.noOfPatient,
    required this.purposeDurationTo,
    required this.purposeDurationFrom,
    required this.purposeDes,
    required this.purposeSub,
    required this.purpose,
    required this.dsrType,
    required this.submitDate,
    required this.sl,
    required this.refId,
    required this.doctorId,
    required this.doctorName,
    required this.degree,
    required this.specialty,
    required this.brandList,
    required this.step,
    required this.mobile,
  });

  factory DataList.fromJson(Map<String, dynamic> json) => DataList(
      lastAction: json["last_action"],
      rsmCash: json["rsm_cash"],
      payMode: json["pay_mode"],
      payNOfMonth: json["pay_n_of_month"],
      scheduleType: json["schedule_type"],
      payToFirstDate: json["pay_to_first_date"],
      payFromFirstDate: json["pay_from_first_date"],
      noOfPatient: json["no_of_patient"],
      purposeDurationTo: json["purpose_duration_to"],
      purposeDurationFrom: json["purpose_duration_from"],
      purposeDes: json["purpose_des"],
      purposeSub: json["purpose_sub"],
      purpose: json["purpose"],
      dsrType: json["dsr_type"],
      submitDate: json["submit_date"],
      sl: json["sl"],
      refId: json["ref_id"],
      doctorId: json["doctor_id"],
      doctorName: json["doctor_name"],
      degree: json["degree"],
      specialty: json["specialty"],
      brandList: List<BrandList>.from(
          json["brand_list"].map((x) => BrandList.fromJson(x))),
      step: json["step"].toString().toUpperCase(),
      mobile: json["doc_mobile"].toString());

  Map<String, dynamic> toJson() => {
        "last_action": lastAction,
        "rsm_cash": rsmCash,
        "pay_mode": payMode,
        "pay_n_of_month": payNOfMonth,
        "schedule_type": scheduleType,
        "pay_to_first_date": payToFirstDate,
        "pay_from_first_date": payFromFirstDate,
        "no_of_patient": noOfPatient,
        "purpose_duration_to": purposeDurationTo,
        "purpose_duration_from": purposeDurationFrom,
        "purpose_des": purposeDes,
        "purpose_sub": purposeSub,
        "purpose": purpose,
        "dsr_type": dsrType,
        "submit_date": submitDate,
        "sl": sl,
        "ref_id": refId,
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "degree": degree,
        "specialty": specialty,
        "brand_list": List<dynamic>.from(brandList.map((x) => x.toJson())),
      };
}

class BrandList {
  final String rowId;
  final String brandName;
  final String brandId;
  final String rxPerDay;
  String amount;
  final String emrx;
  final String fourPRx;

  BrandList({
    required this.rowId,
    required this.brandName,
    required this.brandId,
    required this.rxPerDay,
    required this.amount,
    required this.emrx,
    required this.fourPRx,
  });

  factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
        rowId: json["row_id"],
        brandName: json["brand_name"],
        brandId: json["brand_id"] ?? 'BR1245',
        rxPerDay: json["rx_per_day"].toString(),
        emrx: json["emr_rx"].toString(),
        fourPRx: json["four_p_rx"].toString(),
        amount: json["amount"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "row_id": rowId,
        "brand_name": brandName,
        "brand_id": brandId,
        "rx_per_day": rxPerDay,
        "emr_rx": emrx,
        "four_p_rx": fourPRx,
        "amount": amount,
      };
}
