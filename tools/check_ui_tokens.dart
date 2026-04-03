import 'dart:io';

final targetFolders = ['lib/'];

final includePatterns = [
  RegExp(r'/presentation/'),
  RegExp(r'/views/'),
  RegExp(r'/widgets/'),
  RegExp(r'/pages/'),
];

final numberRegex = RegExp(r'(?<![\w\$])\d+(?:\.\d+)?(?![\w\$])');
final ignoreKeywords = [
  'AppSpacing',
  'AppDimensions',
  'AppRadius',
  'AppColors',
  'AppTypography',
];

// If a file contains this marker anywhere, the checker will skip the file.
const ignoreFileMarker = '// UI_TOKENS_IGNORE';
const ignoreLineMarker = '// UI_TOKENS_IGNORE_LINE';

bool isInTarget(String path) {
  return includePatterns.any((p) => p.hasMatch(path));
}

bool shouldIgnoreLine(String line) {
  // ignore comments
  final trimmed = line.trim();
  // ignore single-line marker
  if (line.contains(ignoreLineMarker)) return true;
  if (trimmed.startsWith('//') ||
      trimmed.startsWith('/*') ||
      trimmed.startsWith('*')) {
    return true;
  }
  // ignore lines that already use tokens
  if (ignoreKeywords.any((k) => line.contains(k))) return true;
  return false;
}

void main() {
  final files = <File>[];

  for (final folder in targetFolders) {
    final dir = Directory(folder);
    if (!dir.existsSync()) {
      continue;
    }
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final normalized = entity.path.replaceAll('\\', '/');
        if (isInTarget(normalized)) {
          files.add(entity);
        }
      }
    }
  }

  var found = false;
  for (final file in files) {
    final content = file.readAsStringSync();
    if (content.contains(ignoreFileMarker)) continue;

    final lines = content.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (shouldIgnoreLine(line)) continue;
      final matches = numberRegex.allMatches(line);
      if (matches.isNotEmpty) {
        // Heuristic: ignore numbers that are part of import/package versions or asset paths
        final hasPathLike =
            line.contains('assets/') ||
            line.contains('package:') ||
            line.contains('pubspec');
        if (hasPathLike) continue;

        // Report
        stdout.writeln('${file.path}:${i + 1}: ${line.trim()}');
        found = true;
      }
    }
  }

  if (found) {
    stderr.writeln(
      '\nFound hard-coded numeric literals in presentation files.',
    );
    stderr.writeln(
      'Please use AppSpacing/AppDimensions/AppRadius/AppColors/AppTypography tokens from lib/core/ui.',
    );
    exit(1);
  } else {
    stdout.writeln(
      'No hard-coded numeric literals found in targeted presentation files.',
    );
    exit(0);
  }
}
