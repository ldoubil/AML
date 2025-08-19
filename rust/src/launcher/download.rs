use std::option;
use std::sync::atomic::fence;

use chrono::format;

use crate::minecraft::mc::{LatestVersion, Version, VersionInfo, VersionManifest};
use crate::state::State;
use crate::util::fetch; // Add this line if State is defined in crate::state
pub async fn download_client(
    st: &State,
    version_info: &VersionInfo,
    // 目录
    path: &std::path::Path,
    force: bool,
) -> crate::Result<()> {
    // 使用 st 和 version_info 来获取必要的信息
    // 如果 force 为 true，则强制重新下载
    let version = &version_info.id; // 获取版本 ID
    tracing::debug!("正在下载 Minecraft 客户端，版本为 {}", version);
    let path = path.join(format!("{version}.jar"));
    if !path.exists() || force {
        tracing::debug!("下载 Minecraft 客户端到 {}", path.display());
    }
    Ok(())
}
