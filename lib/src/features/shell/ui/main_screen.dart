import 'package:aml/app/app_store.dart';
import 'package:aml/src/shared/widgets/components/app_bar/status_bar.dart';
import 'package:aml/src/shared/widgets/components/navigation/side_navigation.dart';
import 'package:aml/src/shared/widgets/components/overlays/progress_box.dart';
import 'package:aml/src/app/state/progress_state.dart';
import 'package:aml/src/features/debug/ui/debug_console_overlay.dart';
import 'package:aml/src/features/shell/main_navigation.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:signals_flutter/signals_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _getCurrentPage() {
    final currentPage = AppStore().navigation.currentPage.watch(context);
    final selectedIndex =
        MainNavigationConfig.pages.indexWhere((page) => page.id == currentPage);

    return IndexedStack(
      index: selectedIndex != -1 ? selectedIndex : 0,
      children: MainNavigationConfig.pages.map((pageConfig) {
        return Offstage(
          offstage: pageConfig.id != currentPage,
          child: pageConfig.page,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    final showDebug = AppStore().settings.ui.showDebugConsole.watch(context);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: const StatusBar(),
      body: Stack(
        children: [
          Row(
            children: [
              SideNavigation(colorScheme: colorScheme),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(2, 2),
                        blurRadius: 6,
                        spreadRadius: 5,
                        color: Color.fromARGB(47, 0, 0, 0),
                        inset: true,
                      ),
                    ],
                    border: Border(
                      left: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 128),
                        width: 1,
                      ),
                      top: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 128),
                        width: 1,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: _getCurrentPage(),
                ),
              ),
            ],
          ),
          if (ProgressStore().progressVisibility.watch(context))
            const ProgressBox(),
          if (showDebug)
            const Positioned(
              right: 30,
              bottom: 30,
              child: DebugConsoleOverlay(),
            ),
        ],
      ),
    );
  }
}
