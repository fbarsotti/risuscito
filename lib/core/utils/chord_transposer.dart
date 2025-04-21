// lib/core/utils/chord_transposer.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

// === COLORI PERSONALIZZABILI ===
const defaultChordColor = '#A13F3C'; // colore originale accordi
const modifiedColor = '#A13F3C'; // colore accordi trasposti
const barreTextColor = '#A13F3C'; // colore testo "Barré"
// colore di evidenziazione pastel yellow
const highlightBackground = '#FFFACD';

const highlightBackgroundRGB = '161,63,60'; // RGB di #FFFACD
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

Future<String> processSongHtml(String assetPath, String songId) async {
  final html = await rootBundle.loadString(assetPath);
  final transpose = await loadTransposeOffset(songId);
  final barre = await loadBarreOffset(songId);

  final withChords = transposeHtmlChords(html, transpose);
  final withBarre = applyBarreToHtml(withChords, barre);

  return withBarre;
}

String transposeHtmlChords(String html, int semitones) {
  final chordTagRegex = RegExp(r'(<FONT COLOR=\"#A13F3C\">)([^<]+)(</FONT>)');

  return html.replaceAllMapped(chordTagRegex, (match) {
    final rawText = match.group(2)!;
    final transposed = rawText.replaceAllMapped(RegExp(r'(\s+|\S+)'), (m) {
      final token = m.group(0)!;
      if (token.trim().isEmpty) return token;

      // Estrai eventuali caratteri non musicali all’inizio/fine
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

    final color = semitones == 0 ? defaultChordColor : modifiedColor;

    // return '<FONT COLOR="$color"><b>$transposed</b></FONT>';
    // nuovo ritorno: span con solo background
    final bgStyle = semitones == 0
        ? ' style="color: $color;"'
        : ' style="background-color: rgba($highlightBackgroundRGB, $highlightBackgroundOpacity); color: $color;"';

    // : ' style="background-color: $highlightBackground; color: $color;"';
// lasciamo il <b> se vuoi mantenere il grassetto,
// altrimenti puoi tolgerlo
    return '<span$bgStyle><b>$transposed</b></span>';
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

Future<int?> loadBarreOffset(String songId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('barre_offset_$songId');
}

Future<void> saveBarreOffset(int offset, String songId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('barre_offset_$songId', offset);
}

String applyBarreToHtml(String html, int? barreOffset) {
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
      barreOffset == 0 ? 'Senza barré' : 'Barré al ${roman[barreOffset]} tasto';

  final bg = 'rgba($highlightBackgroundRGB, $highlightBackgroundOpacity)';
  final newBarreLine = '''
<H4>
  <span style="background-color: $bg;">
    <FONT COLOR="$barreTextColor"><I>$label</I></FONT>
  </span>
</H4>''';

  // Regex più robusta, che consente tag chiusi male (es. </H2> invece di </I>)
  final barreRegex = RegExp(
    r'<H4>\s*<FONT[^>]*>\s*<I>(Barr[eè] al .*? tasto|Senza barr[eè])<\/I>.*?<\/FONT>\s*<\/H4>',
    caseSensitive: false,
  );

  if (barreRegex.hasMatch(html)) {
    return html.replaceFirst(barreRegex, newBarreLine);
  }

  // Inserimento dopo ultimo </H2>
  final h2CloseMatches =
      RegExp(r'</H2>', caseSensitive: false).allMatches(html).toList();
  if (h2CloseMatches.isNotEmpty) {
    final lastMatch = h2CloseMatches.last;
    final insertIndex = lastMatch.end;
    return html.replaceRange(insertIndex, insertIndex, '\n$newBarreLine');
  }

  // Fallback: inserimento dopo <BODY>
  final bodyTagRegex = RegExp(r'<BODY[^>]*>', caseSensitive: false);
  final bodyMatch = bodyTagRegex.firstMatch(html);
  if (bodyMatch != null) {
    final original = bodyMatch.group(0)!;
    final replacement = '$original\n$newBarreLine';
    return html.replaceFirst(original, replacement);
  }

  return html;
}

Future<void> clearBarreOffset(String songId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('barre_offset_$songId');
}
