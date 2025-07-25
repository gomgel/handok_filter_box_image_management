import 'package:dropdown_search/dropdown_search.dart';
import 'package:filter_box_image_management/core/providers/common_provider.dart';
import 'package:filter_box_image_management/core/providers/global_provider.dart';
import 'package:filter_box_image_management/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/provider/home_provider.dart';
import '../widgets/search_dropdown.dart';
import '../widgets/search_multi_dropdown.dart'; // Import Riverpod

// Providers to hold the active search queries
final employeeNameSearchQueryProvider = StateProvider<String>((ref) => '');
final productionLineSearchQueryProvider = StateProvider<String>((ref) => '');

class HomeScreen extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState(); // Changed state class
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Changed state class

  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _productionLineController = TextEditingController();

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
    final config = ref.watch(configProvider);
    debugPrint(config.host);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 4.0),
              SearchMultiDropDown(
                label: "사원정보",
                items: (String filter, LoadProps? loadProps) async {

                  String name = filter;

                  if (name.isEmpty) {
                    return [];
                  }

                  final list = await ref.read(employeeProvider.notifier).getForSearching(
                        name_1st: name.length > 0 ? name[0] : "",
                        name_2nd: name.length > 1 ? name[1] : "",
                        name_3rd: name.length > 2 ? name[2] : "",
                      );

                  return list;
                },
                onSelectedItem: (models) {
                  debugPrint("Selected Changed : ${models.toString()}");
                  ref.read(loginUserProvider.notifier).state = models;
                },
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 4.0),
              SearchMultiDropDown(
                label: "부서정보",
                maxSelectableCount: 2,
                items: (String filter, LoadProps? loadProps) async {
                  //debugPrint("filter : $filter,  str : $s");

                  String name = filter;

                  final list = await ref.read(lineProvider.notifier).getForSearching(
                        name_1st: name.length > 0 ? name[0] : "",
                        name_2nd: name.length > 1 ? name[1] : "",
                        name_3rd: name.length > 2 ? name[2] : "",
                      );

                  return list;
                },
                onSelectedItem: (models) {
                  debugPrint("Selected Changed : ${models.toString()}");
                  ref.read(loginLineProvider.notifier).state = models;
                },
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {


                    final result = await isTheLastVersion();

                    if (!result) {

                      final Uri url = Uri.parse("${ref.read(configProvider).updateHost}/setup/app.apk");

                      await CommonUtils.instance.showSimpleDialog_01(context, "HANDOK PDA", "신규버전이 나왔습니다..\n업데이트를 진행합니다.");
                      await launchUrl(url);
                      return;
                    }

                    if (ref.read(loginLineProvider).isEmpty) {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(CommonUtils.instance.alertSnackBar(context: context, type: SnackBarType.error, message: "부서정보는 필수값!"));

                      return;
                    }

                    Navigator.of(context).pushNamed("/main");
                  },
                  label: const Text(
                    'ENTER',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.teal.shade700,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 8,
                    // shadowColor: Colors.teal.shade900,
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

  Future<bool> isTheLastVersion() async {
    final version = await ref.watch(commonRepositoryProvider).getVersion();

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      debugPrint("device : ${packageInfo.version}  - ${packageInfo.buildNumber} ");

      final version = await ref.read(commonRepositoryProvider).getVersion();

      debugPrint("version : ${version.return_data.version} - ${version.return_data.number} ");

      if (packageInfo.buildNumber == version.return_data.number) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }

  }

  Widget _buildModernTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon, // Changed to required IconData for consistency
    required Function(String) onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        //labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        // prefixIcon: Icon(prefixIcon, color: Colors.white.withOpacity(0.8)), // Using prefixIcon
        suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)), // The new suffixIcon
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
