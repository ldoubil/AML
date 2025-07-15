// 导入所需的包
import 'package:aml/ui/screen/status_bar.dart';
import 'package:flutter/material.dart';

// 主屏幕Widget，使用StatefulWidget以管理状态
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// MainScreen的状态管理类
class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: StatusBar(),
      body: Center(
        child: Text(
          '你好世界',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
