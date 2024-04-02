
import 'dart:convert';

ECMEffListDataModel eCMEFFListModelFromJson(String str) =>
    ECMEffListDataModel.fromJson(json.decode(str));

String eCMEFFListModelToJson(ECMEffListDataModel data) =>
    json.encode(data.toJson());

class ECMEffListDataModel {
  final ECMEResData resData;

  ECMEffListDataModel({
    required this.resData,
  });

  factory ECMEffListDataModel.fromJson(Map<String, dynamic> json) =>
      ECMEffListDataModel(
        resData: ECMEResData.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
      };
}

class ECMEResData {
  final String status;
  final List<EcmeFFListModel>? dataList;
  // final String budget;
  // final String expense;
  final String levelDepth;

  ECMEResData(
      {required this.status,
      required this.dataList,
      // required this.budget,
      // required this.expense,
      required this.levelDepth});

  factory ECMEResData.fromJson(Map<String, dynamic> json) => ECMEResData(
        status: json["status"],
        dataList: List<EcmeFFListModel>.from(
            json["data_list"].map((x) => EcmeFFListModel.fromJson(x))),
        // budget: json["budget"],
        // expense: json["expense"],
        levelDepth: json["level_depth_no"] ?? '1',
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data_list": dataList == null
            ? []
            : List<dynamic>.from(dataList!.map((x) => x.toJson())),
        // "budget": budget,
        // "expense": expense,
        "level_depth_no": levelDepth
      };
}

class EcmeFFListModel {
  final String submitBy;
  final String territoryId;
  final String dueCount;
  EcmeFFListModel({
    required this.submitBy,
    required this.territoryId,
    required this.dueCount, 
  });

  factory EcmeFFListModel.fromJson(Map<String, dynamic> json) => EcmeFFListModel(
        submitBy: json["submit_by"],
        territoryId: json["territory_id"],
        dueCount: json["due_count"],    
      );

  Map<String, dynamic> toJson() => {
        "submit_by": submitBy,
        "territory_id": territoryId,
        "due_count": dueCount,
        
      };
}
