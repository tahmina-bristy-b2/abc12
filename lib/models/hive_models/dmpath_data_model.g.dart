// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dmpath_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DmPathDataModelAdapter extends TypeAdapter<DmPathDataModel> {
  @override
  final int typeId = 10;

  @override
  DmPathDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DmPathDataModel(
      loginUrl: fields[0] as String,
      syncUrl: fields[1] as String,
      photoUrl: fields[2] as String,
      submitUrl: fields[3] as String,
      photoSubmitUrl: fields[4] as String,
      reportSalesUrl: fields[5] as String,
      reportDcrUrl: fields[6] as String,
      reportRxUrl: fields[7] as String,
      userAreaUrl: fields[8] as String,
      clientUrl: fields[9] as String,
      doctorEditUrl: fields[10] as String,
      leaveRequestUrl: fields[11] as String,
      leaveReportUrl: fields[12] as String,
      pluginUrl: fields[13] as String,
      tourPlanUrl: fields[14] as String,
      tourComplianceUrl: fields[15] as String,
      activityLogUrl: fields[16] as String,
      clientOutstUrl: fields[17] as String,
      userSalesCollAchUrl: fields[18] as String,
      osDetailsUrl: fields[19] as String,
      ordHistoryUrl: fields[20] as String,
      invHistoryUrl: fields[21] as String,
      clientEditUrl: fields[22] as String,
      timerTrackUrl: fields[23] as String,
      expTypeUrl: fields[24] as String,
      expSubmitUrl: fields[25] as String,
      reportExpUrl: fields[26] as String,
      expApprovalUrl: fields[27] as String,
      reportOutstUrl: fields[28] as String,
      reportLastOrdUrl: fields[29] as String,
      reportLastInvUrl: fields[30] as String,
      syncNoticeUrl: fields[31] as String,
      reportAttenUrl: fields[32] as String,
      doctorAddUrl: fields[33] as String,
      doctorEditSubmitUrl: fields[34] as String,
      reportPromoApUrl: fields[35] as String,
      reportPromoUrl: fields[36] as String,
      reportStockUrl: fields[37] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DmPathDataModel obj) {
    writer
      ..writeByte(38)
      ..writeByte(0)
      ..write(obj.loginUrl)
      ..writeByte(1)
      ..write(obj.syncUrl)
      ..writeByte(2)
      ..write(obj.photoUrl)
      ..writeByte(3)
      ..write(obj.submitUrl)
      ..writeByte(4)
      ..write(obj.photoSubmitUrl)
      ..writeByte(5)
      ..write(obj.reportSalesUrl)
      ..writeByte(6)
      ..write(obj.reportDcrUrl)
      ..writeByte(7)
      ..write(obj.reportRxUrl)
      ..writeByte(8)
      ..write(obj.userAreaUrl)
      ..writeByte(9)
      ..write(obj.clientUrl)
      ..writeByte(10)
      ..write(obj.doctorEditUrl)
      ..writeByte(11)
      ..write(obj.leaveRequestUrl)
      ..writeByte(12)
      ..write(obj.leaveReportUrl)
      ..writeByte(13)
      ..write(obj.pluginUrl)
      ..writeByte(14)
      ..write(obj.tourPlanUrl)
      ..writeByte(15)
      ..write(obj.tourComplianceUrl)
      ..writeByte(16)
      ..write(obj.activityLogUrl)
      ..writeByte(17)
      ..write(obj.clientOutstUrl)
      ..writeByte(18)
      ..write(obj.userSalesCollAchUrl)
      ..writeByte(19)
      ..write(obj.osDetailsUrl)
      ..writeByte(20)
      ..write(obj.ordHistoryUrl)
      ..writeByte(21)
      ..write(obj.invHistoryUrl)
      ..writeByte(22)
      ..write(obj.clientEditUrl)
      ..writeByte(23)
      ..write(obj.timerTrackUrl)
      ..writeByte(24)
      ..write(obj.expTypeUrl)
      ..writeByte(25)
      ..write(obj.expSubmitUrl)
      ..writeByte(26)
      ..write(obj.reportExpUrl)
      ..writeByte(27)
      ..write(obj.expApprovalUrl)
      ..writeByte(28)
      ..write(obj.reportOutstUrl)
      ..writeByte(29)
      ..write(obj.reportLastOrdUrl)
      ..writeByte(30)
      ..write(obj.reportLastInvUrl)
      ..writeByte(31)
      ..write(obj.syncNoticeUrl)
      ..writeByte(32)
      ..write(obj.reportAttenUrl)
      ..writeByte(33)
      ..write(obj.doctorAddUrl)
      ..writeByte(34)
      ..write(obj.doctorEditSubmitUrl)
      ..writeByte(35)
      ..write(obj.reportPromoApUrl)
      ..writeByte(36)
      ..write(obj.reportPromoUrl)
      ..writeByte(37)
      ..write(obj.reportStockUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmPathDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
