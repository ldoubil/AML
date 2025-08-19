/// Minecraft版本类型枚举
enum VersionType {
  /// 主版本，稳定，所有玩家可用
  release,

  /// 实验性版本，用于功能预览和测试
  snapshot,

  /// 游戏发布前的最早版本
  oldAlpha,

  /// 游戏早期版本
  oldBeta,
}

/// 下载类型枚举
enum DownloadType {
  /// 游戏客户端
  client,

  /// 客户端映射文件
  clientMappings,

  /// 游戏服务端
  server,

  /// 服务端映射文件
  serverMappings,

  /// Windows 服务端
  windowsServer,
}

/// 文件下载信息
class Download {
  /// 文件的 SHA1 哈希值
  final String sha1;

  /// 文件大小
  final int size;

  /// 文件下载链接
  final String url;

  Download({
    required this.sha1,
    required this.size,
    required this.url,
  });
}

/// 功能规则信息
class FeatureRule {
  /// 是否为演示用户
  final bool? isDemoUser;

  /// 是否使用自定义分辨率
  final bool? hasCustomResolution;

  /// 启动器是否支持快速启动
  final bool? hasQuickPlaysSupport;

  /// 是否启动单人世界
  final bool? isQuickPlaySingleplayer;

  /// 是否启动多人世界
  final bool? isQuickPlayMultiplayer;

  /// 是否启动 realms 世界
  final bool? isQuickPlayRealms;

  FeatureRule({
    this.isDemoUser,
    this.hasCustomResolution,
    this.hasQuickPlaysSupport,
    this.isQuickPlaySingleplayer,
    this.isQuickPlayMultiplayer,
    this.isQuickPlayRealms,
  });
}

/// 操作系统枚举
enum Os {
  /// MacOS (x86)
  osx,

  /// M1 架构 Mac
  osxArm64,

  /// Windows (x86)
  windows,

  /// Windows ARM
  windowsArm64,

  /// Linux (x86) 及其衍生版
  linux,

  /// Linux ARM 64
  linuxArm64,

  /// Linux ARM 32
  linuxArm32,

  /// 未知操作系统
  unknown,
}

/// 库文件下载信息
class LibraryDownload {
  /// 库文件保存路径
  final String? path;

  /// 库文件 SHA1 哈希值
  final String sha1;

  /// 库文件大小
  final int size;

  /// 库文件下载链接
  final String url;

  LibraryDownload({
    this.path,
    required this.sha1,
    required this.size,
    required this.url,
  });
}

/// 游戏依赖库下载信息
class LibraryDownloads {
  /// 主库文件下载信息
  final LibraryDownload? artifact;

  /// 需要额外下载的条件文件（key 为分类器）
  final Map<String, LibraryDownload>? classifiers;

  LibraryDownloads({
    this.artifact,
    this.classifiers,
  });
}

/// 库文件解压信息
class LibraryExtract {
  /// 解压时排除的文件/文件夹
  final List<String>? exclude;

  LibraryExtract({
    this.exclude,
  });
}

/// 游戏依赖库信息
class Library {
  /// 库文件下载信息
  final LibraryDownloads? downloads;

  /// 库文件解压规则
  final LibraryExtract? extract;

  /// Maven 名称（格式：groupId:artifactId:version）
  final String name;

  /// 库文件下载仓库链接
  final String? url;

  /// 库依赖的原生文件（key 为操作系统）
  final Map<Os, String>? natives;

  /// 决定库是否下载的规则
  final List<FeatureRule>? rules;

  /// SHA1 校验和（仅 Forge 库有）
  final List<String>? checksums;

  /// 是否在游戏启动时加入 classpath
  final bool includeInClasspath;

  /// 是否需要下载
  final bool downloadable;

  Library({
    this.downloads,
    this.extract,
    required this.name,
    this.url,
    this.natives,
    this.rules,
    this.checksums,
    required this.includeInClasspath,
    required this.downloadable,
  });
}

/// 单个版本信息
class Version {
  /// 版本唯一标识符
  final String id;

  /// 版本类型
  final VersionType type;

  /// 指向该版本更多信息的链接
  final String url;

  /// 最近一次更新的时间
  final DateTime time;

  /// 发布的时间
  final DateTime releaseTime;

  /// 附加信息的 SHA1 哈希值
  final String sha1;

  /// 是否支持最新的玩家安全功能
  final int complianceLevel;

  /// （Modrinth 提供）原始未修改的 Minecraft versions JSON 的 SHA1 哈希值
  final String? originalSha1;

  Version({
    required this.id,
    required this.type,
    required this.url,
    required this.time,
    required this.releaseTime,
    required this.sha1,
    required this.complianceLevel,
    this.originalSha1,
  });
}

/// 版本清单
class VersionManifest {
  /// 最新版本信息
  final LatestVersion latest;

  /// 所有版本列表
  final List<Version> versions;

  VersionManifest({
    required this.latest,
    required this.versions,
  });
}

/// 最新版本信息
class LatestVersion {
  /// 最新发布版本的 ID
  final String release;

  /// 可用版本列表
  final List<String> versions;

