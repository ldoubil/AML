import 'package:aml/src/rust/api/simple.dart';
import 'package:aml/storage/scheme.dart';
import 'package:aml/ui/screen/main_screen.dart' show MainScreen;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AmlApp extends StatefulWidget {
  const AmlApp({super.key});
  @override
  State<AmlApp> createState() => _AmlAppState();
}

class _AmlAppState extends State<AmlApp> {
  @override
  void initState()  {
    super.initState();
    // 初始化
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.mandyRed,
        colorScheme: darkColorScheme,
      ),
      themeMode: ThemeMode.dark, // 设置当前主题模式
      home: const MainScreen(),
    );
  }
}
