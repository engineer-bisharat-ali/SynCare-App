import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/models/medical_records.dart';
import 'package:syncare/pages/screens/records_screens/add_record_screen.dart.dart';
import 'package:syncare/pages/screens/records_screens/record_details_screen.dart';
import 'package:syncare/provider/records_provider.dart';
import 'package:syncare/widgets/custom_app_bar.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  _RecordsHomeScreenState createState() => _RecordsHomeScreenState();
}

class _RecordsHomeScreenState extends State<RecordsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recordsProvider = Provider.of<RecordsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(title: "Medical Records"),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildSearchSection()),
          _buildRecordsList(recordsProvider),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /* ───────────────────── Search bar ───────────────────── */
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF64748B).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xFF64748B).withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search medical records, categories...",
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.search_rounded,
                  color: Color(0xFF64748B), size: 22),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Color(0xFF94A3B8), size: 20),
                    onPressed: () {
                      _searchController.clear();
                      Provider.of<RecordsProvider>(context, listen: false)
                          .searchRecords('');
                    },
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
          ),
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            Provider.of<RecordsProvider>(context, listen: false)
                .searchRecords(value);
            setState(() {});
          },
        ),
      ),
    );
  }

  /* ───────────────────── List / Empty UI ───────────────────── */
  Widget _buildRecordsList(RecordsProvider recordsProvider) {
    if (recordsProvider.records.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildRecordCard(recordsProvider, index),
          childCount: recordsProvider.records.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF64748B).withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.folder_open_rounded,
                size: 60, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Medical Records",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Start building your digital health record",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /* ───────────────────── Single card with Dismissible ───────────────────── */
  Widget _buildRecordCard(RecordsProvider recordsProvider, int index) {
    final record = recordsProvider.records[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(record.id),
        direction: DismissDirection.endToStart,
        background: _buildDeleteBackground(),
        onDismissed: (direction) async {
          await recordsProvider.removeRecordEverywhere(record.id); // NEW
          ScaffoldMessenger.of(context).showSnackBar(_deleteSnack());
        },
        child: _buildRecordTile(record),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_rounded, color: Colors.white, size: 28),
          SizedBox(height: 4),
          Text("Delete",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12)),
        ],
      ),
    );
  }

  SnackBar _deleteSnack() {
    return SnackBar(
      content: const Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Text("Record deleted successfully",
              style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      backgroundColor: const Color(0xFF059669),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    );
  }
Widget _buildRecordTile(MedicalRecord record) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF64748B).withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: const Color(0xFF64748B).withOpacity(0.02),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: const Color(0xFF3B82F6).withOpacity(0.08),
        highlightColor: const Color(0xFF3B82F6).withOpacity(0.04),
        onTap: () => _navigateToDetails(record),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildRecordThumbnail(record),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.1,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    /* Category pill */
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.08),
                            primaryColor.withOpacity(0.12),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: primaryColor.withOpacity(0.15), width: 1),
                      ),
                      child: Text(
                        record.category,
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    /* 🆕 Pending‑upload badge */
                    if (!record.isSynced) ...[
                      const SizedBox(height: 6),
                      const Row(
                        children: [
                          Icon(Icons.cloud_off,
                              size: 14, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            "Pending upload",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  Widget _buildRecordThumbnail(record) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.5),
        child: record.fileType == "image"
            ? Image.file(File(record.filePath), fit: BoxFit.cover)
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFEF2F2), Color(0xFFFCE7E7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.picture_as_pdf_rounded,
                    color: Color(0xFFDC2626), size: 24),
              ),
      ),
    );
  }

  /* ───────────────────── FAB ───────────────────── */
  Widget _buildFloatingActionButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 90, right: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecordScreen()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
      ),
    );
  }

  void _navigateToDetails(record) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecordDetailsScreen(record: record)),
    );
  }
}
