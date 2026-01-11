import 'package:signals_flutter/signals_flutter.dart';

class MinecraftState {
  MinecraftState._internal();

  static final MinecraftState _instance = MinecraftState._internal();

  factory MinecraftState() {
    return _instance;
  }

  // Modrinth 网站主页 URL
  final modrinthUrl = signal<String>("https://modrinth.com/");

  // Modrinth API v2 版本的基础 URL
  final modrinthApiUrl = signal<String>("https://api.modrinth.com/v2/");

  // Modrinth API v3 版本的基础 URL
  final modrinthApiUrlV3 = signal<String>("https://api.modrinth.com/v3/");

  // Modrinth WebSocket 服务地址
  final modrinthSocketUrl = signal<String>("wss://api.modrinth.com/");

  // Modrinth 启动器元数据地址
  final metaUrl = signal<String>("https://launcher-meta.modrinth.com/");

  // Fabric 当前格式版本
  final currentFabricFormatVersion = signal<int>(0);

  // Forge 当前格式版本
  final currentForgeFormatVersion = signal<int>(0);

  // Quilt 当前格式版本
  final currentQuiltFormatVersion = signal<int>(0);

  // NeoForge 当前格式版本
  final currentNeoForgeFormatVersion = signal<int>(0);

  // 通用格式版本
  final currentFormatVersion = signal<int>(0);
}
