import 'package:hive/hive.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// 使用 Hive 使信号持久化的扩展
extension PersistentSignalExtension<T> on Signal<T> {
  /// 使用 Hive 存储使此信号持久化
  /// 如果 box 未打开，会自动打开
  void persistWith(String boxName, String key) {
    // 确保 box 已打开，如果没有则自动打开
    _ensureBoxOpen(boxName).then((_) {
      // 从存储中加载初始值
      _loadFromStorage(boxName, key);
      
      // 监听变化并保存到存储
      effect(() {
        _saveToStorage(boxName, key, value);
      });
    });
  }
  
  /// 确保指定的 box 已打开
  Future<void> _ensureBoxOpen(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
        print('自动打开 Hive box: $boxName');
      }
    } catch (e) {
      print('打开 Hive box "$boxName" 失败: $e');
    }
  }
  
  /// 从 Hive 存储中加载值
  void _loadFromStorage(String boxName, String key) {
    try {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        final storedValue = box.get(key);
        if (storedValue != null) {
          value = storedValue as T;
        }
      } else {
        print('警告: box "$boxName" 未打开，无法加载数据');
      }
    } catch (e) {
      print('从存储加载信号值失败：$e');
    }
  }
  
  /// 保存值到 Hive 存储
  void _saveToStorage(String boxName, String key, T value) {
    try {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        box.put(key, value);
      } else {
        print('警告: box "$boxName" 未打开，无法保存数据');
      }
    } catch (e) {
      print('保存信号值到存储失败：$e');
    }
  }
}