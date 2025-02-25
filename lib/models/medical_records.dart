import 'package:hive/hive.dart';

part 'medical_records.g.dart';

@HiveType(typeId: 0)
class MedicalRecord {
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
  final String filePath; //  Image ya PDF ka Local Path Store Karna

  @HiveField(6)
  final String fileType; //  "image" ya "pdf" store karne ke liye

  MedicalRecord({
    required this.id,
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
    required this.filePath,
    required this.fileType,
  });

  //  Hive Ke Liye JSON Convert Karna
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'title': title,
      'description': description,
      'filePath': filePath,
      'fileType': fileType,
    };
  }

  //  Firebase Se Data Convert Karna
  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      userId: map['userId'],
      category: map['category'],
      title: map['title'],
      description: map['description'],
      filePath: map['filePath'],
      fileType: map['fileType'],
    );
  }
}
