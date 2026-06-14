import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ba_pedometer/main/theme/kei/kei_theme.dart';
import 'package:ba_pedometer/main/perdometer_screen.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
  
	await SystemChrome.setPreferredOrientations([
		DeviceOrientation.portraitUp,
		DeviceOrientation.portraitDown,
	]);

    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: PerdometerScreen(theme: KeiTheme()),
        );
    }
}
