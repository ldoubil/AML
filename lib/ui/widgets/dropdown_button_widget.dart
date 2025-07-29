import 'package:flutter/material.dart';

/// 下拉菜单项的数据模型
/// 
/// 用于存储下拉菜单中每个选项的显示文本和对应的值
class DropdownItem {
  /// 显示的文本内容
  final String display;
  
  /// 对应的实际值
  final String value;

  /// 创建下拉菜单项
  /// 
  /// [display] 显示的文本内容
  /// [value] 对应的实际值
  const DropdownItem({required this.display, required this.value});
}

/// 自定义下拉按钮组件
/// 
/// 一个功能完整的下拉选择器，支持自定义样式、动画效果和外部点击收起
/// 
/// 特性：
/// - 支持自定义宽度和高度
/// - 平滑的展开/收起动画
/// - 点击外部区域自动收起
/// - 支持前缀文本
/// - 响应式主题适配
class DropdownButtonWidget extends StatefulWidget {
  /// 下拉按钮的宽度，为null时占满可用空间
  final double? width;
  
  /// 下拉按钮的高度，默认为40
  final double height;
  
  /// 下拉菜单的选项列表
  final List<DropdownItem> items;
  
  /// 选项改变时的回调函数
  final ValueChanged<String> onChanged;
  
  /// 颜色方案，用于主题适配
  final ColorScheme colorScheme;
  
  /// 当前选中的值
  final String selectedValue;
  
  /// 显示文本的前缀，可选
  final String? prefix;

  /// 创建下拉按钮组件
  /// 
  /// [width] 组件宽度
  /// [height] 组件高度，默认为40
  /// [items] 下拉选项列表
  /// [onChanged] 选项改变回调
  /// [colorScheme] 颜色方案
  /// [selectedValue] 当前选中的值
  /// [prefix] 显示前缀
  const DropdownButtonWidget({
    super.key,
    this.width,
    this.height = 40,
    required this.items,
    required this.onChanged,
    required this.colorScheme,
    required this.selectedValue,
    this.prefix,
  });

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _animationController.dispose();
    super.dispose();
  }

  /// 切换下拉菜单的显示状态
  /// 
  /// 当菜单打开时，添加全局点击监听器以支持点击外部区域收起
  /// 当菜单关闭时，移除全局点击监听器
  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  /// 打开下拉菜单
  /// 
  /// 创建覆盖层并添加到Overlay中，同时添加全局点击监听器
  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() => _isOpen = true);
  }

  /// 关闭下拉菜单
  /// 
  /// 执行收起动画，完成后移除覆盖层
  void _closeDropdown() {
    _animationController.reverse().then((_) {
      setState(() => _isOpen = false);
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  /// 创建圆角边框
  /// 
  /// [top] 是否包含顶部圆角
  /// [bottom] 是否包含底部圆角
  /// 返回根据参数配置的BorderRadius
  BorderRadius _borderRadius({required bool top, required bool bottom}) {
    return BorderRadius.only(
      topLeft: top ? const Radius.circular(12) : Radius.zero,
      topRight: top ? const Radius.circular(12) : Radius.zero,
      bottomLeft: bottom ? const Radius.circular(12) : Radius.zero,
      bottomRight: bottom ? const Radius.circular(12) : Radius.zero,
    );
  }

  /// 创建下拉菜单的覆盖层
  /// 
  /// 计算组件的位置和尺寸，创建包含所有选项的覆盖层
  /// 添加透明背景以支持点击外部区域收起菜单
  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeDropdown,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    left: offset.dx,
                    width: size.width,
                    child: CompositedTransformFollower(
                      link: _layerLink,
                      offset: Offset(0.0, size.height),
                      showWhenUnlinked: false,
                      child: GestureDetector(
                        onTap: () {}, // 阻止事件冒泡
                        child: SizeTransition(
                          axisAlignment: -1.0,
                          sizeFactor: _expandAnimation,
                          child: Material(
                            elevation: 4.0,
                            borderRadius: _borderRadius(top: false, bottom: true),
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.colorScheme.primaryContainer,
                                borderRadius: _borderRadius(top: false, bottom: true),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: widget.items.length,
                                itemBuilder: (context, index) {
                                  final item = widget.items[index];
                                  final isSelected = widget.selectedValue == item.value;

                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        widget.onChanged(item.value);
                                        _closeDropdown();
                                      },
                                      splashFactory: NoSplash.splashFactory,
                                      highlightColor: Colors.transparent,
                                      hoverColor: widget.colorScheme.primary.withOpacity(
                                        0.05,
                                      ),
                                      child: Container(
                                        height: widget.height,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        color:
                                            isSelected
                                                ? widget.colorScheme.onTertiary
                                                : null,
                                        child: Text(
                                          item.display,
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? widget.colorScheme.primary
                                                    : widget.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  /// 构建下拉按钮的主界面
  /// 
  /// 创建包含当前选中值和展开/收起箭头的按钮
  /// 使用CompositedTransformTarget确保覆盖层正确定位
  @override
  Widget build(BuildContext context) {
    final selectedTextStyle = TextStyle(
      color: widget.colorScheme.onSurfaceVariant,
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleDropdown,
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          borderRadius: _borderRadius(top: true, bottom: !_isOpen),
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.colorScheme.primaryContainer,
              borderRadius: _borderRadius(top: true, bottom: !_isOpen),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.prefix ?? ''}${widget.items.firstWhere((item) => item.value == widget.selectedValue, orElse: () => DropdownItem(display: widget.selectedValue, value: widget.selectedValue)).display}',
                  style: selectedTextStyle,
                ),
                Transform.rotate(
                  angle: _isOpen ? 3.1415926 : 0,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: widget.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
