import 'dart:async';
import 'dart:io';

class ToolExit extends Error {
  ToolExit(this.exitCode);

  final int exitCode;
}

String _getErrorString(String executable, List<String> args,
    {Directory workingDir}) {
  final String workdir = workingDir == null ? '' : ' in ${workingDir.path}';
  return 'ERROR: Unable to execute "$executable ${args.join(' ')}"$workdir.';
}

/// It runs the given [executable] command with the different [args] passed.
/// If the command needs to be executed on a certain [Directory], you can use an
/// optional [workingDir]; if you want to exit when an error is found, set
/// [exitOnError] to `true`.
Future<int> runAndStream(String executable, List<String> args,
    {Directory workingDir, bool exitOnError: false}) async {
  print('executable $executable args: $args');
  final Process process =
      await Process.start(executable, args, workingDirectory: workingDir?.path);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  if (exitOnError && await process.exitCode != 0) {
    final String error =
        _getErrorString(executable, args, workingDir: workingDir);
    print('$error See above for details.');
    throw new ToolExit(await process.exitCode);
  }
  return process.exitCode;
}
