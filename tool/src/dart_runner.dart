import 'dart:convert';
import 'dart:io';

import 'package:rustic/tuple.dart';

abstract class DartCommand {
  final String targetPath;

  String get command;
  List<String> get args;

  const DartCommand._(this.targetPath);

  Future<Tuple2<int, List<String>>> run() async {
    final process = await Process.start('dart', [command, ...args, targetPath]);

    final output = <String>[];

    process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(output.add);
    process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(output.add);

    return Tuple2(await process.exitCode, output);
  }
}

class DartAnalyzeCommand extends DartCommand {
  @override
  String get command => 'analyze';

  @override
  List<String> get args => const [];

  const DartAnalyzeCommand(String targetPath) : super._(targetPath);
}

class DartCompileCommand extends DartCommand {
  @override
  String get command => 'compile';

  @override
  List<String> get args => ['aot-snapshot'];

  const DartCompileCommand(String targetPath) : super._(targetPath);
}

class DartFormatCommand extends DartCommand {
  @override
  String get command => 'format';

  @override
  List<String> get args => const ['--fix', '--line-length=100'];

  const DartFormatCommand(String targetPath) : super._(targetPath);
}

class DartRunCommand extends DartCommand {
  @override
  String get command => 'run';

  @override
  List<String> get args => const [];

  const DartRunCommand(String targetPath) : super._(targetPath);
}

class DartTestCommand extends DartCommand {
  @override
  String get command => 'test';

  @override
  List<String> get args => ['--color'];

  const DartTestCommand(String targetPath) : super._(targetPath);
}
