import 'package:aml/ui/screen/main_screen.dart' show MainScreen;
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
    // 初始化
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ).copyWith(
        textTheme: Typography.material2021().black.apply(fontFamily: 'MiSans'),
        primaryTextTheme: Typography.material2021().black.apply(
          fontFamily: 'MiSans',
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ).copyWith(
        textTheme: Typography.material2021().white.apply(fontFamily: 'MiSans'),
        primaryTextTheme: Typography.material2021().white.apply(
          fontFamily: 'MiSans',
        ),
      ),
      themeMode: ThemeMode.system, // 设置当前主题模式
      home: MainScreen(),
    );
  }
}
