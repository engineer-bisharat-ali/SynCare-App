import 'dart:io';
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

  // Dropdown options
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
    'Custom' // Option to add custom title
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
    'Custom' // Option to add custom category
  ];

  String? _selectedTitle;
  String? _selectedCategory;
  bool _isCustomTitle = false;
  bool _isCustomCategory = false;
  final TextEditingController _customTitleController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();

  // Professional colors
  
  final Color _successGreen = const Color(0xFF27AE60);
  final Color _warningOrange = const Color(0xFFE67E22);
  final Color _errorRed = const Color(0xFFE74C3C);
  final Color _backgroundGray = const Color(0xFFF8FAFB);
  final Color _cardWhite = const Color(0xFFFFFFFF);
  final Color _textDark = const Color(0xFF2C3E50);
  final Color _textLight = const Color(0xFF7F8C8D);

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

  void _saveRecord() async {
  if (_formKey.currentState!.validate() && _selectedFile != null) {
    setState(() => _isLoading = true);
    _formKey.currentState!.save();

    final finalTitle = _isCustomTitle ? _customTitleController.text : _selectedTitle!;
    final finalCategory = _isCustomCategory ? _customCategoryController.text : _selectedCategory!;

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

   
    Provider.of<RecordsProvider>(context, listen: false).addRecord(
      finalCategory,
      finalTitle,
      _description,
      _selectedFile!.path,
      _fileType!,
      DateTime.now(),
    );

    // ✅ Immediately reload updated records
    Provider.of<RecordsProvider>(context, listen: false).loadLocalRecords();

    setState(() => _isLoading = false);
    _showSnackBar("Record Added Successfully", "Your medical record has been securely saved", _successGreen);
    Navigator.pop(context);
  } else {
    _showSnackBar("Incomplete Information", "Please fill all required fields and attach a file", _warningOrange);
  }
}

  @override
  void dispose() {
    _customTitleController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _showSnackBar(String title, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                color == _successGreen ? Icons.check_circle : Icons.warning,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(message, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildDropdownField({
  required String label,
  required List<String> options,
  required String? selectedValue,
  required void Function(String?) onChanged,
  required IconData icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$label *",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _textDark,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: _cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true, // 💡 Important: makes dropdown take full width
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: primaryColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
          hint: Text("Select $label"),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                mainAxisSize: MainAxisSize.min, // ✅ prevents unbounded issue
                children: [
                  const Icon(Icons.arrow_right, size: 18, color: primaryColor),
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.loose, // ✅ no expansion issue
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? "$label is required" : null,
        ),
      ),
    ],
  );
}


  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Custom $label *",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter custom $label",
            prefixIcon: Icon(icon, color: primaryColor),
            filled: true,
            fillColor: _cardWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) => value!.isEmpty ? "Custom $label is required" : null,
        ),
      ],
    );
  }

  Widget _buildFileUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Medical Document *",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.security, size: 12, color: _successGreen),
                  const SizedBox(width: 4),
                  Text(
                    "HIPAA Secure",
                    style: TextStyle(
                      fontSize: 12,
                      color: _successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: _selectedFile != null ? primaryColor.withOpacity(0.05) : _cardWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedFile != null ? primaryColor : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: _selectedFile != null ? _buildFilePreview() : _buildUploadPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePreview() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_fileType == "pdf")
                Icon(Icons.picture_as_pdf, color: _errorRed, size: 40)
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_selectedFile!, width: 60, height: 60, fit: BoxFit.cover),
                ),
              const SizedBox(height: 8),
              Text(
                _selectedFile!.path.split('/').last,
                style: const TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _successGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_upload, size: 40, color: primaryColor),
        const SizedBox(height: 8),
        const Text(
          "Upload Medical File",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "JPG • PNG • PDF",
          style: TextStyle(fontSize: 12, color: _textLight),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: _backgroundGray,
      appBar:CustomAppBar(title: "Add Medical Record",
      onBack: () => Navigator.pop(context),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.medical_information, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Medical Record",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Securely store your health information",
                              style: TextStyle(fontSize: 14, color: _textLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Record Title Dropdown
                _buildDropdownField(
                  label: "Record Title",
                  options: _titleOptions,
                  selectedValue: _selectedTitle,
                  icon: Icons.assignment,
                  onChanged: (value) {
                    setState(() {
                      _selectedTitle = value;
                      _isCustomTitle = value == 'Custom';
                      if (!_isCustomTitle) {
                        _customTitleController.clear();
                      }
                    });
                  },
                ),

                // Custom Title Field (shows when Custom is selected)
                if (_isCustomTitle) ...[
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    label: "Title",
                    controller: _customTitleController,
                    icon: Icons.edit,
                  ),
                ],

                const SizedBox(height: 20),

                // Medical Category Dropdown
                _buildDropdownField(
                  label: "Medical Category",
                  options: _categoryOptions,
                  selectedValue: _selectedCategory,
                  icon: Icons.category,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _isCustomCategory = value == 'Custom';
                      if (!_isCustomCategory) {
                        _customCategoryController.clear();
                      }
                    });
                  },
                ),

                // Custom Category Field (shows when Custom is selected)
                if (_isCustomCategory) ...[
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    label: "Category",
                    controller: _customCategoryController,
                    icon: Icons.edit,
                  ),
                ],

                const SizedBox(height: 20),

                // Description Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Provide details about this medical record...",
                        prefixIcon: const Icon(Icons.description, color: primaryColor),
                        filled: true,
                        fillColor: _cardWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primaryColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Description is required";
                        if (value.trim().split(RegExp(r'\s+')).length < 10) {
                          return "Please provide at least 10 words";
                        }
                        return null;
                      },
                      onSaved: (value) => _description = value!,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // File Upload
                _buildFileUpload(),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveRecord,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              ),
                              SizedBox(width: 12),
                              Text("Saving...", style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, color: Colors.white),
                              SizedBox(width: 8),
                              Text("Save Record", style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Security Notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: _successGreen, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Your medical records are encrypted and HIPAA compliant",
                          style: TextStyle(
                            fontSize: 13,
                            color: _successGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  }   