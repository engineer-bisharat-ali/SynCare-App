import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/provider/records_provider.dart';
import 'package:syncare/widgets/custom_app_bar.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  AddRecordScreenState createState() => AddRecordScreenState();
}

class AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  File? _selectedFile;
  String? _fileType;
  bool _isLoading = false;

  final List<String> _titleOptions = [
    'Blood Test Results',
    'X-Ray Report',
    'MRI Scan',
    'CT Scan',
    'Ultrasound Report',
    'ECG Report',
    'Prescription',
    'Vaccination Certificate',
    'Medical Certificate',
    'Discharge Summary',
    'Lab Report',
    'Consultation Notes',
    'Custom'
  ];

  final List<String> _categoryOptions = [
    'Lab Results',
    'Radiology',
    'Cardiology',
    'Prescription',
    'Vaccination',
    'Emergency',
    'Consultation',
    'Surgery',
    'Dental',
    'Ophthalmology',
    'Dermatology',
    'General',
    'Custom'
  ];

  String? _selectedTitle;
  String? _selectedCategory;
  bool _isCustomTitle = false;
  bool _isCustomCategory = false;
  final TextEditingController _customTitleController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileType = result.files.single.extension == 'pdf' ? 'pdf' : 'image';
      });
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate() || _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and attach a file"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    _formKey.currentState!.save();

    final finalTitle = _isCustomTitle ? _customTitleController.text : _selectedTitle!;
    final finalCategory = _isCustomCategory ? _customCategoryController.text : _selectedCategory!;

    await Provider.of<RecordsProvider>(context, listen: false).addRecordOfflineFirst(
      category: finalCategory,
      title: finalTitle,
      description: _description,
      filePath: _selectedFile!.path,
      fileType: _fileType!,
    );

    final connList = await Connectivity().checkConnectivity();
    final online = connList.any((r) => r != ConnectivityResult.none);

    if (!mounted) return;
    setState(() => _isLoading = false);

    String message = online ? "Record uploaded successfully" : "Record saved offline";
    Color color = online ? Colors.green : Colors.orange;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _customTitleController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: "Add Medical Record",
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Dropdown
              const Text("Record Title *", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTitle,
                decoration: _inputDecoration("Select record title"),
                items: _titleOptions.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTitle = value;
                    _isCustomTitle = value == 'Custom';
                    if (!_isCustomTitle) _customTitleController.clear();
                  });
                },
                validator: (value) => value == null ? "Title is required" : null,
              ),
              if (_isCustomTitle) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customTitleController,
                  decoration: _inputDecoration("Enter custom title"),
                  validator: (value) => value!.isEmpty ? "Custom title is required" : null,
                ),
              ],

              const SizedBox(height: 20),

              // Category Dropdown
              const Text("Medical Category *", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: _inputDecoration("Select medical category"),
                items: _categoryOptions.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _isCustomCategory = value == 'Custom';
                    if (!_isCustomCategory) _customCategoryController.clear();
                  });
                },
                validator: (value) => value == null ? "Category is required" : null,
              ),
              if (_isCustomCategory) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customCategoryController,
                  decoration: _inputDecoration("Enter custom category"),
                  validator: (value) => value!.isEmpty ? "Custom category is required" : null,
                ),
              ],

              const SizedBox(height: 20),

              // Description
              const Text("Description *", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                decoration: _inputDecoration("Provide details about this medical record..."),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Description is required";
                  if (value.trim().split(RegExp(r'\s+')).length < 10) return "Please provide at least 10 words";
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),

              const SizedBox(height: 20),

              // File Picker Section
              const Text("Medical Document *", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: _selectedFile != null ? primaryColor.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedFile != null ? primaryColor : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  // File preview and fallback UI
                  child: _selectedFile != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_fileType == "pdf") ...[
                              Icon(Icons.picture_as_pdf, color: primaryColor, size: 40),
                              const SizedBox(height: 8),
                            ] else if (_fileType == "image") ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedFile!,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                _selectedFile!.path.split('/').last,
                                style: const TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 40, color: primaryColor),
                            SizedBox(height: 8),
                            Text("Upload Medical File", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor)),
                            SizedBox(height: 4),
                            Text("JPG • PNG • PDF", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Save Record", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable InputDecoration method
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
