import 'dart:convert';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/doc_settings_model.dart';
import 'package:MREPORTING/services/dcr/dcr_data_providers.dart';
import 'package:http/http.dart' as http;

class DcrRepositories {
  //################################ Sync DCR Data ########################

  Future<List> syncDCR(
      String syncUrl, String cid, String userId, String userpass) async {
    List doctorList = [];
    try {
      final http.Response response =
          await DcrDataProviders().syncDcrDP(syncUrl, cid, userId, userpass);
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> resData = jsonResponseDcrData['res_data'];

      final status = resData['status'];
      doctorList = resData['doctorList'];

      if (status == 'Success') {
        await Boxes().openAndAddDataToBox('dcrListData', doctorList);
        return doctorList;
      }
    } catch (e) {
      print('doctorList: $e');
    }

    return doctorList;
  }

  //################################ Sync DCR Gift  Data########################
  Future<List> syncDcrGift(
      String syncUrl, String cid, String userId, String userpass) async {
    List dcrGiftList = [];
    try {
      final http.Response response = await DcrDataProviders()
          .syncDcrGiftDP(syncUrl, cid, userId, userpass);
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> resData = jsonResponseDcrData['res_data'];

      final status = resData['status'];
      dcrGiftList = resData['giftList'];

      if (status == 'Success') {
        await Boxes().openAndAddDataToBox('dcrGiftListData', dcrGiftList);
        return dcrGiftList;
      }
    } catch (e) {
      print('dcrGiftList: $e');
    }

    return dcrGiftList;
  }

  //################################ Sync DCR Sample  Data########################
  Future<List> syncDcrSample(
      String syncUrl, String cid, String userId, String userpass) async {
    List sampleList = [];
    try {
      final http.Response response = await DcrDataProviders()
          .syncDcrSampleDP(syncUrl, cid, userId, userpass);
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> resData = jsonResponseDcrData['res_data'];

      final status = resData['status'];
      sampleList = resData['sampleList'];

      if (status == 'Success') {
        await Boxes().openAndAddDataToBox('dcrSampleListData', sampleList);
        return sampleList;
      }
    } catch (e) {
      print('sampleList: $e');
    }

    return sampleList;
  }

  //################################ Sync DCR PPM  Data########################
  Future<List> syncDcrPPM(
      String syncUrl, String cid, String userId, String userpass) async {
    List ppmList = [];
    try {
      final http.Response response =
          await DcrDataProviders().syncDcrPpmDP(syncUrl, cid, userId, userpass);
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> resData = jsonResponseDcrData['res_data'];

      final status = resData['status'];
      ppmList = resData['ppmList'];

      if (status == 'Success') {
        await Boxes().openAndAddDataToBox('dcrPpmListData', ppmList);
        return ppmList;
      }
    } catch (e) {
      print('ppmList: $e');
    }

    return ppmList;
  }

  //################################ Area base Client in  DCR ########################
  Future<List> getDCRAreaBaseClient(String syncUrl, String cid, String userId,
      String userpass, String areaId) async {
    List customerList = [];
    try {
      final http.Response response = await DcrDataProviders()
          .dcrAreaBaseClient(syncUrl, cid, userId, userpass, areaId);
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);

      final status = jsonResponseDcrData['status'];
      customerList = jsonResponseDcrData['clientList'];
      if (status == "Success") {
        return customerList;
      }
    } catch (e) {
      print('customerList: $e');
    }

