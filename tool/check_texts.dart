// Fails when an app shows text that isn't in the translations (PHASES 9.1, exit criterion "no
// hard-coded text left"): every word on screen comes from ww_l10n (English, Hindi, Odia).
//
// Run from the project root: `dart tool/check_texts.dart` (also part of `.\ww.ps1 check`).
//
// It looks in the apps' and shared packages' Dart code (not the generated API client or the
// generated translations) for a string literal with letters given to a widget that shows it:
// Text('…') or TextSpan(text: '…'), or a label, hint, title, tooltip, message… parameter, also
// when the formatter put the string on the next line (each file is read whole, comments left
// out). Interpolations (`${x}`) don't count as letters. Brand words and symbols are allowed
// below; anything else that must stay as it is (never shown to people) gets an
// `// i18n-ok: why` comment on one of its lines.
import 'dart:io';

const _folders = [
  'apps/patient_app/lib',
  'apps/partner_app/lib',
  'packages/ww_ui/lib',
  'packages/ww_auth/lib',
  'packages/ww_core/lib',
  'packages/ww_l10n/lib/src',
];

/// Generated code: not written by hand.
bool _skipped(String path) =>
    path.endsWith('.g.dart') || path.contains('${Platform.pathSeparator}generated${Platform.pathSeparator}');

/// Shown as they are in every language: the brand, a country code, a symbol.
const _allowed = {'WellWish', 'Well', 'Wish', 'G', '+91', 'UPI', 'SOS', 'OTP'};

final _shown = RegExp(
  r'''(?:\bText\(\s*|\b(?:label|labelText|hint|hintText|helperText|errorText|prefixText|suffixText|text|title|subtitle|tooltip|message|semanticLabel|semanticsLabel|content|placeholder|counterText)\s*:\s*)(?:const\s+)?('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*")''',
);
final _interpolation = RegExp(r'\$\{[^}]*\}|\$[A-Za-z_]\w*');
final _letter = RegExp(r'[A-Za-z]');

void main() {
  final problems = <String>[];
  for (final folder in _folders) {
    final dir = Directory(folder);
    if (!dir.existsSync()) continue;
    for (final file in dir.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart') || _skipped(file.path)) continue;
      // the whole file at once: a string may sit on the line after `Text(`
      final source = file.readAsStringSync();
      final lines = source.split('\n');
      for (final match in _shown.allMatches(_withoutComments(source))) {
        final literal = match.group(1)!;
        final text = literal.substring(1, literal.length - 1);
        if (_allowed.contains(text)) continue;
        if (!_letter.hasMatch(text.replaceAll(_interpolation, ''))) continue;
        final first = '\n'.allMatches(source.substring(0, match.start)).length;
        final last = '\n'.allMatches(source.substring(0, match.end)).length;
        if (lines.sublist(first, last + 1).any((line) => line.contains('i18n-ok'))) continue;
        problems.add('${file.path.replaceAll(r'\', '/')}:${last + 1}: $literal');
      }
    }
  }
  if (problems.isEmpty) {
    stdout.writeln('No hard-coded text: every word on screen comes from the translations.');
    return;
  }
  stderr.writeln('Text shown on screen must come from ww_l10n (English, Hindi, Odia):');
  for (final problem in problems) {
    stderr.writeln('  $problem');
  }
  stderr.writeln('Add it to the .arb files, or mark a line that is never shown with // i18n-ok: why');
  exitCode = 1;
}

/// The source with every comment blanked out (same length and lines, so a match keeps its line
/// number). Strings are left alone: 'http://…' is not a comment.
String _withoutComments(String source) {
  final out = StringBuffer();
  String? quote; // inside a string: its quote character
  var raw = false;
  var i = 0;
  while (i < source.length) {
    final c = source[i];
    final next = i + 1 < source.length ? source[i + 1] : '';
    if (quote != null) {
      out.write(c);
      if (c == r'\' && !raw && next.isNotEmpty) {
        out.write(next);
        i += 2;
        continue;
      }
      if (c == quote) quote = null;
      i++;
      continue;
    }
    if (c == '/' && next == '/') {
      while (i < source.length && source[i] != '\n') {
        out.write(' ');
        i++;
      }
      continue;
    }
    if (c == '/' && next == '*') {
      while (i < source.length && !(source[i] == '*' && i + 1 < source.length && source[i + 1] == '/')) {
        out.write(source[i] == '\n' ? '\n' : ' ');
        i++;
      }
      out.write('  ');
      i += 2;
      continue;
    }
    if (c == "'" || c == '"') {
      quote = c;
      raw = i > 0 && source[i - 1] == 'r';
    }
    out.write(c);
    i++;
  }
  return out.toString();
}
