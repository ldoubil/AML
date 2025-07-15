import 'package:flutter/material.dart';

/// Light [ColorScheme] made with FlexColorScheme v8.2.0.
/// Requires Flutter 3.22.0 or later.
const ColorScheme lightColorScheme = ColorScheme(
  // 亮度设置为亮色模式
  brightness: Brightness.light,
  // 主要颜色 - 深蓝色
  primary: Color(0xFF00296B),
  // 在主要颜色上的文字颜色 - 白色
  onPrimary: Color(0xFFFFFFFF),
  // 主要颜色的容器颜色 - 浅蓝色
  primaryContainer: Color(0xFFA0C2ED),
  // 在主要容器上的文字颜色 - 黑色
  onPrimaryContainer: Color(0xFF000000),
  // 固定主要颜色 - 淡蓝灰色
  primaryFixed: Color(0xFFBFCFE8),
  // 暗淡的固定主要颜色
  primaryFixedDim: Color(0xFF8CA8D3),
  // 在固定主要颜色上的文字颜色
  onPrimaryFixed: Color(0xFF000307),
  // 在固定主要颜色变体上的文字颜色
  onPrimaryFixedVariant: Color(0xFF000A19),
  // 次要颜色 - 橙色
  secondary: Color(0xFFD26900),
  // 在次要颜色上的文字颜色 - 白色
  onSecondary: Color(0xFFFFFFFF),
  // 次要颜色的容器颜色 - 浅黄色
  secondaryContainer: Color(0xFFFFD270),
  // 在次要容器上的文字颜色 - 黑色
  onSecondaryContainer: Color(0xFF000000),
  // 固定次要颜色 - 米色
  secondaryFixed: Color(0xFFFEDEBF),
  // 暗淡的固定次要颜色
  secondaryFixedDim: Color(0xFFF3C08C),
  // 在固定次要颜色上的文字颜色
  onSecondaryFixed: Color(0xFF4F2800),
  // 在固定次要颜色变体上的文字颜色
  onSecondaryFixedVariant: Color(0xFF613000),
  // 第三颜色 - 紫色
  tertiary: Color(0xFF5C5C95),
  // 在第三颜色上的文字颜色 - 白色
  onTertiary: Color(0xFFFFFFFF),
  // 第三颜色的容器颜色 - 淡蓝色
  tertiaryContainer: Color(0xFFC8DBF8),
  // 在第三容器上的文字颜色 - 黑色
  onTertiaryContainer: Color(0xFF000000),
  // 固定第三颜色 - 淡紫色
  tertiaryFixed: Color(0xFFDBDBE9),
  // 暗淡的固定第三颜色
  tertiaryFixedDim: Color(0xFFB7B7D2),
  // 在固定第三颜色上的文字颜色
  onTertiaryFixed: Color(0xFF27273E),
  // 在固定第三颜色变体上的文字颜色
  onTertiaryFixedVariant: Color(0xFF2D2D4A),
  // 错误颜色 - 红色
  error: Color(0xFFB00020),
  // 在错误颜色上的文字颜色 - 白色
  onError: Color(0xFFFFFFFF),
  // 错误颜色的容器颜色 - 浅粉色
  errorContainer: Color(0xFFFCD9DF),
  // 在错误容器上的文字颜色 - 黑色
  onErrorContainer: Color(0xFF000000),
  // 表面颜色 - 近白色
  surface: Color(0xFFFCFCFC),
  // 在表面上的文字颜色 - 深灰色
  onSurface: Color(0xFF111111),
  // 暗淡的表面颜色
  surfaceDim: Color(0xFFE0E0E0),
  // 明亮的表面颜色
  surfaceBright: Color(0xFFFDFDFD),
  // 最低层表面容器颜色 - 白色
  surfaceContainerLowest: Color(0xFFFFFFFF),
  // 低层表面容器颜色
  surfaceContainerLow: Color(0xFFF8F8F8),
  // 表面容器颜色
  surfaceContainer: Color(0xFFF3F3F3),
  // 高层表面容器颜色
  surfaceContainerHigh: Color(0xFFEDEDED),
  // 最高层表面容器颜色
  surfaceContainerHighest: Color(0xFFE7E7E7),
  // 表面变体上的文字颜色
  onSurfaceVariant: Color(0xFF393939),
  // 轮廓颜色
  outline: Color(0xFF919191),
  // 轮廓变体颜色
  outlineVariant: Color(0xFFD1D1D1),
  // 阴影颜色 - 黑色
  shadow: Color(0xFF000000),
  // 遮罩颜色 - 黑色
  scrim: Color(0xFF000000),
  // 反转表面颜色 - 深灰色
  inverseSurface: Color(0xFF2A2A2A),
  // 在反转表面上的文字颜色 - 浅灰色
  onInverseSurface: Color(0xFFF1F1F1),
  // 反转主要颜色 - 浅蓝色
  inversePrimary: Color(0xFF8DACDD),
  // 表面色调 - 深蓝色
  surfaceTint: Color(0xFF00296B),
);

/// Dark [ColorScheme] made with FlexColorScheme v8.2.0.
/// Requires Flutter 3.22.0 or later.
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF26292f),
  onPrimary: Color(0xFF000000),
  primaryContainer: Color(0xFF3873BA),
  onPrimaryContainer: Color(0xFFFFFFFF),
  primaryFixed: Color(0xFFBFCFE8),
  primaryFixedDim: Color(0xFF8CA8D3),
  onPrimaryFixed: Color(0xFF000307),
  onPrimaryFixedVariant: Color(0xFF000A19),
  secondary: Color(0xFFFFD270),
  onSecondary: Color(0xFF000000),
  secondaryContainer: Color(0xFFD26900),
  onSecondaryContainer: Color(0xFFFFFFFF),
  secondaryFixed: Color(0xFFFEDEBF),
  secondaryFixedDim: Color(0xFFF3C08C),
  onSecondaryFixed: Color(0xFF4F2800),
  onSecondaryFixedVariant: Color(0xFF613000),
  tertiary: Color(0xFFC9CBFC),
  onTertiary: Color(0xFF000000),
  tertiaryContainer: Color(0xFF535393),
  onTertiaryContainer: Color(0xFFFFFFFF),
  tertiaryFixed: Color(0xFFDBDBE9),
  tertiaryFixedDim: Color(0xFFB7B7D2),
  onTertiaryFixed: Color(0xFF27273E),
  onTertiaryFixedVariant: Color(0xFF2D2D4A),
  error: Color(0xFFCF6679),
  onError: Color(0xFF000000),
  errorContainer: Color(0xFFB1384E),
  onErrorContainer: Color(0xFFFFFFFF),
  surface: Color(0xFF16181c),
  // surface: Color.fromARGB(0, 133, 123, 123),
  onSurface: Color(0xFFF1F1F1),
  surfaceDim: Color(0xFF060606),
  surfaceBright: Color(0xFF2C2C2C),
  surfaceContainerLowest: Color(0xFF010101),
  surfaceContainerLow: Color(0xFF0E0E0E),
  surfaceContainer: Color(0xFF151515),
  surfaceContainerHigh: Color(0xFF1D1D1D),
  surfaceContainerHighest: Color(0xFF282828),
  onSurfaceVariant: Color(0xFFCACACA),
  outline: Color(0xFF777777),
  outlineVariant: Color(0xFF414141),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE8E8E8),
  onInverseSurface: Color(0xFF2A2A2A),
  inversePrimary: Color(0xFF515D6B),
  surfaceTint: Color(0xFFB1CFF5),
);
