import 'package:aml/presentation/state/settings/java_settings_state.dart';
import 'package:aml/presentation/state/settings/resource_settings_state.dart';
import 'package:aml/presentation/state/settings/ui_settings_state.dart';

class SettingsRegistry {
  SettingsRegistry._internal();
  static final SettingsRegistry _instance = SettingsRegistry._internal();
  factory SettingsRegistry() => _instance;

  final java = JavaSettingsState();
  final resource = ResourceSettingsState();
  final ui = UiSettingsState();

  Future<void> initialize({required String baseDir}) async {
    await java.initialize(baseDir: baseDir);
    await resource.initialize(baseDir: baseDir);
    await ui.initialize(baseDir: baseDir);
  }

  Future<void> dispose() async {
    await java.dispose();
    await resource.dispose();
    await ui.dispose();
  }
}
