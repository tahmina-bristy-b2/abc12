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
    final FeedbackFormatDictData feedbackFormatDictData;
    final bool isBillEdit;
    final String submitBy;
    final String proTotalNumbersOfParticipants;
    final String proTotalBudget;
    final String proTotalBudgetInWords;
    final String proHallRent;
    final String proCostPerDoctor;
    final String proFoodExpense;
    final String proStationnaires;
    final String proGiftsSouvenirs;
    final String proDoctorsCount;
    final String proInternDoctors;
    final String proDmfDoctors;
    final String proNurses;
    final bool approvedFlag;

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
        required this.feedbackFormatDictData,
        required this.isBillEdit,
        required this.submitBy,
        required this.approvedFlag,
        required this.proTotalNumbersOfParticipants,
        required this.proTotalBudget,
        required this.proTotalBudgetInWords,
        required this.proHallRent,
        required this.proCostPerDoctor,
        required this.proFoodExpense,
        required this.proStationnaires,
        required this.proGiftsSouvenirs,
        required this.proDoctorsCount,
        required this.proInternDoctors,
        required this.proDmfDoctors,
        required this.proNurses,



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
        feedbackFormatDictData: FeedbackFormatDictData.fromJson(json["feedback_format_dict_data"]),
        isBillEdit: json["is_bill_edit"],
        submitBy: json["submit_by_id"],
        approvedFlag: json["approved_flag"],
        proTotalNumbersOfParticipants: json["pro_total_numbers_of_participants"],
        proTotalBudget: json["pro_total_budget"],
        proTotalBudgetInWords: json["pro_total_budget_in_words"],
        proHallRent: json["pro_hall_rent"],
        proCostPerDoctor: json["pro_cost_per_doctor"],
        proFoodExpense: json["pro_food_expense"],
        proStationnaires: json["pro_stationnaires"],
        proGiftsSouvenirs: json["pro_gifts_souvenirs"],
        proDoctorsCount: json["pro_doctors_count"],
        proInternDoctors: json["pro_intern_doctors"],
        proDmfDoctors: json["pro_dmf_doctors"],
        proNurses: json["pro_nurses"], 
        
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
        "feedback_format_dict_data":feedbackFormatDictData,
        "is_bill_edit":isBillEdit,
        "submit_by_id":submitBy,
        "approved_flag": approvedFlag,
        "pro_total_numbers_of_participants": proTotalNumbersOfParticipants,
        "pro_total_budget": proTotalBudget,
        "pro_total_budget_in_words": proTotalBudgetInWords,
        "pro_hall_rent": proHallRent,
        "pro_cost_per_doctor": proCostPerDoctor,
        "pro_food_expense": proFoodExpense,
        "pro_stationnaires": proStationnaires,
        "pro_gifts_souvenirs": proGiftsSouvenirs,
        "pro_doctors_count": proDoctorsCount,
        "pro_intern_doctors": proInternDoctors,
        "pro_dmf_doctors": proDmfDoctors,
        "pro_nurses": proNurses,
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
    final List<String> copy;
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
        copy: List<String>.from(json["copy"].map((x) => x)),
        subject: json["subject"]??"",
    );

    Map<String, dynamic> toJson() => {
        "sl": sl,
        "date": date,
        "to": to,
        "from": from,
        "copy": List<dynamic>.from(copy.map((x) => x)),
        "subject": subject,
    };
}