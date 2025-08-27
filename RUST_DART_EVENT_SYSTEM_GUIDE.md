# Rust到Dart事件通知系统使用指南

基于 flutter_rust_bridge 的 Dart 回调机制实现的完整事件系统，支持 Rust 向 Dart 发送事件通知，Dart 可以注册多个监听器。

## 核心特性

### ✨ 主要功能

- **多监听器支持**: 每个事件类型可以注册多个 Dart 监听器
- **类型安全**: 强类型事件系统，编译时检查
- **异步支持**: 完全异步的事件处理机制
- **线程安全**: 支持多线程环境下的事件发送
- **灵活扩展**: 支持自定义事件类型
- **批量处理**: 支持批量发送多个事件

### 🎯 支持的事件类型

1. **下载进度事件** (`DownloadProgress`)
2. **系统通知事件** (`SystemNotification`)
3. **用户操作事件** (`UserAction`)
4. **错误事件** (`Error`)
5. **自定义事件** (`Custom`)

## 🚀 快速开始

### 1. Dart 端注册监听器

```dart
import 'src/rust/api/event_api.dart' as event_api;

// 注册下载进度监听器
await event_api.registerDownloadProgressListener(
  dartCallback: (fileName, progress, speed) {
    print('下载进度: $fileName - ${(progress * 100).toInt()}% - $speed');
    // 更新UI
    updateDownloadProgress(fileName, progress, speed);
    return '进度已更新';
  },
);

// 注册系统通知监听器
await event_api.registerSystemNotificationListener(
  dartCallback: (title, message, level) {
    print('系统通知: $title - $message ($level)');
    // 显示通知
    showNotification(title, message, level);
    return '通知已显示';
  },
);

// 注册用户操作监听器
await event_api.registerUserActionListener(
  dartCallback: (action, timestamp) {
    print('用户操作: $action (时间: $timestamp)');
    // 记录用户行为
    logUserAction(action, timestamp);
    return '操作已记录';
  },
);

// 注册错误监听器
await event_api.registerErrorListener(
  dartCallback: (errorCode, errorMessage, timestamp) {
    print('错误: $errorCode - $errorMessage');
    // 显示错误对话框
    showErrorDialog(errorCode, errorMessage);
    return '错误已处理';
  },
);
```

### 2. Rust 端发送事件

```rust
use crate::api::event_api;

// 发送下载进度事件
let results = event_api::send_download_progress(
    "example.zip".to_string(),
    0.75, // 75% 进度
    "2.5 MB/s".to_string(),
).await?;

// 发送系统通知
let results = event_api::send_system_notification(
    "操作完成".to_string(),
    "文件已成功保存".to_string(),
    "success".to_string(),
).await?;

// 发送用户操作事件
let results = event_api::send_user_action(
    "用户点击了保存按钮".to_string(),
).await?;

// 发送错误事件
let results = event_api::send_error(
    "NET_001".to_string(),
    "网络连接失败".to_string(),
).await?;
```

## 📚 详细API文档

### 监听器注册API

#### 下载进度监听器

```dart
// Dart 端
await registerDownloadProgressListener(
  dartCallback: (String fileName, double progress, String speed) {
    // fileName: 文件名
    // progress: 进度 (0.0 - 1.0)
    // speed: 下载速度字符串
    return 'Response from Dart';
  },
);
```

```rust
// Rust 端发送
let results = send_download_progress(
    "file.zip".to_string(),
    0.5, // 50%
    "1.2 MB/s".to_string(),
).await?;
```

#### 系统通知监听器

```dart
// Dart 端
await registerSystemNotificationListener(
  dartCallback: (String title, String message, String level) {
    // title: 通知标题
    // message: 通知消息
    // level: 通知级别 ("info", "warning", "error", "success")
    return 'Notification handled';
  },
);
```

```rust
// Rust 端发送
let results = send_system_notification(
    "提示".to_string(),
    "操作成功完成".to_string(),
    "success".to_string(),
).await?;
```

#### 用户操作监听器

```dart
// Dart 端
await registerUserActionListener(
  dartCallback: (String action, int timestamp) {
    // action: 用户操作描述
    // timestamp: Unix 时间戳
    return 'Action logged';
  },
);
```

```rust
// Rust 端发送
let results = send_user_action(
    "用户登录系统".to_string(),
).await?;
```

#### 错误监听器

```dart
// Dart 端
await registerErrorListener(
  dartCallback: (String errorCode, String errorMessage, int timestamp) {
    // errorCode: 错误代码
    // errorMessage: 错误消息
    // timestamp: Unix 时间戳
    return 'Error handled';
  },
);
```

```rust
// Rust 端发送
let results = send_error(
    "DB_001".to_string(),
    "数据库连接失败".to_string(),
).await?;
```

### 自定义事件

```dart
// Dart 端注册自定义事件监听器
await registerCustomEventListener(
  eventName: 'game_update',
  dartCallback: (String eventName, String payload, int timestamp) {
    // eventName: 事件名称
    // payload: 事件数据 (通常是JSON字符串)
    // timestamp: Unix 时间戳
    final data = jsonDecode(payload);
    handleGameUpdate(data);
    return 'Game update processed';
  },
);
```

```rust
// Rust 端发送自定义事件
let game_data = serde_json::json!({
    "level": 5,
    "score": 1000,
    "player": "Alice"
}).to_string();

let results = send_custom_event(
    "game_update".to_string(),
    game_data,
).await?;
```

## 🔧 高级功能

### 1. 通用事件监听器

