#[flutter_rust_bridge::frb(sync)]
/// 问候函数
/// 
/// # 参数
/// * `name` - 要问候的人的名字
/// 
/// # 返回值
/// * 返回一个包含问候语的字符串
pub fn greet(name: String) -> String {
    // 使用format!宏格式化问候语
    format!("Hello, {name}!")
}

/// 初始化应用程序
/// 
/// 这个函数用于初始化应用程序，设置默认的用户工具。
/// 
/// # 注意
/// 这个函数必须在应用程序的入口点调用。
#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
