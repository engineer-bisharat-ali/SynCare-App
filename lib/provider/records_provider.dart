import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncare/models/medical_records.dart';
import 'package:syncare/services/supabase_servises/supabase_storage_service.dart';

class RecordsProvider extends ChangeNotifier {
  late Box recordsBox;

  List<MedicalRecord> _records = [];
  List<MedicalRecord> _filteredRecords = [];
  String currentQuery = '';
  String? currentUserId;

  List<MedicalRecord> get records =>
      _filteredRecords.isEmpty ? _records : _filteredRecords;

  Future<void> initBoxForUser(String uid) async {
    currentUserId = uid;
    recordsBox = await Hive.openBox('medical_records_$uid');
    loadLocalRecords();
  }

  Future<void> closeBoxOnLogout() async {
    await recordsBox.close();
    _records.clear();
    _filteredRecords.clear();
    currentUserId = null;
    notifyListeners();
  }

  void loadLocalRecords() {
    _records = recordsBox.values
        .map((e) => MedicalRecord.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    _filteredRecords = [];
    notifyListeners();
  }

  void addRecord(
    String category,
    String title,
    String description,
    String filePath,
    String fileType,
  ) {
    if (currentUserId == null) return;

    final record = MedicalRecord(
      id: DateTime.now().toIso8601String(),
      userId: currentUserId!,
      category: category,
      title: title,
      description: description,
      filePath: filePath,
      fileType: fileType,
    );

    _records.add(record);
    recordsBox.put(record.id, record.toMap());

    if (_filteredRecords.isNotEmpty) {
      searchRecords(currentQuery);
    }

    notifyListeners();
  }

   //delete locally + Supabase
  Future<void> removeRecordEverywhere(String recordId) async {
    final rec = _records.firstWhere((r) => r.id == recordId);
    await SupabaseStorageService()
        .delete(rec.filePath.split('/').last);      // remove in cloud
    removeRecord(recordId);                        // local remove
  }

  void removeRecord(String recordId) {
    _records.removeWhere((record) => record.id == recordId);
    recordsBox.delete(recordId);
    _filteredRecords.removeWhere((record) => record.id == recordId);
    notifyListeners();
  }

  void searchRecords(String query) {
    currentQuery = query;

    if (query.isEmpty) {
      _filteredRecords = [];
    } else {
      _filteredRecords = _records.where((record) {
        return record.title.toLowerCase().contains(query.toLowerCase()) ||
               record.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}
