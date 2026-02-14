// lib/core/utils/chord_transposer.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

// === COLORI PERSONALIZZABILI ===
const defaultChordColor = '#A13F3C'; // colore originale accordi
const barreTextColor = '#A13F3C'; // colore testo "Barré"

const highlightBackgroundRGB = '161,63,60'; // RGB highlight accordi trasposti
const highlightBackgroundOpacity = 0.1; // 10% di opacità

const _sharpScale = [
  'C',
  'C#',
  'D',
  'Eb',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'Bb',
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
  'Mib': 'Eb',
  'Mi': 'E',
  'Fa': 'F',
  'Fa#': 'F#',
  'Sol': 'G',
  'Sol#': 'G#',
  'La': 'A',
  'Sib': 'Bb',
  'Si': 'B',
};

const _englishToItalian = {
  'C': 'Do',
  'C#': 'Do#',
  'D': 'Re',
  'Eb': 'Mib',
  'E': 'Mi',
  'F': 'Fa',
  'F#': 'Fa#',
  'G': 'Sol',
  'G#': 'Sol#',
  'A': 'La',
  'Bb': 'Sib',
  'B': 'Si',
};

String transposeChord(String chord, int semitones) {
  chord = chord.trim();

  // Detect lowercase root (Ukrainian minor notation: d = Dm, g = Gm)
  final isLowerCase =
      chord.isNotEmpty && chord[0].toLowerCase() == chord[0] && chord[0].toUpperCase() != chord[0];
  final workingChord = isLowerCase
      ? chord[0].toUpperCase() + chord.substring(1)
      : chord;

  // Lista ordinata per lunghezza decrescente per match più specifici prima (es. "Do#" prima di "Do")
  final allRoots = [
    ..._italianToEnglish.keys,
    ..._sharpScale,
    ..._flatToSharp.keys
  ]..sort((a, b) => b.length.compareTo(a.length));

  for (final root in allRoots) {
    if (workingChord.startsWith(root)) {
      final suffix = workingChord.substring(root.length);
      final isItalian = _italianToEnglish.containsKey(root);
      final englishRoot =
          isItalian ? _italianToEnglish[root]! : _normalize(root);
      final index = _sharpScale.indexOf(englishRoot);
      if (index == -1) return chord;

      final newIndex = (index + semitones) % 12;
      final transposed = _sharpScale[newIndex < 0 ? newIndex + 12 : newIndex];
      var finalChord = isItalian
          ? (_englishToItalian[transposed] ?? transposed)
          : transposed;

      // Restore lowercase if original was lowercase (Ukrainian minor)
      if (isLowerCase) {
        finalChord = finalChord[0].toLowerCase() + finalChord.substring(1);
      }

      return '$finalChord$suffix';
    }
  }

  return chord;
}

String _normalize(String note) {
  if (_sharpScale.contains(note)) return note;
  return _flatToSharp[note] ?? note;
}

Future<String> processSongHtml(
  String assetPath,
  String songId, {
  required String barreLabel,
  required String noBarreLabel,
}) async {
  final results = await Future.wait([
    rootBundle.loadString(assetPath),
    loadTransposeOffset(songId),
    loadBarreOffset(songId),
  ]);

  final html = results[0] as String;
  final transpose = results[1] as int;
  final barre = results[2] as int?;

  final withChords = transposeHtmlChords(html, transpose);
  final withBarre = applyBarreToHtml(
    withChords,
    barre,
    barreLabel: barreLabel,
    noBarreLabel: noBarreLabel,
  );

  return withBarre;
}

/// Optimized version that accepts pre-loaded HTML and offsets,
/// avoiding redundant asset reads and SharedPreferences lookups.
String processSongHtmlDirect(
  String html, {
  required int transposeOffset,
  required int? barreOffset,
  required String barreLabel,
  required String noBarreLabel,
}) {
  final withChords = transposeHtmlChords(html, transposeOffset);
  return applyBarreToHtml(
    withChords,
    barreOffset,
    barreLabel: barreLabel,
    noBarreLabel: noBarreLabel,
  );
}

