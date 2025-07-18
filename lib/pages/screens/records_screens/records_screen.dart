import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/models/medical_records.dart';
import 'package:syncare/pages/helper_classess/category_icon_helper.dart';
import 'package:syncare/pages/screens/records_screens/add_record_screen.dart';
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
  String _selectedCategoryFilter = 'All'; // Default category filter

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recordsProvider = Provider.of<RecordsProvider>(context);

    // Filter records by category
    final filteredRecords = _selectedCategoryFilter == 'All'
    ? recordsProvider.records
    : recordsProvider.records
        .where((r) => r.category == _selectedCategoryFilter)
        .toList();


    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(title: "Medical Records"),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildSearchSection()),
          SliverToBoxAdapter(child: _buildCategoryFilterChips()),
          _buildRecordsList(filteredRecords, recordsProvider),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // 🔍 Search Section
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF64748B).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search medical records, categories...",
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                    onPressed: () {
                      _searchController.clear();
                      Provider.of<RecordsProvider>(context, listen: false)
                          .searchRecords('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
          onChanged: (value) {
            Provider.of<RecordsProvider>(context, listen: false).searchRecords(value);
            setState(() {});
          },
        ),
      ),
    );
  }

  // 🧠 Filter Chips
  Widget _buildCategoryFilterChips() {
    final allCategories = getAllCategories();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(left: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: allCategories.map((category) {
            final isSelected = category == _selectedCategoryFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ChoiceChip(
                label: Row(
                  children: [
                    Icon(
                      category == 'All'
                          ? Icons.filter_list
                          : getCategoryIcon(category),
                      size: 18,
                      color: isSelected ? Colors.white : primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedCategoryFilter = category;
                  });
                },
                selectedColor: primaryColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 📋 List View
  Widget _buildRecordsList(List<MedicalRecord> records, RecordsProvider provider) {
    if (records.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildRecordCard(provider, records[index]),
          childCount: records.length,
        ),
      ),
    );
  }

  // 📭 Empty UI
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleAvatar(
          radius: 60,
          backgroundColor: Color(0xFFF3F4F6),
          child: Icon(Icons.folder_open_rounded, size: 60, color: Color(0xFF64748B)),
        ),
        SizedBox(height: 10),
        Text("No records found",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
      ],
    );
  }

  // 🧾 Record Card
  Widget _buildRecordCard(RecordsProvider provider, MedicalRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(record.id),
        direction: DismissDirection.endToStart,
        background: _buildDeleteBackground(),
        onDismissed: (_) async {
          await provider.removeRecordEverywhere(record.id);
          ScaffoldMessenger.of(context).showSnackBar(_deleteSnack());
        },
        child: _buildRecordTile(record),
      ),
    );
  }

  // 🗑️ Swipe Delete Background
  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_rounded, color: Colors.white, size: 28),
          SizedBox(height: 4),
          Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ✅ Deletion Confirmation Snack
  SnackBar _deleteSnack() {
    return SnackBar(
      content: const Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 12),
          Text("Record deleted successfully", style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      backgroundColor: const Color(0xFF059669),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    );
  }

  // 📋 Record Tile
  Widget _buildRecordTile(MedicalRecord record) {
    final icon = getCategoryIcon(record.category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        onTap: () => _navigateToDetails(record),
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.06),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryColor, size: 30),
        ),
        title: Text(
          record.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              record.category,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            if (!record.isSynced)
              const Row(
                children: [
                  Icon(Icons.cloud_off, size: 14, color: Colors.orange),
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
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF64748B)),
      ),
    );
  }

  // ➕ FAB to Add New Record
  Widget _buildFloatingActionButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 90, right: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, primaryColor.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8)),
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

  // 🔁 Go to Record Details
  void _navigateToDetails(MedicalRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecordDetailsScreen(record: record)),
    );
  }
}
