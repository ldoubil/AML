import 'package:aml/src/features/shell/ui/main_screen.dart' show MainScreen;
import 'package:aml/src/shared/theme/color_schemes.dart';
import 'package:flutter/material.dart';

class AmlApp extends StatefulWidget {
  const AmlApp({super.key});

  @override
  State<AmlApp> createState() => _AmlAppState();
}

class _AmlAppState extends State<AmlApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}
