// 自定义 Tooltip 组件
import 'package:flutter/material.dart';
import 'dart:async';

class CustomTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Color backgroundColor;
  final Color textColor;

  const CustomTooltip({
    super.key,
    required this.child,
    required this.message,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _showTimer;
  Timer? _removeTimer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    _removeTimer?.cancel();
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _showTooltip();
      },
      onExit: (_) {
        _removeTooltip();
      },
      child: CompositedTransformTarget(link: _layerLink, child: widget.child),
    );
  }

  void _showTooltip() {
    _removeTimer?.cancel();
    _showTimer?.cancel();
    
    // 延迟 0.3 秒后显示
    _showTimer = Timer(const Duration(milliseconds: 300), () {
      if (_overlayEntry == null) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
        _animationController.forward();
      }
    });
  }

  void _removeTooltip() {
    _showTimer?.cancel();
    _removeTimer?.cancel();
    
    if (_overlayEntry != null) {
      // 渐隐动画
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + size.width + 4,
        top: offset.dy + (size.height / 2) - 30,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
            size.width + 4,
            (size.height / 2) - 18,
          ),
          child: MouseRegion(
            onEnter: (_) {
              _removeTimer?.cancel();
              _showTimer?.cancel();
            },
            onExit: (_) {
              _removeTooltip();
            },
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 添加三角形指示器
                  CustomPaint(
                    size: const Size(8, 16),
                    painter: TrianglePainter(color: widget.backgroundColor),
                  ),
                  Material(
                    elevation: 4.0,
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// 三角形绘制器
class TrianglePainter extends CustomPainter {
  final Color color;
  
  TrianglePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(size.width, size.height / 2 - 8); // 起始点（右上）
    path.lineTo(0, size.height / 2); // 顶点（左中）
    path.lineTo(size.width, size.height / 2 + 8); // 结束点（右下）
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}