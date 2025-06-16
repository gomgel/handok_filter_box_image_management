import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

// Providers to hold the active search queries
final employeeNameSearchQueryProvider = StateProvider<String>((ref) => '');
final productionLineSearchQueryProvider = StateProvider<String>((ref) => '');

class ModernSearchScreen extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
  const ModernSearchScreen({super.key});

  @override
  ConsumerState<ModernSearchScreen> createState() => _ModernSearchScreenState(); // Changed state class
}

class _ModernSearchScreenState extends ConsumerState<ModernSearchScreen> { // Changed state class
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _productionLineController =
  TextEditingController();

  @override
  void dispose() {
    _employeeNameController.dispose();
    _productionLineController.dispose();
    super.dispose();
  }

  void _search() {
    final String employeeName = _employeeNameController.text.trim();
    final String productionLine = _productionLineController.text.trim();

    // --- Riverpod Integration: Update the providers with the search queries ---
    ref.read(employeeNameSearchQueryProvider.notifier).state = employeeName;
    ref.read(productionLineSearchQueryProvider.notifier).state = productionLine;
    // -------------------------------------------------------------------------

    // In a real application, you'd perform your search logic here.
    // This logic can now *read* the providers or directly use the `employeeName` and `productionLine` local variables.
    print('Searching for Employee Name: ${ref.read(employeeNameSearchQueryProvider)}');
    print('Searching for Production Line: ${ref.read(productionLineSearchQueryProvider)}');

    String message;
    if (employeeName.isEmpty && productionLine.isEmpty) {
      message = 'Please enter search criteria.';
    } else {
      message = 'Searching for "$employeeName" and "$productionLine"...';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Find Employees & Lines',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              _buildModernTextFormField(
                controller: _employeeNameController,
                labelText: 'Employee Name',
                hintText: 'e.g., Jane Doe',
                icon: Icons.person_outline,
                onFieldSubmitted: (_) => _search(),
              ),
              const SizedBox(height: 20.0),
              _buildModernTextFormField(
                controller: _productionLineController,
                labelText: 'Production Line',
                hintText: 'e.g., Fabrication Unit 3',
                icon: Icons.factory_outlined,
                onFieldSubmitted: (_) => _search(),
              ),
              const SizedBox(height: 30.0),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _search,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text(
                    'Search',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 8,
                    shadowColor: Colors.teal.shade900,
                  ),
                ),
              ),

              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 100), () {
                    Navigator.of(context).pushNamed("/setting");
                  });
                },
                child: const Text(
                  "SETTING",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required Function(String) onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade800, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.teal, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.5),
        ),
        filled: true,
        fillColor: Colors.grey.shade900,
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}