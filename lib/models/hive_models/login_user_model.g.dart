// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLoginModelAdapter extends TypeAdapter<UserLoginModel> {
  @override
  final int typeId = 6;

  @override
  UserLoginModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLoginModel(
      status: fields[0] as String,
      userId: fields[2] as String,
      userName: fields[3] as String,
      mobileNo: fields[4] as String,
      areaPage: fields[5] as bool,
      orderFlag: fields[6] as bool,
      osShowFlag: fields[7] as bool,
      osDetailsFlag: fields[8] as bool,
      ordHistoryFlag: fields[9] as bool,
      invHistroyFlag: fields[10] as bool,
      dcrFlag: fields[11] as bool,
      rxFlag: fields[12] as bool,
      othersFlag: fields[13] as bool,
      visitPlanFlag: fields[14] as bool,
      plaginFlag: fields[15] as bool,
      offerFlag: fields[16] as bool,
      noteFlag: fields[17] as bool,
      dcrVisitWith: fields[18] as bool,
      dcrVisitWithList: (fields[19] as List).cast<String>(),
      rxDocMust: fields[20] as bool,
      rxTypeMust: fields[21] as bool,
      rxGalleryAllow: fields[22] as bool,
      rxTypeList: (fields[23] as List).cast<String>(),
      userSalesAchFlag: fields[24] as bool,
      clientFlag: fields[25] as bool,
      clientEditFlag: fields[26] as bool,
      timerFlag: fields[27] as bool,
      dcrDiscussion: fields[28] as bool,
      promoFlag: fields[29] as bool,
      leaveFlag: fields[30] as bool,
      noticeFlag: fields[31] as bool,
      docFlag: fields[32] as bool,
      docEditFlag: fields[33] as bool,
      userLevelDepth: fields[34] as String,
      edsrFlag: fields[35] as bool,
      edsrApprovalFlag: fields[36] as bool,
      appraisalFlag: fields[37] as bool,
      appraisalApprovalFlag: fields[38] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserLoginModel obj) {
    writer
      ..writeByte(38)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.mobileNo)
      ..writeByte(5)
      ..write(obj.areaPage)
      ..writeByte(6)
      ..write(obj.orderFlag)
      ..writeByte(7)
      ..write(obj.osShowFlag)
      ..writeByte(8)
      ..write(obj.osDetailsFlag)
      ..writeByte(9)
      ..write(obj.ordHistoryFlag)
      ..writeByte(10)
      ..write(obj.invHistroyFlag)
      ..writeByte(11)
      ..write(obj.dcrFlag)
      ..writeByte(12)
      ..write(obj.rxFlag)
      ..writeByte(13)
      ..write(obj.othersFlag)
      ..writeByte(14)
      ..write(obj.visitPlanFlag)
      ..writeByte(15)
      ..write(obj.plaginFlag)
      ..writeByte(16)
      ..write(obj.offerFlag)
      ..writeByte(17)
      ..write(obj.noteFlag)
      ..writeByte(18)
      ..write(obj.dcrVisitWith)
      ..writeByte(19)
      ..write(obj.dcrVisitWithList)
      ..writeByte(20)
      ..write(obj.rxDocMust)
      ..writeByte(21)
      ..write(obj.rxTypeMust)
      ..writeByte(22)
      ..write(obj.rxGalleryAllow)
      ..writeByte(23)
      ..write(obj.rxTypeList)
      ..writeByte(24)
      ..write(obj.userSalesAchFlag)
      ..writeByte(25)
      ..write(obj.clientFlag)
      ..writeByte(26)
      ..write(obj.clientEditFlag)
      ..writeByte(27)
      ..write(obj.timerFlag)
      ..writeByte(28)
      ..write(obj.dcrDiscussion)
      ..writeByte(29)
      ..write(obj.promoFlag)
      ..writeByte(30)
      ..write(obj.leaveFlag)
      ..writeByte(31)
      ..write(obj.noticeFlag)
      ..writeByte(32)
      ..write(obj.docFlag)
      ..writeByte(33)
      ..write(obj.docEditFlag)
      ..writeByte(34)
      ..write(obj.userLevelDepth)
      ..writeByte(35)
      ..write(obj.edsrFlag)
      ..writeByte(36)
      ..write(obj.edsrApprovalFlag)
      ..writeByte(37)
      ..write(obj.appraisalFlag)
      ..writeByte(38)
      ..write(obj.appraisalApprovalFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLoginModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