    return customerList;
  }
  //################################ Add Doctor########################

  Future<Map<String, dynamic>> addDoctorR(
      String addUrl,
      String skf,
      String userId,
      String password,
      String areaId,
      String areaName,
      String doctorName,
      String category,
      String doctorCategory,
      String doctorType,
      String specialty,
      String degree,
      String chemistId,
      String draddress,
      String drDistrict,
      String drThana,
      String drMobile,
      String marDay,
      String child1,
      String child2,
      String collerSize,
      String nop,
      String fDrId,
      String fDrName,
      String fDrspecilty,
      String fDocAddress,
      String brand,
      String dob) async {
    String params =
        "cid=$skf&user_id=$userId&user_pass=$password&area_id=$areaId&area_name=$areaName&doc_name=$doctorName&category=$category&doctors_category=$doctorCategory&doctor_type=$doctorType&specialty=$specialty&degree=$degree&chemist_id=$chemistId&address=$draddress&district=$drDistrict&thana=$drThana&mobile=$drMobile&mar_day=$marDay&dob_child1=$child1&dob_child2=$child2&collar_size=$collerSize&nop=$nop&four_p_doc_id=$fDrId&fourP_doc_name=$fDrName&fourP_doc_specialty=$fDrspecilty&fourP_doc_address=$fDocAddress&brand=$brand&dob=$dob";
    // print(
    //     "$addUrl?cid=$skf&user_id=$userId&user_pass=$password&area_id=$areaId&area_name=$areaName&doc_name=$doctorName&category=$category&doctors_category=$doctorCategory&doctor_type=$doctorType&specialty=$specialty&degree=$degree&chemist_id=$chemistId&address=$draddress&district=$drDistrict&thana=$drThana&mobile=$drMobile&mar_day=$marDay&dob_child1=$child1&dob_child2=$child2&collar_size=$collerSize&nop=$nop&four_p_doc_id=$fDrId&fourP_doc_name=$fDrName&fourP_doc_specialty=$fDrspecilty&fourP_doc_address=$fDocAddress&brand=$brand&dob=$dob");
    Map<String, dynamic> submitDoctorData = {};
    try {
      final http.Response response =
          await DcrDataProviders().getDoctorAddUrl(addUrl, params);
      submitDoctorData = jsonDecode(response.body);
      return submitDoctorData;
    } catch (e) {
      print("Submit Api=$e");
    }
    return submitDoctorData;
  }

  //################################ Doctor Settings Repository ########################
  Future<DocSettingsModel?> docSettingsRepo(
      String cid, String userId, String userpass) async {
    DocSettingsModel? docSettingData;
    try {
      final http.Response response =
          await DcrDataProviders().docSettingsDP(cid, userId, userpass);
      DocSettingsModel docSettingData = docSettingsModelFromJson(response.body);

      if (docSettingData.resData.status == 'Success') {
        return docSettingData;
      }
    } catch (e) {
      print('docSettings: $e');
    }

    return docSettingData;
  }
}




 //=======================================================================================
  //==============================DCR Discussion======================================
  //=======================================================================================

  // Future<dynamic> syncDcrDiscussiontToHive(String sync_url, String cid,
  //     String userId, String userPassward, BuildContext context) async {
  //   //=================  giftopenbox to discussionToOpenBox ================================
  //   //======================================================================================
  //   await giftOpenBox();

  //   //=================  giftopenbox to discussionToOpenBox ================================
  //   //======================================================================================
  //   try {
  //     var response = await http.get(Uri.parse(
  //         '${sync_url}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userPassward'));

  //     Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
  //     Map<String, dynamic> res_data = jsonResponseDcrData['res_data'];

  //     var status = res_data['status'];
  //     var giftList = res_data['giftList'];

  //     if (status == 'Success') {
  //       await putDiscussionData(giftList);

  //       Timer(const Duration(seconds: 3), () => Navigator.pop(context));

  //       // ScaffoldMessenger.of(context)
  //       //     .showSnackBar(const SnackBar(content: Text('Sync success')));
  //       return buildShowDialog(context);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Did not sync Gift list')));
  //     }
  //   } on Exception catch (_) {
  //     throw Exception("Error on server");
  //   }
  //   // return Future.value(true);
  // }

  // Future putDiscussionData(dcrData) async {
  //   await box!.clear();

  //   for (var d in dcrData) {
  //     box!.add(d);
  //   }
  // }

  // Future discussionOpenBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('dcrDiscussionListData');
  // }
