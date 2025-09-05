# Rust 事件回调系统使用指南

这个项目实现了一个完整的 Rust 到 Dart 的事件回调系统，允许 Rust 端通过 Dart 闭包回调的方式向 Dart 端发送事件并获得响应。

## 核心概念

### Dart 闭包回调

Rust 可以接收 Dart 闭包作为参数，并在需要时调用这些闭包：

```rust
// Rust 端
pub async fn rust_function(dart_callback: impl Fn(String) -> DartFnFuture<String>) -> String {
    dart_callback("Tom".to_owned()).await
}
```

```dart
// Dart 端
final result = await rustFunction(
  dartCallback: (name) => 'Hello, $name!',
);
// result 将是 "Hello, Tom!"
```

## 支持的事件类型

### 1. 基础回调事件

**Rust API:**
```rust
pub async fn rust_function(dart_callback: impl Fn(String) -> DartFnFuture<String>) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.rustFunction(
  dartCallback: (name) => 'Hello, $name!',
);
```

### 2. 用户操作事件

**Rust API:**
```rust
pub async fn send_user_action_event(
    action: String,
    dart_callback: impl Fn(String) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendUserActionEvent(
  action: '点击了按钮',
  dartCallback: (message) {
    print('用户操作: $message');
    return '操作已处理';
  },
);
```

### 3. 下载进度事件

**Rust API:**
```rust
pub async fn send_download_progress_event(
    file_name: String,
    progress: f64,
    dart_callback: impl Fn(String, f64) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendDownloadProgressEvent(
  fileName: 'file.zip',
  progress: 0.75,
  dartCallback: (fileName, progress) {
    final percent = (progress * 100).toInt();
    print('下载进度: $fileName - $percent%');
    return '进度已更新';
  },
);
```

### 4. 系统通知事件

**Rust API:**
```rust
pub async fn send_system_notification_event(
    title: String,
    message: String,
    dart_callback: impl Fn(String, String) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendSystemNotificationEvent(
  title: '系统通知',
  message: '操作完成',
  dartCallback: (title, message) {
    // 显示通知
    showNotification(title, message);
    return '通知已显示';
  },
);
```

### 5. 批量事件处理

**Rust API:**
```rust
pub async fn send_batch_events(
    events: Vec<String>,
    dart_callback: impl Fn(Vec<String>) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendBatchEvents(
  events: ['事件1', '事件2', '事件3'],
  dartCallback: (eventList) {
    print('批量事件: ${eventList.join(", ")}');
    return '批量事件已处理';
  },
);
```

### 6. 错误事件

**Rust API:**
```rust
pub async fn send_error_event(
    error_code: String,
    error_message: String,
    dart_callback: impl Fn(String) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendErrorEvent(
  errorCode: 'ERR_001',
  errorMessage: '网络连接失败',
  dartCallback: (errorData) {
    showErrorDialog(errorData);
    return '错误已处理';
  },
);
```

### 7. 复杂数据结构事件

**Rust API:**
```rust
pub async fn send_complex_event(
    id: u32,
    name: String,
    metadata: HashMap<String, String>,
    dart_callback: impl Fn(String) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final metadata = {
  'version': '1.0.0',
  'platform': 'flutter',
};

final result = await rust_api.sendComplexEvent(
  id: 123,
  name: '复杂事件',
  metadata: metadata,
  dartCallback: (jsonData) {
    final data = jsonDecode(jsonData);
    print('复杂事件: ${data['name']}');
    return '复杂事件已处理';
  },
);
```

### 8. 定时事件

**Rust API:**
```rust
pub async fn start_periodic_events(
    interval_seconds: u64,
    dart_callback: impl Fn(String) -> DartFnFuture<String> + Send + Sync + 'static,
)
```

**Dart 使用:**
```dart
await rust_api.startPeriodicEvents(
  intervalSeconds: 5,
  dartCallback: (message) {
    print('定时事件: $message');
    return '定时事件已处理';
  },
);
```

## Screeps 游戏风格事件

### 游戏事件

