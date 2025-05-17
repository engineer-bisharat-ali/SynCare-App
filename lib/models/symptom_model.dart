class SymptomModel {
  final String name;
  bool isSelected;


  SymptomModel({required this.name, this.isSelected = false});

  // Accept dynamic because API sends a simple string for symptom name
  factory SymptomModel.fromJson(dynamic json) {
    return SymptomModel(name: json.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