```dart
// 可以监听任何类型的事件
await registerGenericEventListener(
  eventType: 'download_progress',
  dartCallback: (String eventType, String payload, int timestamp) {
    print('收到事件: $eventType');
    print('数据: $payload');
    return 'Generic event handled';
  },
);
```

### 2. 批量事件发送

```dart
// Dart 端
final results = await sendBatchEventsSimple(events: [
  ('user_action', '用户登录'),
  ('system_notification', '{"title":"欢迎","message":"登录成功","level":"success"}'),
  ('custom_game_event', '{"type":"level_up","level":5}'),
]);
```

```rust
// Rust 端
let events = vec![
    ("user_action".to_string(), "用户登录".to_string()),
    ("system_notification".to_string(), notification_json),
    ("custom_game_event".to_string(), game_json),
];

let all_results = send_batch_events_simple(events).await?;
```

### 3. 事件统计和管理

```dart
// 获取事件监听器统计信息
final stats = getEventStats();
print('事件统计: $stats');

// 清理所有监听器
clearAllEventListeners();
```

### 4. 模拟下载任务示例

```dart
// 启动模拟下载任务
await simulateDownloadTask(fileName: 'large_file.zip');
// 这会自动发送多个下载进度事件，最后发送完成通知
```

## 💡 最佳实践

### 1. 错误处理

```dart
try {
  await registerDownloadProgressListener(
    dartCallback: (fileName, progress, speed) {
      try {
        updateUI(fileName, progress, speed);
        return 'Success';
      } catch (e) {
        print('处理下载进度时出错: $e');
        return 'Error: $e';
      }
    },
  );
} catch (e) {
  print('注册监听器失败: $e');
}
```

### 2. 内存管理

```dart
class EventManager {
  bool _disposed = false;
  
  void dispose() {
    if (!_disposed) {
      clearAllEventListeners();
      _disposed = true;
    }
  }
}
```

### 3. 多监听器场景

```dart
// 可以为同一事件类型注册多个监听器
// 监听器1：更新UI
await registerDownloadProgressListener(
  dartCallback: (fileName, progress, speed) {
    updateProgressBar(progress);
    return 'UI updated';
  },
);

// 监听器2：记录日志
await registerDownloadProgressListener(
  dartCallback: (fileName, progress, speed) {
    logDownloadProgress(fileName, progress);
    return 'Logged';
  },
);

// 监听器3：发送分析数据
await registerDownloadProgressListener(
  dartCallback: (fileName, progress, speed) {
    sendAnalytics('download_progress', {
      'file': fileName,
      'progress': progress,
    });
    return 'Analytics sent';
  },
);
```

### 4. 事件数据结构化

```rust
// 对于复杂数据，建议使用JSON格式
let notification_data = serde_json::json!({
    "title": "下载完成",
    "message": "文件已保存到下载文件夹",
    "level": "success",
    "actions": [
        {"label": "打开文件夹", "action": "open_folder"},
        {"label": "关闭", "action": "dismiss"}
    ]
}).to_string();

send_system_notification(
    "下载完成".to_string(),
    notification_data,
    "success".to_string(),
).await?;
```

```dart
// Dart 端解析结构化数据
await registerSystemNotificationListener(
  dartCallback: (title, message, level) {
    try {
      final data = jsonDecode(message);
      showAdvancedNotification(
        title: data['title'],
        message: data['message'],
        level: data['level'],
        actions: List<Map<String, String>>.from(data['actions'] ?? []),
      );
    } catch (e) {
      // 降级处理：显示简单通知
      showSimpleNotification(title, message, level);
    }
    return 'Notification processed';
  },
);
```

## 🔍 调试和监控

### 1. 事件监听器统计

```dart
void printEventStats() {
  final stats = getEventStats();
  final data = jsonDecode(stats);
  print('下载进度监听器: ${data['download_progress_listeners']}');
  print('系统通知监听器: ${data['system_notification_listeners']}');
  print('用户操作监听器: ${data['user_action_listeners']}');
  print('错误监听器: ${data['error_listeners']}');
}
```

### 2. 事件响应监控

```dart
await registerDownloadProgressListener(
  dartCallback: (fileName, progress, speed) {
    final startTime = DateTime.now();
    
    try {
      // 处理事件
      updateDownloadProgress(fileName, progress, speed);
      
      final duration = DateTime.now().difference(startTime);
      if (duration.inMilliseconds > 100) {
        print('警告: 下载进度处理耗时 ${duration.inMilliseconds}ms');
      }
      
      return 'Success in ${duration.inMilliseconds}ms';
    } catch (e) {
      return 'Error: $e';
    }
  },
);
```

## 🚨 注意事项

1. **异步处理**: 所有事件处理都是异步的，确保正确使用 `await`
2. **错误处理**: 在 Dart 回调中要妥善处理异常，避免崩溃
3. **内存泄漏**: 在应用关闭时记得清理事件监听器
4. **性能考虑**: 避免在事件处理中执行耗时操作
5. **线程安全**: Rust 端的事件发送是线程安全的，但 Dart 端的处理需要注意 UI 线程

## 📖 完整示例

查看项目中的示例文件：
- `lib/examples/event_system_example.dart` - 完整的 Flutter 页面示例
- `rust/src/api/event_api.rs` - Rust API 实现
- `rust/src/event/` - 事件系统核心实现

这个事件系统为 Flutter 和 Rust 之间提供了强大而灵活的单向通信能力，特别适合需要实时通知和状态更新的应用场景。