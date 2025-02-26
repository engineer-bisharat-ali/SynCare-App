import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/models/medical_records.dart';
import 'package:open_file/open_file.dart';
import 'package:syncare/provider/records_provider.dart';

class RecordDetailsScreen extends StatelessWidget {
  final MedicalRecord record;

  const RecordDetailsScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Custom AppBar with a subtle color theme.
      appBar: AppBar(

        title: const Text(
          "Information",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 , color: Colors.white),
        ),
        centerTitle: true,
        elevation: 3,
        backgroundColor: primaryColor.withOpacity(0.8),

        
      ),
      // Wrapping content in SingleChildScrollView for responsiveness.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Record details card.
              Card(
                color: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.category, color: primaryColor, size: 28),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              record.title,
                              style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        record.category,
                        style: GoogleFonts.lato(fontSize: 18, color: Colors.grey[700]),
                      ),
                      const Divider(),
                      Text(
                        record.description,
                        style: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              // File preview section.
              record.fileType == "image"
                  ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400 , width: 2),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.1),
                      //     blurRadius: 5,
                      //     spreadRadius: 2,
                      //     offset: const Offset(0, 2),
                      //   ),
                      // ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(record.filePath),
                            width: double.infinity,
                            
                            fit: BoxFit.cover,
                          ),
                        ),
                    ),
                  )
                  : Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          OpenFile.open(record.filePath);
                        },
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                        label: const Text("Open PDF"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.redAccent),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
              const SizedBox(height: 30),
              // Delete button with confirmation dialog.
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show confirmation dialog before deleting.
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Record"),
                            content: const Text("Are you sure you want to delete this record?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog.
                                    final recordsProvider = Provider.of<RecordsProvider>(context , listen: false);
                                  recordsProvider.removeRecord(record.id);
                                  Navigator.pop(context, true); // Return deletion confirmation.
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text("Delete", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Delete Record",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
