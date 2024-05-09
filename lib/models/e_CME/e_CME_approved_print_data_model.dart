import 'package:meta/meta.dart';
import 'dart:convert';

ApprovedPrintDataModel approvedPrintDataModelFromJson(String str) => ApprovedPrintDataModel.fromJson(json.decode(str));

String approvedPrintDataModelToJson(ApprovedPrintDataModel data) => json.encode(data.toJson());

class ApprovedPrintDataModel {
    final ECMEPrintRetData resData;

    ApprovedPrintDataModel({
        required this.resData,
    });

    factory ApprovedPrintDataModel.fromJson(Map<String, dynamic> json) => ApprovedPrintDataModel(
        resData: ECMEPrintRetData.fromJson(json["res_data"]),
    );

    Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
    };
}

class ECMEPrintRetData {
    final String status;
    final String rsmId;
    final String rsmName;
    final String supLevelIds;
    final String fromDt;
    final String toDt;
    final String message;
    final List<DataListPrint> dataListPrint;

    ECMEPrintRetData({
        required this.status,
        required this.rsmId,
        required this.rsmName,
        required this.supLevelIds,
        required this.fromDt,
        required this.toDt,
        required this.message,
        required this.dataListPrint,
    });

    factory ECMEPrintRetData.fromJson(Map<String, dynamic> json) => ECMEPrintRetData(
        status: json["status"]??"",
        rsmId: json["rsm_id"]??"",
        rsmName: json["rsm_name"]??"",
        supLevelIds: json["sup_level_ids"]??"",
        fromDt: json["from_dt"]??"",
        toDt: json["to_dt"]??"",
        message: json["Massage"]??"",
        dataListPrint: List<DataListPrint>.from(json["data_list"].map((x) => DataListPrint.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "rsm_id": rsmId,
        "rsm_name": rsmName,
        "sup_level_ids": supLevelIds,
        "from_dt": fromDt,
        "to_dt": toDt,
        "Massage":message,
        "data_list": List<dynamic>.from(dataListPrint.map((x) => x.toJson())),
    };
}

class DataListPrint {
    final String skfAttendance;
    final String fmIdName;
    final String othersParticipants;
    final String payMode;
    final String payTo;
    final String ecmeAmount;
    final String meetingDate;
    final String ecmeDoctorCategory;
    final String institutionName;
    final String department;
    final String meetingVenue;
    final String meetingTopic;
    final String probableSpeakerName;
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
    final String step;
    final List<BrandListPrint> brandList;
    final List<DoctorListPrint> doctorList;
    final String remindedBrand;
    final String totalBudgetInWords;
    // FeedbackFormatDictData? feedbackFormatdatamModel;

    DataListPrint({
        required this.skfAttendance,
        required this.fmIdName,
        required this.othersParticipants,
        required this.payMode,
        required this.payTo,
        required this.ecmeAmount,
        required this.meetingDate,
        required this.ecmeDoctorCategory,
        required this.institutionName,
        required this.department,
        required this.meetingVenue,
        required this.meetingTopic,
        required this.probableSpeakerName,
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
        required this.step,
        required this.brandList,
        required this.doctorList,
        required this.remindedBrand,
        required this.totalBudgetInWords,
        // this.feedbackFormatdatamModel,
    });

    factory DataListPrint.fromJson(Map<String, dynamic> json) => DataListPrint(
        skfAttendance: json["skf_attendance"]??"",
        fmIdName: json["fm_id_name_area"]??"",
        othersParticipants: json["others_participants"]??"",
        payMode: json["pay_mode"]??"",
        payTo: json["pay_to"]??"",
        ecmeAmount: json["ecme_amount"]??"",
        meetingDate: json["meeting_date"]??"",
        ecmeDoctorCategory: json["ecme_doctor_category"]??"",
        institutionName: json["institution_name"]??"",
        department: json["department"]??"",
        meetingVenue: json["meeting_venue"]??"",
        meetingTopic: json["meeting_topic"]??"",
        probableSpeakerName: json["probable_speaker_name"]??"",
        totalNumbersOfParticipants: json["total_numbers_of_participants"]??"",
        totalBudget: json["total_budget"]??"",
        hallRent: json["hall_rent"]??"",
        costPerDoctor: json["cost_per_doctor"]??"",
        foodExpense: json["food_expense"]??"",
        stationnaires: json["stationnaires"]??"",
        giftsSouvenirs: json["gifts_souvenirs"]??"",
        doctorsCount: json["doctors_count"]??"",
        internDoctors: json["intern_doctors"]??"",
        dmfDoctors: json["dmf_doctors"]??"",
        nurses: json["nurses"]??"",
        lastAction: json["last_action"]??"",
        ecmeType: json["ecme_type"]??"",
        submitDate: json["submit_date"]??"",
        sl: json["sl"]??"",
        step: json["step"]??"",
        brandList: List<BrandListPrint>.from(json["brand_list"].map((x) => BrandListPrint.fromJson(x))),
        doctorList: List<DoctorListPrint>.from(json["doctor_list"].map((x) => DoctorListPrint.fromJson(x))),
        remindedBrand:json["reminded_brand"]??"" ,
        totalBudgetInWords: json["total_budget_in_words"]??"",
       // feedbackFormatdatamModel:json["feedback_fromat_dict_data"].map((x) => FeedbackFormatDictData.fromJson(x)) ??{}  
    );

    Map<String, dynamic> toJson() => {
        "skf_attendance": skfAttendance,
        "fm_id_name_area":fmIdName,
        "others_participants": othersParticipants,
        "pay_mode": payMode,
        "pay_to": payTo,
        "ecme_amount": ecmeAmount,
        "meeting_date": meetingDate,
        "ecme_doctor_category": ecmeDoctorCategory,
        "institution_name": institutionName,
        "department": department,
        "meeting_venue": meetingVenue,
        "meeting_topic": meetingTopic,
        "probable_speaker_name": probableSpeakerName,
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
        "step": step,
        "brand_list": List<dynamic>.from(brandList.map((x) => x.toJson())),
        "doctor_list": List<dynamic>.from(doctorList.map((x) => x.toJson())),
        "reminded_brand":remindedBrand,
        "total_budget_in_words":totalBudgetInWords,
       // "feedback_fromat_dict_data":feedbackFormatdatamModel
    };
}

class BrandListPrint {
    final String rowId;
    final String brandId;
    final String brandName;
    final String amount;
    final String qty;

    BrandListPrint({
        required this.rowId,
        required this.brandId,
        required this.brandName,
        required this.amount,
        required this.qty,
    });

    factory BrandListPrint.fromJson(Map<String, dynamic> json) => BrandListPrint(
        rowId: json["row_id"]??"",
        brandId: json["brand_id"]??"",
        brandName: json["brand_name"]??"",
        amount: json["amount"]??"",
        qty: json["qty"]??"",
    );

    Map<String, dynamic> toJson() => {
        "row_id": rowId,
        "brand_id": brandId,
        "brand_name": brandName,
        "amount": amount,
        "qty": qty,
    };
}

class DoctorListPrint {
    final String rowId;
    final String doctorId;
    final String doctorName;

    DoctorListPrint({
        required this.rowId,
        required this.doctorId,
        required this.doctorName,
    });

    factory DoctorListPrint.fromJson(Map<String, dynamic> json) => DoctorListPrint(
        rowId: json["row_id"]??"",
        doctorId: json["doctor_id"]??"",
        doctorName: json["doctor_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "row_id": rowId,
        "doctor_id": doctorId,
        "doctor_name": doctorName,
    };
}


class FeedbackFormatDictData {
    final String sl;
    final String date;
    final String to;
    final String from;
    final String copy;
    final String subject;

    FeedbackFormatDictData({
        required this.sl,
        required this.date,
        required this.to,
        required this.from,
        required this.copy,
        required this.subject,
    });

    factory FeedbackFormatDictData.fromJson(Map<String, dynamic> json) => FeedbackFormatDictData(
        sl: json["sl"]??"",
        date: json["date"]??"",
        to: json["to"]??"",
        from: json["from"]??"",
        copy: json["copy"]??"",
        subject: json["subject"]??"",
    );

    Map<String, dynamic> toJson() => {
        "sl": sl,
        "date": date,
        "to": to,
        "from": from,
        "copy": copy,
        "subject": subject,
    };
}