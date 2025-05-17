import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/provider/symptom_provider.dart';

class SymptomsTrackerScreen extends StatefulWidget {
  const SymptomsTrackerScreen({super.key});

  @override
  State<SymptomsTrackerScreen> createState() => _SymptomsTrackerScreenState();
}

class _SymptomsTrackerScreenState extends State<SymptomsTrackerScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  // Use non-late Animation with immediate initialization to avoid the error
  Animation<double> _fadeAnimation = const AlwaysStoppedAnimation(1.0);

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize the fade animation after controller is created
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Delay loadSymptoms until after the first frame to avoid context errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SymptomProvider>(context, listen: false);
      provider.loadSymptoms();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Show prediction Diseases dialog
  void _showPredictionDialog(BuildContext context, String prediction) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    final dialogWidth = size.width > 600 ? 500.0 : size.width * 0.85;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        elevation: 8,
        insetPadding: EdgeInsets.symmetric(
          horizontal: size.width > 600 ? size.width * 0.15 : 24,
          vertical: 24,
        ),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxWidth: 550,
            maxHeight: size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with gradient background
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 14 : 20,
                  horizontal: isSmallScreen ? 16 : 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Diagnosis Results',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content area with scrolling support
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Prediction result
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade50,
                                Colors.teal.shade50,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.green.shade200, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green.shade400,
                                          Colors.teal.shade400,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.25),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.medical_information_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Predicted Disease',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 13 : 15,
                                            color: Colors.grey.shade700,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          prediction,
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 18 : 22,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.teal.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Divider(color: Colors.green.shade100),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.trending_up,
                                      color: Colors.green.shade700,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Prediction Confidence: High',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 13 : 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // Additional information section with collapsible details
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              title: Text(
                                'What Next?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: colorScheme.primary,
                                ),
                              ),
                              leading: Icon(
                                Icons.help_outline_rounded,
                                color: colorScheme.primary,
                              ),
                              tilePadding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 16 : 20,
                                vertical: 8,
                              ),
                              childrenPadding: EdgeInsets.only(
                                left: isSmallScreen ? 16 : 20,
                                right: isSmallScreen ? 16 : 20,
                                bottom: 16,
                              ),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: colorScheme.primary,
                                      size: 18,
                                    ),
                                  ),
                                  title: Text(
                                    'Schedule a Doctor Appointment',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.monitor_heart_outlined,
                                      color: colorScheme.primary,
                                      size: 18,
                                    ),
                                  ),
                                  title: Text(
                                    'Continue Monitoring Your Symptoms',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: colorScheme.primary,
                                      size: 18,
                                    ),
                                  ),
                                  title: Text(
                                    'Learn More About This Condition',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Important disclaimer
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.amber.shade800,
                                size: isSmallScreen ? 18 : 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'This is an AI-assisted prediction based on your symptoms. '
                                  'Please consult with a healthcare professional for proper diagnosis and treatment options.',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 13,
                                    color: Colors.grey.shade800,
                                    height: 1.5,
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

              // Bottom action buttons
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade800,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 16,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        'Dismiss',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: Text(
                        'Got it',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 14 : 16,
                          vertical: 10,
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
    );
  }

  // Clear all selected symptoms confirmation dialog
  void _showClearConfirmationDialog(
      BuildContext context, SymptomProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber),
            SizedBox(width: 10),
            Text('Clear Selection'),
          ],
        ),
        content: const Text(
          'Are you sure you want to clear all selected symptoms?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearAllSelectedSymptoms();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All symptoms cleared'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.health_and_safety_outlined,
              color: primaryColor,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'Symptom Tracker',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<SymptomProvider>(builder: (context, provider, _) {
        // Show error snackbar only once and then clear error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(provider.error!)),
                  ],
                ),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(12),
              ),
            );
            provider.clearError();
          }

          // Show prediction dialog when available
          if (provider.prediction.isNotEmpty) {
            _showPredictionDialog(context, provider.prediction);
            // Clear prediction after showing dialog
            provider.clearPrediction();
          }
        });

        if (provider.loading && provider.symptoms.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: primaryColor,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading symptoms...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(child: LayoutBuilder(
              builder: (context, constraints) {
                // Adaptive padding based on screen width
                final horizontalPadding =
                    constraints.maxWidth > 600 ? 24.0 : 16.0;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Symptoms Search bar
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: provider.filterSymptoms,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            hintText: 'Type to find symptoms',
                            prefixIcon:
                                const Icon(Icons.search, color: primaryColor),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.filterSymptoms('');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Section title and counter with clear button
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.health_and_safety,
                                size: 18,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Available Symptoms',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if (provider.getSelectedCount() > 0)
                              InkWell(
                                onTap: () => _showClearConfirmationDialog(
                                    context, provider),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.clear_all,
                                        size: 14,
                                        color: Colors.red.shade700,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Clear All (${provider.getSelectedCount()})',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      //all Symptom (Symptom chips)
                      Expanded(
                        child: provider.filteredSymptoms.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.search_off,
                                        size: 40,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      _searchController.text.isNotEmpty
                                          ? "No symptoms found for '${_searchController.text}'"
                                          : "No symptoms available",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (_searchController.text.isNotEmpty)
                                      TextButton.icon(
                                        onPressed: () {
                                          _searchController.clear();
                                          provider.filterSymptoms('');
                                        },
                                        icon:
                                            const Icon(Icons.refresh, size: 16),
                                        label: const Text('Clear Search'),
                                      ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    alignment: WrapAlignment.start,
                                    children: provider.filteredSymptoms
                                        .map((symptom) {
                                      return symptom.isSelected
                                          ? Chip(
                                              label: Text(
                                                symptom.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              backgroundColor: primaryColor,
                                              deleteIcon: const Icon(
                                                Icons.cancel,
                                                size: 16,
                                                color: Colors.white70,
                                              ),
                                              onDeleted: () =>
                                                  provider.toggleSymptomByName(
                                                      symptom.name),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding: const EdgeInsets.all(6),
                                              elevation: 2,
                                              shadowColor:
                                                  primaryColor.withOpacity(0.3),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            )
                                          : ActionChip(
                                              label: Text(
                                                symptom.name,
                                                style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              avatar: Icon(Icons.add,
                                                  size: 16,
                                                  color: Colors.grey.shade600),
                                              backgroundColor:
                                                  Colors.grey.shade50,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding: const EdgeInsets.all(4),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                side: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 1,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  provider.toggleSymptomByName(
                                                      symptom.name),
                                            );
                                    }).toList(),
                                  ),
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      // Predict button
                      Container(
                        width: double.infinity,
                        height: 56,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ElevatedButton.icon(
                          onPressed: provider.loading ||
                                  provider.getSelectedCount() == 0
                              ? null
                              : () => provider.predict(),
                          icon: provider.loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(Icons.medical_services,
                                  color: provider.getSelectedCount() > 0
                                      ? Colors.white
                                      : Colors.grey.shade400),
                          label: Text(
                            provider.loading
                                ? "Analyzing symptoms..."
                                : provider.getSelectedCount() > 0
                                    ? "Predict Disease"
                                    : "Select symptoms to predict",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: provider.getSelectedCount() > 0
                                  ? Colors.white
                                  : Colors.grey.shade500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: provider.getSelectedCount() > 0 ? 3 : 0,
                            shadowColor: primaryColor.withOpacity(0.5),
                            disabledBackgroundColor: Colors.grey.shade200,
                            disabledForegroundColor: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )));
      }),
    );
  }
}
