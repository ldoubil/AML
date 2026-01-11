import 'package:aml/presentation/theme/color_schemes.dart';
import 'package:aml/presentation/screens/main/main_screen.dart' show MainScreen;
import 'package:flutter/material.dart';

class AmlApp extends StatefulWidget {
  const AmlApp({super.key});
  @override
  State<AmlApp> createState() => _AmlAppState();
}

class _AmlAppState extends State<AmlApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      themeMode: ThemeMode.dark, // 设置当前主题模式
      home: const MainScreen(),
    );
  }
}