String transposeHtmlChords(String html, int semitones) {
  final chordTagRegex = RegExp(r'(<FONT COLOR=\"#A13F3C\">)([^<]+)(</FONT>)');

  var result = html.replaceAllMapped(chordTagRegex, (match) {
    final rawText = match.group(2)!;

    final transposed = rawText.replaceAllMapped(RegExp(r'(\s+|\S+)'), (m) {
      final token = m.group(0)!;
      if (token.trim().isEmpty) return token;

      // Estrai eventuali caratteri non musicali all'inizio/fine
      final match =
          RegExp(r'^([^\w♯#♭b\/]*)([A-Za-zàèéìòù#♯b♭\/0-9]+)([^\w♯#♭b\/]*)$')
              .firstMatch(token);

      if (match != null) {
        final prefix = match.group(1)!;
        final core = match.group(2)!;
        final suffix = match.group(3)!;

        // Gestione accordi con slash
        final parts = core.split('/');
        final transposedParts =
            parts.map((part) => transposeChord(part, semitones)).toList();
        final transposedChord = transposedParts.join('/');

        return '$prefix$transposedChord$suffix';
      }

      return token;
    });

    return '<FONT COLOR="$defaultChordColor">$transposed</FONT>';
  });

  // Badge "+N" / "-N" sulla stessa riga del titolo, a destra
  if (semitones != 0) {
    final sign = semitones > 0 ? '+' : '';
    final badge =
        '<span style="float: right; background-color: rgba($highlightBackgroundRGB, $highlightBackgroundOpacity); color: $defaultChordColor; padding: 2px 8px; border-radius: 4px; font-size: 20px; font-weight: bold; margin-top: 2px; margin-right: 8px;">$sign$semitones</span>';
    // Inserisci prima del primo <H2>
    final h2Regex = RegExp(r'<H2>', caseSensitive: false);
    final h2Match = h2Regex.firstMatch(result);
    if (h2Match != null) {
      result = result.replaceRange(h2Match.start, h2Match.start, badge);
    }
  }

  return result;
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

Future<int?> loadBarreOffset(String songId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('barre_offset_$songId');
}

Future<void> saveBarreOffset(int offset, String songId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('barre_offset_$songId', offset);
}

String applyBarreToHtml(
  String html,
  int? barreOffset, {
  required String barreLabel,
  required String noBarreLabel,
}) {
  if (barreOffset == null) return html;

  const roman = [
    '',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI',
    'XII'
  ];

  final label =
      barreOffset == 0 ? noBarreLabel : barreLabel.replaceAll('%s', roman[barreOffset]);

  final bg = 'rgba($highlightBackgroundRGB, $highlightBackgroundOpacity)';
  final newBarreLine = '''
<H4>
  <span style="background-color: $bg;">
    <FONT COLOR="$barreTextColor"><I>$label</I></FONT>
  </span>
</H4>''';

  // Language-independent regex: match any <H4> block containing <FONT> + <I>
  final barreRegex = RegExp(
    r'<H4>\s*(?:<span[^>]*>\s*)?(?:<FONT[^>]*>\s*)?<I>.*?</I>.*?</H4>',
    caseSensitive: false,
  );

  // Only remove the matched H4 if it sits between the title headers and the
  // first verse (a "real" barré line). Informational notes buried inside <PRE>
  // at the bottom of the song are kept as-is.
  final match = barreRegex.firstMatch(html);
  String base = html;

  if (match != null) {
    final lastH2 = RegExp(r'</H2>', caseSensitive: false)
        .allMatches(html)
        .toList();
    final firstH3 = RegExp(r'<H3>', caseSensitive: false).firstMatch(html);
    if (lastH2.isNotEmpty &&
        firstH3 != null &&
        match.start >= lastH2.last.end &&
        match.end <= firstH3.start) {
      base = html.replaceFirst(barreRegex, '');
    }
  }

  // Insert after last </H2> (standard position: between title and first verse)
  final h2CloseMatches =
      RegExp(r'</H2>', caseSensitive: false).allMatches(base).toList();
  if (h2CloseMatches.isNotEmpty) {
    final lastMatch = h2CloseMatches.last;
    final insertIndex = lastMatch.end;
    return base.replaceRange(insertIndex, insertIndex, '\n$newBarreLine');
  }

  // Fallback: inserimento dopo <BODY>
  final bodyTagRegex = RegExp(r'<BODY[^>]*>', caseSensitive: false);
  final bodyMatch = bodyTagRegex.firstMatch(base);
  if (bodyMatch != null) {
    final original = bodyMatch.group(0)!;
    final replacement = '$original\n$newBarreLine';
    return base.replaceFirst(original, replacement);
  }

  return base;
}

Future<void> clearBarreOffset(String songId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('barre_offset_$songId');
}
