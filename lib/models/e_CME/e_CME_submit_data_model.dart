import 'dart:core';

import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';

class ECMESubmitDataModel {
  String cid;
  String userId;
  String password;
  String brandString;
  List<DocListECMEModel> docList;
 // String docListString;
  String lattitute;
  String longitude;
  String docListString;
  String eCMEType;
  String meetingDate;
  String meetingVanue;
  String meetingTopic;
  String doctorCategory;
  String institutionName;
  String departament;
  String eCMEAmount;

  String doctorsCount;
  String internDoctor;
  String dMFDoctors;
  String nurses;
  String skfAttendance;
  String othersParticipants;


  List<List<dynamic>> brandList;
  String speakerName;
 // String speakerDesignation;
 // String speakerInstitute;
  String numberOfParticipant;
  String costPerDoctor;
  String totalBudget;

  String hallRentAmount;
  String stationaries;
  String giftCost;
  String foodExpense;

  String payMode;

  
  ECMESubmitDataModel({
    required this.cid,
    required this.userId,
    required this.password,
    required this.brandList,
    required this.brandString,
    required this.docList,
    required this.docListString,
    required this.lattitute,
    required this.longitude,
    required this.meetingDate,
    required this.meetingTopic,
    required this.meetingVanue,
    required this.eCMEType,
    required this.doctorCategory,
    required this.institutionName,
    required this.departament,
    required this.eCMEAmount,
    //required this.rxPerDay,
    required this.doctorsCount,
    required this.internDoctor,
    required this.dMFDoctors,
    required this.nurses,
    required this.skfAttendance,
    required this.othersParticipants,

    required this.numberOfParticipant,
   // required this.speakerInstitute,
    
    required this.speakerName,
    //required this.speakerDesignation,
    required this.hallRentAmount,
    required this.foodExpense,
    required this.totalBudget,
    required this.giftCost,
    required this.stationaries,
    required this.costPerDoctor,
    required this.payMode
  
  });
}