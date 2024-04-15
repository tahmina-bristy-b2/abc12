import 'dart:core';

class ECMESubmitDataModel {
  String cid;
  String userId;
  String password;
  String brandString;
 //String areaId;
 // String docId;
  String lattitute;
  String longitude;
  String docListString;
  //String degree;
 // String speciality;
 // String address;
 // String mobile;
  String eCMEType;
  String meetingDate;
  String meetingVanue;
  String meetingTopic;
  String doctorCategory;
  String institureName;
  String departament;
  String eCMEAmount;
  String rxPerDay;
  String doctorsCount;
  String internDoctor;
  String dMFDoctors;
  String nurses;
  List<List<dynamic>> brandList;
  String speakerName;
  String speakerDesignation;
  String speakerInstitute;
  String numberOfParticipant;
  String totalBudget;
  String hallRentAmount;
  String costPerDoctor;
  String stationaries;
  String giftcose;
  String others;
  String foodExpense;

  
  ECMESubmitDataModel({
    required this.cid,
    required this.userId,
     required this.password,
    // required this.address,
    // required this.areaId,
    required this.brandList,
    required this.brandString,
    // required this.degree,
   // required this.docId,
    required this.docListString,
    required this.lattitute,
    required this.longitude,
    required this.meetingDate,
    required this.meetingTopic,
    required this.meetingVanue,
   // required this.mobile,
    required this.eCMEType,
    required this.doctorCategory,
    required this.institureName,
    required this.departament,
    required this.eCMEAmount,
    required this.rxPerDay,
   
 
    required this.doctorsCount,
    required this.internDoctor,
    required this.dMFDoctors,
    required this.nurses,
    required this.numberOfParticipant,
    required this.speakerInstitute,
    required this.others,
   
    required this.speakerName,
    required this.speakerDesignation,
  //  required this.speciality,
    required this.hallRentAmount,
    required this.foodExpense,
    
    required this.totalBudget,
    required this.giftcose,
    
    required this.stationaries,
     required this.costPerDoctor,
  
  });
}