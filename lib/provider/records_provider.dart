import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncare/models/medical_records.dart';
import 'package:syncare/services/supabase_servises/supabase_storage_service.dart';

class RecordsProvider extends ChangeNotifier {
  late Box recordsBox;

  final _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connSub;  

  List<MedicalRecord> _records = [];
  List<MedicalRecord> _filteredRecords = [];
  String currentQuery = '';
  String? currentUserId;

  List<MedicalRecord> get records =>
      _filteredRecords.isEmpty ? _records : _filteredRecords;

  /* ──────────── Box init / dispose ──────────── */

  Future<void> initBoxForUser(String uid) async {
    currentUserId = uid;
    recordsBox = await Hive.openBox('medical_records_$uid');
    loadLocalRecords();

    _watchConnectivity();
    await _syncPending();                  
  }

  Future<void> closeBoxOnLogout() async {
    await _connSub?.cancel();
    await recordsBox.close();
    _records.clear();
    _filteredRecords.clear();
    currentUserId = null;
    notifyListeners();
  }

  /* ──────────── Public APIs ──────────── */

  Future<void> addRecordOfflineFirst({
    required String category,
    required String title,
    required String description,
    required String filePath,
    required String fileType,
  }) async {
    if (currentUserId == null) return;

    final rec = MedicalRecord(
      id: DateTime.now().toIso8601String(),
      userId: currentUserId!,
      category: category,
      title: title,
      description: description,
      filePath: filePath,
      fileType: fileType,
      isSynced: false,
    );

    _records.add(rec);
    await recordsBox.put(rec.id, rec.toMap());

    if (_filteredRecords.isNotEmpty) searchRecords(currentQuery);
    notifyListeners();

    _tryUpload(rec);                      
  }

  Future<void> removeRecordEverywhere(String recordId) async {
    final rec = _records.firstWhere((r) => r.id == recordId);

    if (rec.isSynced) {
      await SupabaseStorageService()
              .delete(rec.filePath.split('/').last)
              .catchError((_) {});        // ignore if offline
    }
    removeRecord(recordId);
  }

  /* ──────────── Local helpers ──────────── */

  void loadLocalRecords() {
    _records = recordsBox.values
        .map((e) => MedicalRecord.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    _filteredRecords.clear();
    notifyListeners();
  }

  void removeRecord(String recordId) {
    _records.removeWhere((r) => r.id == recordId);
    recordsBox.delete(recordId);
    _filteredRecords.removeWhere((r) => r.id == recordId);
    notifyListeners();
  }

  void searchRecords(String query) {
    currentQuery = query;
    _filteredRecords = query.isEmpty
        ? []
        : _records.where((r) {
            final q = query.toLowerCase();
            return r.title.toLowerCase().contains(q) ||
                   r.category.toLowerCase().contains(q);
          }).toList();
    notifyListeners();
  }

  /* ──────────── Connectivity & Sync ──────────── */

  bool _isOnline(List<ConnectivityResult> list) {
    // online if ANY interface ≠ none
    return list.any((r) => r != ConnectivityResult.none);
  }

  void _watchConnectivity() {
    _connSub = _connectivity.onConnectivityChanged.listen((list) {
      if (_isOnline(list)) _syncPending();
    });
  }

  Future<void> _syncPending() async {
    final pending = _records.where((r) => !r.isSynced).toList();
    for (final rec in pending) {
      await _tryUpload(rec);
    }
  }

  Future<void> _tryUpload(MedicalRecord rec) async {
    final list = await _connectivity.checkConnectivity();
    if (!_isOnline(list)) return;         // still offline

    try {
      final bytes = await File(rec.filePath).readAsBytes();
      await SupabaseStorageService()
          .upload(bytes, rec.filePath.split('/').last);
      rec.isSynced = true;
      await recordsBox.put(rec.id, rec.toMap());
      notifyListeners();
    } catch (_) {
      // network error → will retry later
    }
  }
}
