import 'package:flutter/material.dart';

final Map<String, IconData> _categoryIcons = {
  'Lab Results': Icons.science_rounded,
  'Radiology': Icons.medical_information_rounded,
  'Cardiology': Icons.favorite_rounded,
  'Prescription': Icons.medication_rounded,
  'Vaccination': Icons.vaccines_rounded,
  'Emergency': Icons.local_hospital_rounded,
  'Consultation': Icons.record_voice_over_rounded,
  'Surgery': Icons.health_and_safety_rounded,
  'Dental': Icons.medical_services_rounded,
  'Ophthalmology': Icons.remove_red_eye_rounded,
  'Dermatology': Icons.face_retouching_natural_rounded,
  'General': Icons.description_rounded,
  'Custom': Icons.folder_copy_rounded,
};

IconData getCategoryIcon(String category) {
  return _categoryIcons[category] ?? Icons.folder_copy_rounded;
}

List<String> getAllCategories() {
  return ['All', ..._categoryIcons.keys];
}