  LatestVersion({
    required this.release,
    required this.versions,
  });
}

/// Java 版本信息
class JavaVersion {
  /// Java 安装所需组件
  final String component;

  /// Java 主版本号
  final int majorVersion;

  JavaVersion({
    required this.component,
    required this.majorVersion,
  });
}

/// 参数类型枚举
enum ArgumentType {
  /// 传递给游戏的参数
  game,

  /// 传递给 JVM 的参数
  jvm,
}

/// 规则动作枚举
enum RuleAction {
  /// 允许
  allow,

  /// 禁止
  disallow,
}

/// 操作系统规则
class OsRule {
  /// 操作系统类型
  final Os? name;

  /// 操作系统版本
  final String? version;

  /// 操作系统架构
  final String? arch;

  OsRule({
    this.name,
    this.version,
    this.arch,
  });
}

/// 规则信息
class Rule {
  /// 规则动作
  final RuleAction action;

  /// 操作系统规则
  final OsRule? os;

  /// 功能规则
  final FeatureRule? features;

  Rule({
    required this.action,
    this.os,
    this.features,
  });
}

/// 参数值容器
abstract class ArgumentValue {
  const ArgumentValue();
}

class SingleArgumentValue extends ArgumentValue {
  final String value;
  const SingleArgumentValue(this.value);
}

class ManyArgumentValue extends ArgumentValue {
  final List<String> values;
  const ManyArgumentValue(this.values);
}

/// 参数定义
abstract class Argument {
  const Argument();
}

class NormalArgument extends Argument {
  final String value;
  const NormalArgument(this.value);
}

class RuledArgument extends Argument {
  final List<Rule> rules;
  final ArgumentValue value;
  const RuledArgument({
    required this.rules,
    required this.value,
  });
}

/// 游戏资源索引信息
class AssetIndex {
  /// 资源对应的游戏版本 ID
  final String id;

  /// 资源索引的 SHA1 哈希值
  final String sha1;

  /// 资源索引文件大小
  final int size;

  /// 该版本资源总大小
  final int totalSize;

  /// 资源索引文件下载链接
  final String url;

  AssetIndex({
    required this.id,
    required this.sha1,
    required this.size,
    required this.totalSize,
    required this.url,
  });
}

/// 依赖于安装端的数据信息条目
class SidedDataEntry {
  /// 客户端的值
  final String client;

  /// 服务端的值
  final String server;

  SidedDataEntry({
    required this.client,
    required this.server,
  });
}

/// 下载文件后要运行的处理器
class Processor {
  /// 此处理器的JAR库的Maven坐标
  final String jar;

  /// 运行此处理器时必须包含在classpath中的所有库的Maven坐标
  final List<String> classpath;

  /// 此处理器的参数
  final List<String> args;

  /// 输出映射，键和值可以是数据变量
  final Map<String, String>? outputs;

  /// 此处理器应在哪些端运行
  /// 有效值：client, server, extract
  final List<String>? sides;

  Processor({
    required this.jar,
    required this.classpath,
    required this.args,
    this.outputs,
    this.sides,
  });
}

/// 版本详细信息
class VersionInfo {
  /// 传递给游戏或 JVM 的参数
  final Map<ArgumentType, List<Argument>>? arguments;

  /// 游戏资源索引
  final AssetIndex assetIndex;

  /// 资源版本 ID
  final String assets;

  /// 版本下载信息
  final Map<DownloadType, Download> downloads;

  /// 版本 ID
  final String id;

  /// 支持的 Java 版本
  final JavaVersion? javaVersion;

  /// 依赖库列表
  final List<Library> libraries;

  /// 日志配置数据
  // final Map<LoggingSide, LoggingConfiguration>? logging;

  /// 游戏主类 classpath
  final String mainClass;

  /// （旧版）传递给游戏的参数
  final String? minecraftArguments;

  /// 可运行该版本的 Minecraft Launcher 最低版本
  final int minimumLauncherVersion;

  /// 版本发布时间
  final DateTime releaseTime;

  /// 版本文件最近更新时间
  final DateTime time;

  /// 版本类型
  final VersionType type;

  /// （仅 Forge）数据
  final Map<String, SidedDataEntry>? data;

  /// （仅 Forge）下载文件后需运行的处理器列表
  final List<Processor>? processors;

  VersionInfo({
    this.arguments,
    required this.assetIndex,
    required this.assets,
    required this.downloads,
    required this.id,
    this.javaVersion,
    required this.libraries,
    // this.logging,
    required this.mainClass,
    this.minecraftArguments,
    required this.minimumLauncherVersion,
    required this.releaseTime,
    required this.time,
    required this.type,
    this.data,
    this.processors,
  });
}

class MinecraftUtil {
  /// 将版本类型转为字符串
  static String versionTypeToString(VersionType type) {
    switch (type) {
      case VersionType.release:
        return "release";
      case VersionType.snapshot:
        return "snapshot";
      case VersionType.oldAlpha:
        return "oldAlpha";
      case VersionType.oldBeta:
        return "oldBeta";
    }
  }
}
