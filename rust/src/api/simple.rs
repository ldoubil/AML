

/// 初始化应用程序
/// 
/// 这个函数用于初始化应用程序，设置默认的用户工具。
/// 
/// # 注意
/// 这个函数必须在应用程序的入口点调用。
#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
