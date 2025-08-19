use std::collections::HashMap;
use crate::minecraft::modded::{
    Processor,
    SidedDataEntry
};
use chrono::{DateTime, Utc};

/// 版本类型枚举
pub enum VersionType {
    /// 主版本，稳定，所有玩家可用
    Release,
    /// 实验性版本，用于功能预览和测试
    Snapshot,
    /// 游戏发布前的最早版本
    OldAlpha,
    /// 游戏早期版本
    OldBeta,
}

impl VersionType {
    /// 将版本类型转换为字符串
    pub fn as_str(&self) -> &'static str {
        match self {
            VersionType::Release => "release",
            VersionType::Snapshot => "snapshot",
            VersionType::OldAlpha => "old_alpha",
            VersionType::OldBeta => "old_beta",
        }
    }
}

/// 单个版本信息
pub struct Version {
    /// 版本唯一标识符
    pub id: String,
    /// 版本类型
    pub type_: VersionType,
    /// 指向该版本更多信息的链接
    pub url: String,
    /// 最近一次更新的时间
    pub time: DateTime<Utc>,
    /// 发布的时间
    pub release_time: DateTime<Utc>,
    /// 附加信息的 SHA1 哈希值
    pub sha1: String,
    /// 是否支持最新的玩家安全功能
    pub compliance_level: u32,
    /// （Modrinth 提供）原始未修改的 Minecraft versions JSON 的 SHA1 哈希值
    pub original_sha1: Option<String>,
}

/// 最新版本信息
pub struct LatestVersion {
    /// 最新发布版本的 ID
    pub release: String,
    /// 可用版本列表
    pub versions: Vec<String>,
}

/// 版本清单
pub struct VersionManifest {
    /// 最新版本信息
    pub latest: LatestVersion,
    /// 所有版本列表
    pub versions: Vec<Version>,
}

/// 下载类型枚举
pub enum DownloadType {
    /// 游戏客户端
    Client,
    /// 客户端映射文件
    ClientMappings,
    /// 游戏服务端
    Server,
    /// 服务端映射文件
    ServerMappings,
    /// Windows 服务端
    WindowsServer,
}

/// 参数类型枚举
#[derive(Eq, PartialEq, Hash, Clone)]
pub enum ArgumentType {
    /// 传递给游戏的参数
    Game,
    /// 传递给 JVM 的参数
    Jvm,
}

/// 参数值容器
pub enum ArgumentValue {
    /// 单个参数
    Single(String),
    /// 多个参数
    Many(Vec<String>),
}

/// 参数定义
pub enum Argument {
    /// 无条件应用的参数
    Normal(String),
    /// 有条件应用的参数
    Ruled {
        /// 决定参数是否应用的规则
        rules: Vec<Rule>,
        /// 参数值容器
        value: ArgumentValue,
    },
}

/// 游戏资源索引信息
pub struct AssetIndex {
    /// 资源对应的游戏版本 ID
    pub id: String,
    /// 资源索引的 SHA1 哈希值
    pub sha1: String,
    /// 资源索引文件大小
    pub size: u32,
    /// 该版本资源总大小
    pub total_size: u32,
    /// 资源索引文件下载链接
    pub url: String,
}

/// 文件下载信息
pub struct Download {
    /// 文件的 SHA1 哈希值
    pub sha1: String,
    /// 文件大小
    pub size: u32,
    /// 文件下载链接
    pub url: String,
}

/// 库文件下载信息
pub struct LibraryDownload {
    /// 库文件保存路径
    pub path: Option<String>,
    /// 库文件 SHA1 哈希值
    pub sha1: String,
    /// 库文件大小
    pub size: u32,
    /// 库文件下载链接
    pub url: String,
}

/// 库文件解压信息
pub struct LibraryExtract {
    /// 解压时排除的文件/文件夹
    pub exclude: Option<Vec<String>>,
}

/// 库文件下载集合
pub struct LibraryDownloads {
    /// 主库文件
    pub artifact: Option<LibraryDownload>,
    /// 需要额外下载的条件文件（key 为分类器）
    pub classifiers: Option<HashMap<String, LibraryDownload>>,
}

/// 规则动作枚举
pub enum RuleAction {
    /// 允许
    Allow,
    /// 禁止
    Disallow,
}

/// 操作系统规则
pub struct OsRule {
    /// 操作系统名称
    pub name: Option<Os>,
    /// 操作系统版本（通常为正则表达式）
    pub version: Option<String>,
    /// 操作系统架构
    pub arch: Option<String>,
}

