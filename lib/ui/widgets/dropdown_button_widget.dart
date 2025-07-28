import 'package:flutter/material.dart';

class DropdownItem {
  final String display;
  final String value;

  const DropdownItem({required this.display, required this.value});
}

class DropdownButtonWidget extends StatefulWidget {
  final double? width;
  final double height;
  final List<DropdownItem> items;
  final ValueChanged<String> onChanged;
  final ColorScheme colorScheme;
  final String selectedValue;
  final String? prefix;

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

  void _toggleDropdown() {
    if (_isOpen) {
      _animationController.reverse().then((_) {
        setState(() => _isOpen = false);
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward();
      setState(() => _isOpen = true);
    }
  }

  BorderRadius _borderRadius({required bool top, required bool bottom}) {
    return BorderRadius.only(
      topLeft: top ? const Radius.circular(12) : Radius.zero,
      topRight: top ? const Radius.circular(12) : Radius.zero,
      bottomLeft: bottom ? const Radius.circular(12) : Radius.zero,
      bottomRight: bottom ? const Radius.circular(12) : Radius.zero,
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx,
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0.0, size.height),
              showWhenUnlinked: false,
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
                              _toggleDropdown();
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
    );
  }

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
