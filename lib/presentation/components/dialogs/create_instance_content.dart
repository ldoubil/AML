import 'package:aml/presentation/components/buttons/button_group_widget.dart';
import 'package:aml/presentation/components/buttons/custom_button.dart';
import 'package:aml/presentation/components/inputs/input_bar.dart';
import 'package:aml/presentation/components/navigation/nav_rect_button.dart';
import 'package:flutter/material.dart';

class CreateInstanceContent extends StatelessWidget {
  final ColorScheme colorScheme;
  final String selectedVersionType;
  final ValueChanged<String> onVersionTypeChanged;
  final VoidCallback onClose;

  const CreateInstanceContent({
    super.key,
    required this.colorScheme,
    required this.selectedVersionType,
    required this.onVersionTypeChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520,
      height: 630,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SizedBox(
            height: 84,
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  const Text(
                    '创建游戏配置',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    icon: Icons.close,
                    size: ButtonSize.medium,
                    backgroundColor: colorScheme.tertiary.withAlpha(80),
                    onTap: onClose,
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.onSurface.withAlpha(35),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ButtonGroupWidget(
                        items: const [
                          ButtonGroupItem(
                            text: '默认版本',
                            value: 'custom',
                          ),
                          ButtonGroupItem(
                            text: '从文件导入',
                            value: 'from_file',
                          ),
                          ButtonGroupItem(
                            text: '从启动器导入',
                            value: 'from_launcher',
                          ),
                        ],
                        selectedValue: selectedVersionType,
                        onChanged: onVersionTypeChanged,
                        fitContent: true,
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: colorScheme.onSurface.withAlpha(35),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 94,
                            height: 94,
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary,
                              border: Border.all(
                                color: colorScheme.onTertiaryContainer
                                    .withOpacity(0.1),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage('assets/logo.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NavRectButton(
                                isSelected: false,
                                icon: Icons.upload_file,
                                defaultBackgroundColor: colorScheme.onPrimary,
                                text: "选择图标",
                                label: "选择图标",
                                onTap: () {},
                              ),
                              const SizedBox(height: 8),
                              NavRectButton(
                                isSelected: false,
                                icon: Icons.delete_outline,
                                defaultBackgroundColor: colorScheme.onPrimary,
                                text: "选择图标",
                                label: "取消设置",
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        '配置名称',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 9),
                      InputBarWidget(
                        colorScheme: colorScheme,
                        size: InputBarSize.medium,
                        hintText: '输入配置名称',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
