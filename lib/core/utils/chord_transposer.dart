// lib/core/utils/chord_transposer.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

const _sharpScale = [
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'A#',
  'B'
];

const _flatToSharp = {
  'Db': 'C#',
  'Eb': 'D#',
  'Gb': 'F#',
  'Ab': 'G#',
  'Bb': 'A#'
};

const _italianToEnglish = {
  'Do': 'C',
  'Do#': 'C#',
  'Re': 'D',
  'Re#': 'D#',
  'Mi': 'E',
  'Fa': 'F',
  'Fa#': 'F#',
  'Sol': 'G',
  'Sol#': 'G#',
  'La': 'A',
  'La#': 'A#',
  'Si': 'B',
};

const _englishToItalian = {
  'C': 'Do',
  'C#': 'Do#',
  'D': 'Re',
  'D#': 'Re#',
  'E': 'Mi',
  'F': 'Fa',
  'F#': 'Fa#',
  'G': 'Sol',
  'G#': 'Sol#',
  'A': 'La',
  'A#': 'La#',
  'B': 'Si',
};

String transposeChord(String chord, int semitones) {
  chord = chord.trim();

  // Lista ordinata per lunghezza decrescente per match più specifici prima (es. "Do#" prima di "Do")
  final allRoots = [
    ..._italianToEnglish.keys,
    ..._sharpScale,
    ..._flatToSharp.keys
  ]..sort((a, b) => b.length.compareTo(a.length));

  for (final root in allRoots) {
    if (chord.startsWith(root)) {
      final suffix = chord.substring(root.length);
      final isItalian = _italianToEnglish.containsKey(root);
      final englishRoot =
          isItalian ? _italianToEnglish[root]! : _normalize(root);
      final index = _sharpScale.indexOf(englishRoot);
      if (index == -1) return chord;

      final newIndex = (index + semitones) % 12;
      final transposed = _sharpScale[newIndex < 0 ? newIndex + 12 : newIndex];
      final finalChord = isItalian
          ? (_englishToItalian[transposed] ?? transposed)
          : transposed;
      return '$finalChord$suffix';
    }
  }

  return chord;
}

String _normalize(String note) {
  return _flatToSharp[note] ?? note;
}

String transposeHtmlChords(String html, int semitones) {
  final chordTagRegex = RegExp(r'(<FONT COLOR=\"#A13F3C\">)([^<]+)(</FONT>)');

  return html.replaceAllMapped(chordTagRegex, (match) {
    final rawText = match.group(2)!;
    final transposed = rawText.replaceAllMapped(RegExp(r'(\s+|\S+)'), (m) {
      final token = m.group(0)!;
      return token.trim().isEmpty ? token : transposeChord(token, semitones);
    });

    final color = semitones == 0 ? "#A13F3C" : "#0080FF";
    return '<FONT COLOR="$color"><b>$transposed</b></FONT>';
  });
}

Future<int> loadTransposeOffset(String songId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('transpose_offset_$songId') ?? 0;
}

Future<void> saveTransposeOffset(int offset, String songId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('transpose_offset_$songId', offset);
}

Future<String> loadAndTransposeHtml(String assetPath, String songId) async {
  final offset = await loadTransposeOffset(songId);
  final html = await rootBundle.loadString(assetPath);
  return transposeHtmlChords(html, offset);
}
