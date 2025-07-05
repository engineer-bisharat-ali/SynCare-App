import 'package:hive/hive.dart';

part 'medical_records.g.dart';

@HiveType(typeId: 0)
class MedicalRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String filePath;

  @HiveField(6)
  final String fileType;

  @HiveField(7)                 
  bool isSynced;

  MedicalRecord({
    required this.id,
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
    required this.filePath,
    required this.fileType,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'category': category,
        'title': title,
        'description': description,
        'filePath': filePath,
        'fileType': fileType,
        'isSynced': isSynced,
      };

  factory MedicalRecord.fromMap(Map<String, dynamic> map) => MedicalRecord(
        id: map['id'] as String,
        userId: map['userId'] as String,
        category: map['category'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        filePath: map['filePath'] as String,
        fileType: map['fileType'] as String,
        isSynced: (map['isSynced'] as bool?) ?? false,
      );
}
