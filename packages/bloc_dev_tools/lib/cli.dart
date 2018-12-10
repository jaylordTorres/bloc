import 'dart:io';

import 'package:args/command_runner.dart';

import './src/cli/commands/commands.dart';

void main(List<String> args) {
  final CommandRunner<Null> commandRunner = CommandRunner<Null>(
      'bloc_dev_tools', 'command line interface for the bloc library')
    ..addCommand(DevServerCommand());

  commandRunner.run(args).catchError((Object e) {
    stderr.writeln(e.toString());
  });
}
