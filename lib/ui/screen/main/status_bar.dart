import 'dart:io';
import 'package:aml/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// 状态栏组件
/// 实现了PreferredSizeWidget接口以指定首选高度
class StatusBar extends StatefulWidget implements PreferredSizeWidget {
  const StatusBar({super.key});

  // 统一的状态栏高度常量
  static const double kStatusBarHeight = 48;

  /// 指定状态栏的首选高度
  @override
  Size get preferredSize => const Size.fromHeight(kStatusBarHeight);

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: StatusBar.kStatusBarHeight,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              // 设置behavior确保即使在透明区域也能捕获手势事件
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) {
                if (Platform.isWindows ||
                    Platform.isMacOS ||
                    Platform.isLinux) {
                  windowManager.startDragging();
                }
              },
              // 使用Container代替SizedBox，并设置behavior确保整个区域可点击
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent, // 透明背景但可以接收事件
                // 使用Stack代替Align，确保整个区域都能响应手势
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.transparent, // 确保整个区域都能接收事件
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [colorScheme.error, colorScheme.tertiary],
                          ).createShader(bounds),
                          child: const Text(
                            "ASTRAL MCL",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const _DownloaderStatusButton(),
          // 占位 15宽度
          const SizedBox(width: 15),
          // 游戏状态显示
          const _GameStatus(),
          // 占位 15宽度
          const SizedBox(width: 15),
          // 最小化按钮
          CustomButton(
            icon: Icons.horizontal_rule,
            onTap: () {
              if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
                windowManager.minimize();
              }
            },
          ),
          // 最大化/还原按钮
          const _MaximizeButton(),
          // 关闭按钮
          CustomButton(
            icon: Icons.close,
            hoverBackgroundColor: const Color(0xFFD93E5D),
            hoverIconColor: const Color(0xFF000000),
            onTap: () {
              if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
                windowManager.close();
              }
            },
          ),
        ],
      ),
    );
  }
}

// _GameStatus
class _GameStatus extends StatefulWidget {
  const _GameStatus();

  @override
  State<_GameStatus> createState() => _GameStatusState();
}

class _GameStatusState extends State<_GameStatus> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.tertiaryContainer.withAlpha(100),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.videogame_asset,
              color: colorScheme.tertiaryContainer.withAlpha(100)),
          const SizedBox(width: 8),
          Text(
            "游戏状态：运行中",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// 下载器状态按钮
class _DownloaderStatusButton extends StatefulWidget {
  const _DownloaderStatusButton();

  @override
  State<_DownloaderStatusButton> createState() =>
      _DownloaderStatusButtonState();
}

class _DownloaderStatusButtonState extends State<_DownloaderStatusButton> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CustomButton(
      icon: Icons.download,
      size: ButtonSize.medium,
      hoverIconColor: colorScheme.onTertiary.withAlpha(200),
      IconColor: colorScheme.onTertiary.withAlpha(200),
      onTap: () {
        // TODO: Implement download functionality
      },
    );
  }
}

/// 最大化/还原按钮组件
/// 根据窗口是否最大化显示不同的图标
class _MaximizeButton extends StatefulWidget {
  const _MaximizeButton();

  @override
  State<_MaximizeButton> createState() => _MaximizeButtonState();
}

class _MaximizeButtonState extends State<_MaximizeButton> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    _checkWindowState();
    // 注册窗口事件监听器
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    // 移除窗口事件监听器
    windowManager.removeListener(this);
    super.dispose();
  }

  // 窗口最大化事件回调
  @override
  void onWindowMaximize() {
    setState(() {
      _isMaximized = true;
    });
  }

  // 窗口还原事件回调
  @override
  void onWindowUnmaximize() {
    setState(() {
      _isMaximized = false;
    });
  }

  // 检查窗口状态并更新图标
  Future<void> _checkWindowState() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final maximized = await windowManager.isMaximized();
      if (maximized != _isMaximized) {
        setState(() {
          _isMaximized = maximized;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      icon: _isMaximized ? Icons.filter_none : Icons.crop_square_outlined,
      onTap: () async {
        if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          if (_isMaximized) {
            await windowManager.unmaximize();
          } else {
            await windowManager.maximize();
          }
          // 操作后更新状态
          _checkWindowState();
        }
      },
    );
  }
}
