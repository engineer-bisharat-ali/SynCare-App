// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_records.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicalRecordAdapter extends TypeAdapter<MedicalRecord> {
  @override
  final int typeId = 0;

  @override
  MedicalRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicalRecord(
      id: fields[0] as String,
      userId: fields[1] as String,
      category: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String,
      filePath: fields[5] as String,
      fileType: fields[6] as String,
      isSynced: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MedicalRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.filePath)
      ..writeByte(6)
      ..write(obj.fileType)
      ..writeByte(7)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