**Rust API:**
```rust
pub async fn send_game_event(
    event_type: String,
    room_name: String,
    tick: u32,
    data: String,
    dart_callback: impl Fn(String, String, u32, String) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendGameEvent(
  eventType: 'ROOM_UPDATE',
  roomName: 'W1N1',
  tick: 12345,
  data: '{"energy": 1000}',
  dartCallback: (eventType, roomName, tick, data) {
    print('游戏事件: $eventType 在房间 $roomName (tick: $tick)');
    return '游戏事件已处理';
  },
);
```

### 资源管理事件

**Rust API:**
```rust
pub async fn send_resource_event(
    resource_type: String,
    amount: i32,
    operation: String, // "harvest", "transfer", "consume"
    dart_callback: impl Fn(String, i32, String) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendResourceEvent(
  resourceType: 'energy',
  amount: 50,
  operation: 'harvest',
  dartCallback: (resourceType, amount, operation) {
    print('资源操作: $operation $amount $resourceType');
    return '资源事件已处理';
  },
);
```

### 建筑事件

**Rust API:**
```rust
pub async fn send_structure_event(
    structure_type: String,
    position: String, // "x,y"
    action: String, // "build", "destroy", "repair"
    dart_callback: impl Fn(String, String, String) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendStructureEvent(
  structureType: 'spawn',
  position: '25,25',
  action: 'build',
  dartCallback: (structureType, position, action) {
    print('建筑操作: $action $structureType 在 $position');
    return '建筑事件已处理';
  },
);
```

### Creep 事件

**Rust API:**
```rust
pub async fn send_creep_event(
    creep_name: String,
    action: String,
    target: String,
    result: String,
    dart_callback: impl Fn(String, String, String, String) -> DartFnFuture<String>,
) -> String
```

**Dart 使用:**
```dart
final result = await rust_api.sendCreepEvent(
  creepName: 'harvester1',
  action: 'harvest',
  target: 'source1',
  result: 'OK',
  dartCallback: (creepName, action, target, result) {
    print('Creep 操作: $creepName $action $target -> $result');
    return 'Creep 事件已处理';
  },
);
```

## 全局事件系统

### 注册全局事件监听器

**Rust API:**
```rust
pub fn register_global_event_listener(
    event_type: String,
    dart_callback: impl Fn(String) -> DartFnFuture<String> + Send + Sync + 'static,
)
```

**Dart 使用:**
```dart
rust_api.registerGlobalEventListener(
  eventType: 'USER_ACTION',
  dartCallback: (payload) {
    print('全局事件: $payload');
    return '全局事件已处理';
  },
);
```

### 发送全局事件

**Rust API:**
```rust
pub async fn send_global_event(event_type: String, payload: String) -> Vec<String>
```

**Dart 使用:**
```dart
final results = await rust_api.sendGlobalEvent(
  eventType: 'USER_ACTION',
  payload: '用户点击了按钮',
);
print('全局事件处理结果: $results');
```

## 完整示例

查看 `lib/examples/rust_event_callback_example.dart` 文件，其中包含了所有事件类型的完整使用示例。

## 技术特点

### 优势

1. **双向通信**: Rust 可以调用 Dart 函数并获得返回值
2. **类型安全**: 强类型参数和返回值
3. **异步支持**: 所有回调都是异步的
4. **灵活性**: 支持多种参数类型和复杂数据结构
5. **游戏友好**: 专门为 Screeps 游戏设计的事件类型

### 使用场景

- **实时通信**: Rust 后端向 Flutter 前端发送实时更新
- **进度报告**: 长时间运行的任务进度更新
- **错误处理**: 统一的错误报告和处理
- **游戏事件**: Screeps 游戏中的各种事件处理
- **用户交互**: 用户操作的反馈和确认

### 注意事项

1. **异步处理**: 所有回调都必须是异步的
2. **错误处理**: 确保在 Dart 回调中正确处理异常
3. **内存管理**: 长时间运行的回调需要注意内存泄漏
4. **线程安全**: 定时事件和全局事件监听器需要考虑线程安全

## 运行示例

1. 确保已运行 `flutter_rust_bridge_codegen generate`
2. 在 Flutter 应用中导入并使用 `RustEventCallbackExample` 组件
3. 点击各种按钮测试不同类型的事件回调

这个系统为 Flutter 和 Rust 之间提供了强大而灵活的双向通信能力，特别适合需要实时交互的应用场景。