import 'package:aml/app/app_store.dart';
import 'package:aml/src/shared/widgets/components/inputs/input_bar.dart';
import 'package:aml/src/shared/widgets/components/navigation/nav_rect_button.dart';
import 'package:aml/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ResourceSettingsPage extends StatefulWidget {
  const ResourceSettingsPage({super.key});

  @override
  State<ResourceSettingsPage> createState() => _ResourceSettingsPageState();
}

class _ResourceSettingsPageState extends State<ResourceSettingsPage> {
  final _appStore = AppStore().settings.resource;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '数据目录',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '在这里管理游戏资源和文件',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Theme.of(context)
                  .colorScheme
                  .tertiaryContainer
                  .withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Watch(
                  (_) {
                    final currentPath =
                        _appStore.resourceDirectory.watch(context);
                    if (_controller.text != currentPath) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _controller.text = currentPath;
                      });
                    }
                    return InputBarWidget(
                      colorScheme: Theme.of(context).colorScheme,
                      size: InputBarSize.medium,
                      hintText: '选择数据目录路径',
                      controller: _controller,
                      onChanged: (value) =>
                          _appStore.resourceDirectory.value = value,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              NavRectButton(
                text: "目录",
                defaultBackgroundColor: AppColors.neutralPanel,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icons.folder_open,
                isSelected: false,
                width: 80,
                onMouseEnter: () {},
                onMouseExit: () {},
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
