import 'package:hive/hive.dart';
part 'app_base_state.g.dart';

@HiveType(typeId: 0)
class AppBaseState {
  @HiveField(0)
  String? appDataDirectory ;

  @HiveField(1)
  String? java8Directory;

  @HiveField(2)
  String? java17Directory;

  @HiveField(3)
  String? java21Directory;

  AppBaseState({
    String? appDataDirectory,
    this.java8Directory,
    this.java17Directory,
    this.java21Directory,
  });

  AppBaseState copyWith({
    String? appDataDirectory,
    String? java8Directory,
    String? java17Directory,
    String? java21Directory,
  }) {
    return AppBaseState(
      appDataDirectory: appDataDirectory ?? this.appDataDirectory,
      java8Directory: java8Directory ?? this.java8Directory,
      java17Directory: java17Directory ?? this.java17Directory,
      java21Directory: java21Directory ?? this.java21Directory,
    );
  }
}

