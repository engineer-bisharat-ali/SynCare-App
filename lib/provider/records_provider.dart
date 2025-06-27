import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncare/models/medical_records.dart';

class RecordsProvider extends ChangeNotifier {
  //  Box for Medical Records
  Box recordsBox = Hive.box('medical_records');
  //  List of Records
   List<MedicalRecord> _records = [];
   //List for filtered records
  List<MedicalRecord> _filteredRecords = [];
  //  Current search query
  String currentQuery = '';

  //  Getter for Records
  List<MedicalRecord> get records => _filteredRecords.isEmpty ? _records : _filteredRecords;

  //  Function to load Records from Hive
  void loadLocalRecords() {
    _records = recordsBox.values
        .map((e) => MedicalRecord.fromMap(Map<String, dynamic>.from(e)))
        .toList();
        _filteredRecords = [];
    notifyListeners();
  }

  //  Function to get Records from Hive
  void addRecord(String category, String title, String description, String filePath, String fileType, DateTime selectedDate) {
    MedicalRecord record = MedicalRecord(
      id: DateTime.now().toString(),
      userId: "CURRENT_USER_ID",
      category: category,
      title: title,
      description: description,
      filePath: filePath,
      fileType: fileType,
    );
    _records.add(record);
    recordsBox.put(record.id, record.toMap());
     if (_filteredRecords.isNotEmpty) {
    searchRecords(currentQuery); // ✅ Search query maintain rakhni hai
  }
    notifyListeners();
  }

  void removeRecord(String recordId) {
    _records.removeWhere((record) => record.id == recordId);
    recordsBox.delete(recordId);

    if (_filteredRecords.isNotEmpty) {
      _filteredRecords.removeWhere((record) => record.id == recordId);
    }
    notifyListeners();
  }

  
  void searchRecords(String query) {
  currentQuery = query;

  if (query.isEmpty) {
    _filteredRecords = [];
  } else {
    _filteredRecords = _records.where((record) {
      return record.category.toLowerCase().startsWith(query.toLowerCase());
    }).toList();
  }

  notifyListeners();
}


  
}