# Flutter Rust Bridge 事件系统

这个项目实现了一个完整的 Rust 到 Dart 的事件系统，允许 Rust 端主动向 Dart 端发送各种类型的事件。

## 功能特性

### 支持的事件类型

1. **下载进度事件** (`DownloadProgress`)
   - 文件名
   - 下载进度 (0.0 - 1.0)
   - 下载速度

2. **系统通知事件** (`SystemNotification`)
   - 标题
   - 消息内容
   - 通知级别 (信息/警告/错误/成功)

3. **用户操作事件** (`UserAction`)
   - 操作描述
   - 时间戳

4. **错误事件** (`Error`)
   - 错误代码
   - 错误消息

### 通知级别

- `Info` - 信息
- `Warning` - 警告
- `Error` - 错误
- `Success` - 成功

## 使用方法

### 1. Rust 端 API

#### 初始化事件系统
```rust
// 在 Dart 端调用此函数来初始化事件系统
pub fn init_event_system() -> impl Stream<Item = AppEvent>
```

#### 发送事件的函数
```rust
// 发送通知
pub async fn send_notification(
    title: String,
    message: String,
    level: NotificationLevel,
) -> anyhow::Result<()>

// 发送用户操作事件
pub async fn send_user_action(action: String) -> anyhow::Result<()>

// 发送错误事件
pub async fn send_error(
    error_code: String,
    error_message: String,
) -> anyhow::Result<()>

// 模拟下载任务
pub async fn simulate_download_task(file_name: String) -> anyhow::Result<()>

// 启动心跳
pub async fn start_heartbeat() -> anyhow::Result<()>
```

### 2. Dart 端使用

#### 基本使用示例
```dart
import '../src/rust/api/simple.dart' as rust_api;

// 初始化事件系统
final eventStream = rust_api.initEventSystem();

// 监听事件
eventStream.listen((event) {
  switch (event) {
    case rust_api.AppEvent_DownloadProgress(field0: final progress):
      print('下载进度: ${progress.fileName} - ${(progress.progress * 100).toInt()}%');
      break;
      
    case rust_api.AppEvent_SystemNotification(field0: final notification):
      print('通知: ${notification.title} - ${notification.message}');
      break;
      
    case rust_api.AppEvent_UserAction(field0: final action):
      print('用户操作: ${action.action}');
      break;
      
    case rust_api.AppEvent_Error(field0: final error):
      print('错误: ${error.errorCode} - ${error.errorMessage}');
      break;
  }
});

// 发送通知
await rust_api.sendNotification(
  title: '测试通知',
  message: '这是一个测试消息',
  level: rust_api.NotificationLevel.info,
);
```

#### 完整示例

查看 `lib/examples/event_system_example.dart` 文件，其中包含了一个完整的 Flutter 页面示例，展示了如何：

- 初始化事件系统
- 监听各种类型的事件
- 显示下载进度
- 处理通知和错误
- 记录事件日志

## 运行示例

1. 确保已经运行了 `flutter_rust_bridge_codegen generate` 来生成绑定代码
2. 在你的 Flutter 应用中导入并使用 `EventSystemExample` 组件
3. 点击各种按钮来测试不同类型的事件

## 技术实现

### 核心组件

1. **全局事件发送器** (`EVENT_SINK`)
   - 使用 `Arc<Mutex<Option<StreamSink<AppEvent>>>>` 实现线程安全的全局状态
   - 允许从任何 Rust 函数发送事件到 Dart

2. **事件类型定义**
   - 使用 Rust 枚举定义所有事件类型
   - 自动生成对应的 Dart 类型

3. **异步支持**
   - 所有事件发送函数都是异步的
   - 支持并发事件处理

### 优势

- **类型安全**: 使用强类型系统确保事件数据的正确性
- **高性能**: 基于 Rust 的高性能事件处理
- **易于使用**: 简单的 API 设计，易于集成
- **可扩展**: 容易添加新的事件类型
- **线程安全**: 支持多线程环境下的事件发送

## 注意事项

1. 必须先调用 `init_event_system()` 初始化事件系统
2. 事件发送是异步的，需要使用 `await`
3. 确保在应用关闭时正确清理事件监听器
4. 事件流是单向的（Rust → Dart），如需双向通信请使用其他方法