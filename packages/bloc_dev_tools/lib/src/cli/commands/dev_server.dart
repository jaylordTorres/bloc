import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import '../common.dart';

class DevServerCommand extends Command<Null> {
  @override
  String get description => 'starts bloc dev server';

  @override
  String get name => 'dev-server';

  @override
  FutureOr<Null> run() async {
    final String target = '${Directory.current.path}/tool/dev_tools/index.js';

    await runAndStream('node', <String>[target], workingDir: Directory.current);
    return null;
  }
}
