import 'package:filter_box_image_management/features/home/presentation/screens/home_screen.dart';
import 'package:filter_box_image_management/features/setting/presentation/screens/setting_screen.dart';
import 'package:filter_box_image_management/reference/screen/test_screen_01.dart';
import 'package:filter_box_image_management/reference/screen/test_screen_02.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_settings_screens/flutter_settings_screens.dart';


// ... rest of your code ...

void main() {
  initializeSetting().then((accentColor) async{
    runApp(ProviderScope(child: MyApp()));
  });
}

Future<ValueNotifier<Color>> initializeSetting() async {
  await Settings.init(
    cacheProvider: SharePreferenceCache(),
  );
  final _accentColor = ValueNotifier(Colors.blueAccent);
  return _accentColor;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Modern Search App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.black,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const TestScreen02(),
          '/setting': (context) => const SettingScreen(),
          // '/menu': (context) => MenuScreen(),
          // '/export': (context) => ExportShippingScreen(),
          // '/box': (context) => BoxShippingScreen(),
          // '/validation': (context) => ShippingValidationScreen(),
        }
        //home: const ModernSearchScreen(),
        );
  }
}
