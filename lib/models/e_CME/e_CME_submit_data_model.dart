import 'dart:core';

class ECMESubmitDataModel {
  String cid;
  String userId;
  String password;
  String brandString;
  String areaId;
  String docId;
  String lattitute;
  String longitude;
  String docName;
  String degree;
  String speciality;
  String address;
  String mobile;
  String meetingDate;
  String meetingVanue;
  String meetingTopic;
  List<String> brandList;
  String speakerName;
  String speakerdegree;
  String speakerInstitute;
  String numberOfParticipant;
  String totalBudget;
  String hallRentAmount;
  String mornigEeveningTotalCost;
  String costPerDoctor;
  String costLunchDinner;
  String stationaries;
  String giftcose;
  String others;

  ECMESubmitDataModel({
    required this.cid,
    required this.address,
    required this.areaId,
    required this.brandList,
    required this.brandString,
    required this.costLunchDinner,
    required this.costPerDoctor,
    required this.degree,
    required this.docId,
    required this.docName,
    required this.giftcose,
    required this.hallRentAmount,
    required this.lattitute,
    required this.longitude,
    required this.meetingDate,
    required this.meetingTopic,
    required this.meetingVanue,
    required this.mobile,
    required this.mornigEeveningTotalCost,
    required this.numberOfParticipant,
    required this.speakerInstitute,
    required this.others,
    required this.password,
    required this.speakerName,
    required this.speakerdegree,
    required this.speciality,
    required this.stationaries,
    required this.totalBudget,
    required this.userId,
  });
}