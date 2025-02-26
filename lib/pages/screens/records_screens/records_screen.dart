import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/pages/screens/records_screens/AddRecordScreen.dart';
import 'package:syncare/pages/screens/records_screens/record_details_screen.dart';
import 'package:syncare/provider/records_provider.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  _RecordsHomeScreenState createState() => _RecordsHomeScreenState();

}

class _RecordsHomeScreenState extends State<RecordsScreen> {
  //controller for the search bar
   final TextEditingController _searchController = TextEditingController();
    //  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RecordsProvider>(context, listen: false).loadLocalRecords();
    });

  }

  @override
  Widget build(BuildContext context) {
    final recordsProvider = Provider.of<RecordsProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Medical Records",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 , color: Colors.white),
        ),
        centerTitle: true,
        elevation: 3,
        backgroundColor: primaryColor.withOpacity(0.8),
        
      ),
      body: Column(
        children: [
          //search the records
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Records",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                recordsProvider.searchRecords(value);
              },
            ),
          ),
          
          Expanded(
            child: recordsProvider.records.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 100, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        const Text(
                          "No records found!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    // Displaying the records in a ListView Builder with search functionality.
            
                    child: ListView.builder(
                      itemCount: recordsProvider.records.length,
                      itemBuilder: (context, index) {
                        var record = recordsProvider.records[index];
            
                        return Dismissible(
                          key: Key(record.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white, size: 30),
                          ),
                          onDismissed: (direction) {
                            recordsProvider.removeRecord(record.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Record Deleted")),
                            );
                          },
                          child: Card(
                            // color: primaryColor.withOpacity(0.1),
                            margin: const EdgeInsets.symmetric(vertical: 7),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: record.fileType == "image"
                                    ? Image.file(
                                        File(record.filePath),
                                        width: 65,
                                        height: 65,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          color: Colors.red[100],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 45),
                                      ),
                              ),
                              title: Text(
                                record.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Text(record.category, style: TextStyle(color: Colors.grey[700])),
                              trailing: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecordDetailsScreen(record: record),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                              ),
                              onTap: () {
                                //  Navigate to Record Details Screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecordDetailsScreen(record: record),
                                  ),
                                );
            
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 90, right: 5),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRecordScreen()),
            );
          },
          backgroundColor: primaryColor.withOpacity(0.8),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
