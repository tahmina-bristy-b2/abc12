// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_CME_doctor_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EcmeTerritoryRestDoctorModelAdapter
    extends TypeAdapter<EcmeTerritoryRestDoctorModel> {
  @override
  final int typeId = 97;

  @override
  EcmeTerritoryRestDoctorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EcmeTerritoryRestDoctorModel(
      status: fields[0] as String,
      docList: (fields[1] as List).cast<DocListECMEModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, EcmeTerritoryRestDoctorModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.docList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EcmeTerritoryRestDoctorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocListECMEModelAdapter extends TypeAdapter<DocListECMEModel> {
  @override
  final int typeId = 102;

  @override
  DocListECMEModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocListECMEModel(
      docId: fields[0] as String,
      docName: fields[1] as String,
      areaId: fields[2] as String,
      areaName: fields[3] as String,
      address: fields[4] as String,
      thirdPartyId: fields[5] as String,
      degree: fields[6] as String,
      specialty: fields[7] as String,
      mobile: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DocListECMEModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.docId)
      ..writeByte(1)
      ..write(obj.docName)
      ..writeByte(2)
      ..write(obj.areaId)
      ..writeByte(3)
      ..write(obj.areaName)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.thirdPartyId)
      ..writeByte(6)
      ..write(obj.degree)
      ..writeByte(7)
      ..write(obj.specialty)
      ..writeByte(8)
      ..write(obj.mobile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocListECMEModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
