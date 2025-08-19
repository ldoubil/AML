use crate::minecraft::mc::{
    Argument, ArgumentType, Library, VersionInfo, VersionType,
};
use chrono::{DateTime, NaiveDateTime, Utc};
use serde::{Deserialize, Deserializer, Serialize};
use std::collections::HashMap;

/// fabric模型结构体反序列化到的最新格式版本
pub const CURRENT_FABRIC_FORMAT_VERSION: usize = 0;
/// forge模型结构体反序列化到的最新格式版本
pub const CURRENT_FORGE_FORMAT_VERSION: usize = 0;
/// quilt模型结构体反序列化到的最新格式版本
pub const CURRENT_QUILT_FORMAT_VERSION: usize = 0;
/// neoforge模型结构体反序列化到的最新格式版本
pub const CURRENT_NEOFORGE_FORMAT_VERSION: usize = 0;

/// 应替换库名、inheritsFrom和版本名的占位字符串
pub const DUMMY_REPLACE_STRING: &str = "${modrinth.gameVersion}";

/// 依赖于安装端的数据信息条目
pub struct SidedDataEntry {
    /// 客户端的值
    pub client: String,
    /// 服务端的值
    pub server: String,
}

fn deserialize_date<'de, D>(deserializer: D) -> Result<DateTime<Utc>, D::Error>
where
    D: Deserializer<'de>,
{
    let s = String::deserialize(deserializer)?;

    serde_json::from_str::<DateTime<Utc>>(&format!("\"{s}\""))
        .or_else(|_| {
            NaiveDateTime::parse_from_str(&s, "%Y-%m-%dT%H:%M:%S%.9f")
                .map(|date| date.and_utc())
        })
        .map_err(serde::de::Error::custom)
}

/// fabric meta返回的部分版本信息
pub struct PartialVersionInfo {
    /// 版本ID
    pub id: String,
    /// 此部分版本继承的版本ID
    pub inherits_from: String,
    /// 版本发布时间
    pub release_time: DateTime<Utc>,
    /// 此版本中文件的最新更新时间
    pub time: DateTime<Utc>,
    /// 启动游戏的主类的类路径
    pub main_class: Option<String>,
    /// （旧版）传递给游戏的参数
    pub minecraft_arguments: Option<String>,
    /// 传递给游戏或JVM的参数
    pub arguments: Option<HashMap<ArgumentType, Vec<Argument>>>,
    /// 版本依赖的库
    pub libraries: Vec<Library>,
    /// 版本类型
    pub type_: VersionType,
    /// （仅Forge）数据变量
    pub data: Option<HashMap<String, SidedDataEntry>>,
    /// （仅Forge）下载文件后要运行的处理器列表
    pub processors: Option<Vec<Processor>>,
}

/// 下载文件后要运行的处理器
pub struct Processor {
    /// 此处理器的JAR库的Maven坐标
    pub jar: String,
    /// 运行此处理器时必须包含在classpath中的所有库的Maven坐标
    pub classpath: Vec<String>,
    /// 此处理器的参数
    pub args: Vec<String>,
    /// 输出映射，键和值可以是数据变量
    pub outputs: Option<HashMap<String, String>>,
    /// 此处理器应在哪些端运行
    /// 有效值：client, server, extract
    pub sides: Option<Vec<String>>,
}

/// 将部分版本信息合并为完整版本信息
pub fn merge_partial_version(
    partial: PartialVersionInfo,
    merge: VersionInfo,
) -> VersionInfo {
    let merge_id = merge.id.clone();

    let mut libraries = vec![];

    // 跳过在部分版本中已存在的重复库
    for mut lib in merge.libraries {
        let lib_artifact = lib.name.rsplit_once(':').map(|x| x.0);

        if let Some(lib_artifact) = lib_artifact {
            if !partial.libraries.iter().any(|x| {
                let target_artifact = x.name.rsplit_once(':').map(|x| x.0);

                target_artifact == Some(lib_artifact) && x.include_in_classpath
            }) {
                libraries.push(lib);
            } else {
                lib.include_in_classpath = false;
            }
        } else {
            libraries.push(lib);
        }
    }

    VersionInfo {
        arguments: if let Some(partial_args) = partial.arguments {
            if let Some(merge_args) = merge.arguments {
                let mut new_map = HashMap::new();

                fn add_keys(
                    new_map: &mut HashMap<ArgumentType, Vec<Argument>>,
                    args: HashMap<ArgumentType, Vec<Argument>>,
                ) {
                    for (type_, arguments) in args {
                        for arg in arguments {
                            if let Some(vec) = new_map.get_mut(&type_) {
                                vec.push(arg);
                            } else {
                                new_map.insert(type_.clone(), vec![arg]);
                            }
                        }
                    }
                }

                add_keys(&mut new_map, merge_args);
                add_keys(&mut new_map, partial_args);

                Some(new_map)
            } else {
                Some(partial_args)
            }
        } else {
            merge.arguments
        },
        asset_index: merge.asset_index,
        assets: merge.assets,
        downloads: merge.downloads,
        id: partial.id.replace(DUMMY_REPLACE_STRING, &merge_id),
        java_version: merge.java_version,
        libraries: libraries
            .into_iter()
            .chain(partial.libraries)
            .map(|mut x| {
                x.name = x.name.replace(DUMMY_REPLACE_STRING, &merge_id);

                x
            })
            .collect::<Vec<_>>(),
        logging: merge.logging,
        main_class: if let Some(main_class) = partial.main_class {
            main_class
        } else {
            merge.main_class
        },
        minecraft_arguments: partial.minecraft_arguments,
        minimum_launcher_version: merge.minimum_launcher_version,
        release_time: partial.release_time,
        time: partial.time,
        type_: partial.type_,
        data: partial.data,
        processors: partial.processors,
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
/// 包含模组加载器版本信息的清单
pub struct Manifest {
    /// 模组加载器支持的游戏版本
    pub game_versions: Vec<Version>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
/// Minecraft的游戏版本
pub struct Version {
    /// Minecraft版本ID
    pub id: String,
    /// 是否为稳定版本
    pub stable: bool,
    /// 此游戏版本对应的加载器版本列表
    pub loaders: Vec<LoaderVersion>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
/// Minecraft模组加载器的版本
pub struct LoaderVersion {
    /// 加载器的版本ID
    pub id: String,
    /// 此版本清单的URL
    pub url: String,
    /// 加载器是否为稳定版本
    pub stable: bool,
}