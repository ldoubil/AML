import 'package:aml/src/app/state/navigation_state.dart';
import 'package:aml/src/app/state/runtime_state.dart';
import 'package:aml/src/features/settings/application/settings_registry.dart';
import 'package:path_provider/path_provider.dart';

class AppStore {
  AppStore._internal();
  static final AppStore _instance = AppStore._internal();
  factory AppStore() => _instance;

  final navigation = NavigationState();
  final runtime = RuntimeState();
  final settings = SettingsRegistry();

  Future<void> initialize() async {
    final directory = await getApplicationSupportDirectory();
    runtime.appDataDirectory.value = directory.path;
    await settings.initialize(baseDir: directory.path);
  }

  Future<void> dispose() async {
    await settings.dispose();
  }
}

