class SyncareOnBordingModel {
  String image;
  String title;
  String subtitle;

  SyncareOnBordingModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

List<SyncareOnBordingModel> onBordingList = [
  SyncareOnBordingModel(
      image: "Assets/images/onboarding-image1.png",
      title: "Manage medical records",
      subtitle: "Keep all your medical records in one place "),
  SyncareOnBordingModel(
      image: "Assets/images/onboarding-image2.png",
      title: "Early Detection",
      subtitle: "AI-powered insights for early health detection."),
  SyncareOnBordingModel(
      image: "Assets/images/onboarding-image3.png",
      title: " Symptoms Tracker",
      subtitle: "Log symptoms and track changes to manage your health."),
  SyncareOnBordingModel(
      image: "Assets/images/onboarding-image4.png",
      title: "Find Nearby Hospitals",
      subtitle: "Locate nearby hospitals quickly in emergencies."),
];
