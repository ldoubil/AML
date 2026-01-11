class DebugCommandRegistry {
  static final DebugCommandRegistry _instance =
      DebugCommandRegistry._internal();
  factory DebugCommandRegistry() => _instance;
  DebugCommandRegistry._internal();

  final Map<String, Future<String> Function(List<String> args)> _commands = {};

  DebugCommandRegistry register(
    String name,
    Future<String> Function(List<String> args) handler,
  ) {
    _commands[name] = handler;
    return this;
  }

  Future<String> execute(String input) async {
    final parts =
        input.trim().split(RegExp(r'\s+')).map((e) => e.toString()).toList();
    if (parts.isEmpty || parts[0].isEmpty) return 'Please enter a command.';
    final cmd = parts[0];
    final args =
        parts.length > 1 ? parts.sublist(1).cast<String>() : <String>[];
    final handler = _commands[cmd];
    if (handler == null) return 'Unknown command: $cmd';
    try {
      return await handler(args);
    } catch (e) {
      return 'Command failed: $e';
    }
  }

  List<String> get commandList => _commands.keys.toList();
}
