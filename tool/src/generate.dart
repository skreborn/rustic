import 'dart:io';

import 'dart_runner.dart';

void generate(String path, List<String?> lines) async {
  final file = File('lib/$path.dart');

  final contents = [
    '// GENERATED CONTENT - DO NOT EDIT MANUALLY!',
    null,
    ...lines,
  ].map((line) => line ?? '');

  await file.writeAsString(contents.join('\n'));

  final formatResult = await DartFormatCommand(file.path).run();

  stdout.writeln(formatResult.output.join('\n'));
}
