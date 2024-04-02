// To parse this JSON data, do
//
//     final ecmeApprovalDetailsDataModel = ecmeApprovalDetailsDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EcmeApprovalDetailsDataModel ecmeApprovalDetailsDataModelFromJson(String str) => EcmeApprovalDetailsDataModel.fromJson(json.decode(str));
String ecmeApprovalDetailsDataModelToJson(EcmeApprovalDetailsDataModel data) => json.encode(data.toJson());

class EcmeApprovalDetailsDataModel {
    final EcmeResDataModel resData;

    EcmeApprovalDetailsDataModel({
        required this.resData,
    });

    factory EcmeApprovalDetailsDataModel.fromJson(Map<String, dynamic> json) => EcmeApprovalDetailsDataModel(
        resData: EcmeResDataModel.fromJson(json["res_data"]),
    );

    Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
    };
}

class EcmeResDataModel {
    final String status;
    final List<ECMEApprovalDataList> dataList;

    EcmeResDataModel({
        required this.status,
        required this.dataList,
    });

    factory EcmeResDataModel.fromJson(Map<String, dynamic> json) => EcmeResDataModel(
        status: json["status"],
        dataList: List<ECMEApprovalDataList>.from(json["data_list"].map((x) => ECMEApprovalDataList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data_list": List<dynamic>.from(dataList.map((x) => x.toJson())),
    };
}

class ECMEApprovalDataList {
     final String ecmeAmount;
    final DateTime meetingDate;
    final String ecmeDoctorCategory;
    final String institutionName;
    final String department;
    final String meetingVenue;
    final String meetingTopic;
    final String probableSpeakerName;
    final String probableSpeakerDesignation;
    final String totalNumbersOfParticipants;
    final String totalBudget;
    final String hallRent;
    final String costPerDoctor;
    final String foodExpense;
    final String stationnaires;
    final String giftsSouvenirs;
    final String doctorsCount;
    final String internDoctors;
    final String dmfDoctors;
    final String nurses;
    final String lastAction;
    final String ecmeType;
    final String submitDate;
    final String sl;
    final String doctorId;
    final String doctorName;
    final String degree;
    final String specialty;
    final String doctorsCategory;
    final String docMobile;
    final String step;
    final String rxPerDay;
     List<EcmeBrandListDataModel> brandList;

    ECMEApprovalDataList({
        required this.ecmeAmount,
        required this.meetingDate,
        required this.ecmeDoctorCategory,
        required this.institutionName,
        required this.department,
        required this.meetingVenue,
        required this.meetingTopic,
        required this.probableSpeakerName,
        required this.probableSpeakerDesignation,
        required this.totalNumbersOfParticipants,
        required this.totalBudget,
        required this.hallRent,
        required this.costPerDoctor,
        required this.foodExpense,
        required this.stationnaires,
        required this.giftsSouvenirs,
        required this.doctorsCount,
        required this.internDoctors,
        required this.dmfDoctors,
        required this.nurses,
        required this.lastAction,
        required this.ecmeType,
        required this.submitDate,
        required this.sl,
        required this.doctorId,
        required this.doctorName,
        required this.degree,
        required this.specialty,
        required this.doctorsCategory,
        required this.docMobile,
        required this.step,
        required this.rxPerDay,
        required this.brandList,
    });

    factory ECMEApprovalDataList.fromJson(Map<String, dynamic> json) => ECMEApprovalDataList(
        ecmeAmount: json["ecme_amount"],
        meetingDate: DateTime.parse(json["meeting_date"]),
        ecmeDoctorCategory: json["ecme_doctor_category"],
        institutionName: json["institution_name"],
        department: json["department"],
        meetingVenue: json["meeting_venue"],
        meetingTopic: json["meeting_topic"],
        probableSpeakerName: json["probable_speaker_name"],
        probableSpeakerDesignation: json["probable_speaker_designation"],
        totalNumbersOfParticipants: json["total_numbers_of_participants"],
        totalBudget: json["total_budget"],
        hallRent: json["hall_rent"],
        costPerDoctor: json["cost_per_doctor"],
        foodExpense: json["food_expense"],
        stationnaires: json["stationnaires"],
        giftsSouvenirs: json["gifts_souvenirs"],
        doctorsCount: json["doctors_count"],
        internDoctors: json["intern_doctors"],
        dmfDoctors: json["dmf_doctors"],
        nurses: json["nurses"],
        lastAction: json["last_action"],
        ecmeType: json["ecme_type"],
        submitDate: json["submit_date"],
        sl: json["sl"],
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        degree: json["degree"],
        specialty: json["specialty"],
        doctorsCategory: json["doctors_category"],
        docMobile: json["doc_mobile"],
        step: json["step"],
        rxPerDay: json["rx_per_day"],
        brandList: List<EcmeBrandListDataModel>.from(json["brand_list"].map((x) => EcmeBrandListDataModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ecme_amount": ecmeAmount,
        "meeting_date": "${meetingDate.year.toString().padLeft(4, '0')}-${meetingDate.month.toString().padLeft(2, '0')}-${meetingDate.day.toString().padLeft(2, '0')}",
        "ecme_doctor_category": ecmeDoctorCategory,
        "institution_name": institutionName,
        "department": department,
        "meeting_venue": meetingVenue,
        "meeting_topic": meetingTopic,
        "probable_speaker_name": probableSpeakerName,
        "probable_speaker_designation": probableSpeakerDesignation,
        "total_numbers_of_participants": totalNumbersOfParticipants,
        "total_budget": totalBudget,
        "hall_rent": hallRent,
        "cost_per_doctor": costPerDoctor,
        "food_expense": foodExpense,
        "stationnaires": stationnaires,
        "gifts_souvenirs": giftsSouvenirs,
        "doctors_count": doctorsCount,
        "intern_doctors": internDoctors,
        "dmf_doctors": dmfDoctors,
        "nurses": nurses,
        "last_action": lastAction,
        "ecme_type": ecmeType,
        "submit_date": submitDate,
        "sl": sl,
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "degree": degree,
        "specialty": specialty,
        "doctors_category": doctorsCategory,
        "doc_mobile": docMobile,
        "step": step,
        "rx_per_day":rxPerDay,
        "brand_list": List<dynamic>.from(brandList.map((x) => x.toJson())),
    };
}

class EcmeBrandListDataModel {
    final String rowId;
    final String brandId;
    final String brandName;
    final String salesQty;

    EcmeBrandListDataModel({
        required this.rowId,
        required this.brandId,
        required this.brandName,
        required this.salesQty,
    });

    factory EcmeBrandListDataModel.fromJson(Map<String, dynamic> json) => EcmeBrandListDataModel(
        rowId: json["row_id"],
        brandId: json["brand_id"],
        brandName: json["brand_name"],
        salesQty: json["sales_qty"],
    );

    Map<String, dynamic> toJson() => {
        "row_id": rowId,
        "brand_id": brandId,
        "brand_name": brandName,
        "sales_qty": salesQty,
    };
}
