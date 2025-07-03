import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 100 % UID‑only folder structure
///   • Upload path :  <uid>/<fileName>
///   • Delete path :  <uid>/<fileName>
class SupabaseStorageService {
  static final SupabaseStorageService _i = SupabaseStorageService._internal();
  factory SupabaseStorageService() => _i;
  SupabaseStorageService._internal();

  final _supabase = Supabase.instance.client;

  /* ─────────────────── PRIVATE ─────────────────── */
  String _uid() => FirebaseAuth.instance.currentUser!.uid;

  /* ─────────────────── PUBLIC API ───────────────── */

  /// Uploads bytes to  `<UID>/<fileName>`
  Future<void> upload(Uint8List bytes, String fileName) async {
    final folder = _uid();
    await _supabase.storage
        .from('medical-records')
        .uploadBinary('$folder/$fileName', bytes);
  }

  /// Removes  `<UID>/<fileName>`  from the bucket
  Future<void> delete(String fileName) async {
    final folder = _uid();
    await _supabase.storage
        .from('medical-records')
        .remove(['$folder/$fileName']);
  }
}