/// 启动器功能规则
pub struct FeatureRule {
    /// 是否为演示用户
    pub is_demo_user: Option<bool>,
    /// 是否使用自定义分辨率
    pub has_custom_resolution: Option<bool>,
    /// 启动器是否支持快速启动
    pub has_quick_plays_support: Option<bool>,
    /// 是否启动单人世界
    pub is_quick_play_singleplayer: Option<bool>,
    /// 是否启动多人世界
    pub is_quick_play_multiplayer: Option<bool>,
    /// 是否启动 realms 世界
    pub is_quick_play_realms: Option<bool>,
}

/// 规则定义（决定文件下载、参数使用等）
pub struct Rule {
    /// 规则动作
    pub action: RuleAction,
    /// 操作系统规则
    pub os: Option<OsRule>,
    /// 功能规则
    pub features: Option<FeatureRule>,
}

/// 操作系统枚举
pub enum Os {
    /// MacOS (x86)
    Osx,
    /// M1 架构 Mac
    OsxArm64,
    /// Windows (x86)
    Windows,
    /// Windows ARM
    WindowsArm64,
    /// Linux (x86) 及其衍生版
    Linux,
    /// Linux ARM 64
    LinuxArm64,
    /// Linux ARM 32
    LinuxArm32,
    /// 未知操作系统
    Unknown,
}

/// 游戏依赖库信息
pub struct Library {
    /// 库文件下载信息
    pub downloads: Option<LibraryDownloads>,
    /// 库文件解压规则
    pub extract: Option<LibraryExtract>,
    /// Maven 名称（格式：groupId:artifactId:version）
    pub name: String,
    /// 库文件下载仓库链接
    pub url: Option<String>,
    /// 库依赖的原生文件（key 为操作系统）
    pub natives: Option<HashMap<Os, String>>,
    /// 决定库是否下载的规则
    pub rules: Option<Vec<Rule>>,
    /// SHA1 校验和（仅 Forge 库有）
    pub checksums: Option<Vec<String>>,
    /// 是否在游戏启动时加入 classpath
    pub include_in_classpath: bool,
    /// 是否需要下载
    pub downloadable: bool,
}

/// Java 版本信息
pub struct JavaVersion {
    /// Java 安装所需组件
    pub component: String,
    /// Java 主版本号
    pub major_version: u32,
}

/// 日志配置物理侧枚举
pub enum LoggingSide {
    /// 客户端日志配置
    Client,
}

/// 日志配置枚举
pub enum LoggingConfiguration {
    /// 使用 log4j2 XML 日志配置文件
    Log4j2Xml {
        /// JVM 参数，用于传递日志配置文件
        argument: String,
        /// 日志配置文件下载信息
        file: LogConfigDownload,
    },
}

/// 日志配置文件下载信息
pub struct LogConfigDownload {
    /// 日志配置文件保存路径
    pub id: String,
    /// 日志配置文件 SHA1 哈希值
    pub sha1: String,
    /// 日志配置文件大小
    pub size: u32,
    /// 日志配置文件下载链接
    pub url: String,
}

/// 版本详细信息
pub struct VersionInfo {
    /// 传递给游戏或 JVM 的参数
    pub arguments: Option<HashMap<ArgumentType, Vec<Argument>>>,
    /// 游戏资源索引
    pub asset_index: AssetIndex,
    /// 资源版本 ID
    pub assets: String,
    /// 版本下载信息
    pub downloads: HashMap<DownloadType, Download>,
    /// 版本 ID
    pub id: String,
    /// 支持的 Java 版本
    pub java_version: Option<JavaVersion>,
    /// 依赖库列表
    pub libraries: Vec<Library>,
    /// 日志配置数据
    pub logging: Option<HashMap<LoggingSide, LoggingConfiguration>>,
    /// 游戏主类 classpath
    pub main_class: String,
    /// （旧版）传递给游戏的参数
    pub minecraft_arguments: Option<String>,
    /// 可运行该版本的 Minecraft Launcher 最低版本
    pub minimum_launcher_version: u32,
    /// 版本发布时间
    pub release_time: DateTime<Utc>,
    /// 版本文件最近更新时间
    pub time: DateTime<Utc>,
    /// 版本类型
    pub type_: VersionType,
    /// （仅 Forge）数据
    pub data: Option<HashMap<String, SidedDataEntry>>,
    /// （仅 Forge）下载文件后需运行的处理器列表
    pub processors: Option<Vec<Processor>>,
}