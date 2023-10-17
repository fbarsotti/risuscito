enum Note { C, Cs, D, Eb, E, F, Fs, G, Gs, A, Bb, B }

extension NoteExtension on Note {
  String getLocalizedNote(String localization) {
    switch (localization) {
      case 'en':
        return NoteConverter.localizedNotes[this]!.latinValue!;
      default:
        return NoteConverter.localizedNotes[this]!.solfegeValue!;
    }
  }
}

class LocalizedNote {
  Note? note;
  String? latinValue;
  String? solfegeValue;

  LocalizedNote({
    this.note,
    this.latinValue,
    this.solfegeValue,
  });
}

class NoteConverter {
  static final Map<Note, LocalizedNote> localizedNotes = {
    Note.C: LocalizedNote(
      note: Note.C,
      latinValue: 'C',
      solfegeValue: 'Do',
    ),
    Note.Cs: LocalizedNote(
      note: Note.Cs,
      latinValue: 'C#',
      solfegeValue: 'Do#',
    ),
    Note.D: LocalizedNote(
      note: Note.D,
      latinValue: 'D',
      solfegeValue: 'Re',
    ),
    Note.Eb: LocalizedNote(
      note: Note.Eb,
      latinValue: 'Eb',
      solfegeValue: 'Mib',
    ),
    Note.E: LocalizedNote(
      note: Note.E,
      latinValue: 'E',
      solfegeValue: 'Mi',
    ),
    Note.F: LocalizedNote(
      note: Note.F,
      latinValue: 'F',
      solfegeValue: 'Fa',
    ),
    Note.Fs: LocalizedNote(
      note: Note.Fs,
      latinValue: 'F#',
      solfegeValue: 'Fa#',
    ),
    Note.G: LocalizedNote(
      note: Note.G,
      latinValue: 'G',
      solfegeValue: 'Sol',
    ),
    Note.Gs: LocalizedNote(
      note: Note.Gs,
      latinValue: 'G#',
      solfegeValue: 'Sol#',
    ),
    Note.A: LocalizedNote(
      note: Note.A,
      latinValue: 'A',
      solfegeValue: 'La',
    ),
    Note.Bb: LocalizedNote(
      note: Note.Bb,
      latinValue: 'Bb',
      solfegeValue: 'Sib',
    ),
    Note.B: LocalizedNote(
      note: Note.B,
      latinValue: 'B',
      solfegeValue: 'Si',
    ),
  };

  static final Map<String, Note> latinNotes = {
    'C': Note.C,
    'C#': Note.Cs,
    'Db': Note.Cs,
    'D': Note.D,
    'D#': Note.Eb,
    'Eb': Note.Eb,
    'E': Note.E,
    // for certain scales, this may happen, but should not in neocat songs
    'Fb': Note.E,
    'F': Note.F,
    'F#': Note.Fs,
    'Gb': Note.Fs,
    'G': Note.G,
    'G#': Note.Gs,
    'Ab': Note.Gs,
    'A': Note.A,
    'A#': Note.Bb,
    'Bb': Note.Bb,
    'B': Note.B,
    // for certain scales, this may happen, but should not in neocat songs
    'B#': Note.C,
  };

  static final Map<String, Note> solfegeNotes = {
    'Do': Note.C,
    'Do#': Note.Cs,
    'Reb': Note.Cs,
    'Re': Note.D,
    'Re#': Note.Eb,
    'Mib': Note.Eb,
    'Mi': Note.E,
    // for certain scales, this may happen, but should not in neocat songs
    'Fab': Note.E,
    'Fa': Note.F,
    'Fa#': Note.Fs,
    'Solb': Note.Fs,
    'Sol': Note.G,
    'Sol#': Note.Gs,
    'Lab': Note.Gs,
    'La': Note.A,
    'La#': Note.Bb,
    'Sib': Note.Bb,
    'Si': Note.B,
    // for certain scales, this may happen, but should not in neocat songs
    'Si#': Note.C,
  };

  static Note fromString(String noteName) {
    final normalizedNoteName =
        noteName.trim().replaceAll('b', 's').replaceAll('b', 's');
    if (latinNotes.containsKey(normalizedNoteName)) {
      return latinNotes[normalizedNoteName]!;
    }
    throw Exception('Invalid note name: $noteName');
  }
}

class ChordTransposer {
  List<Note> transposeNotes(List<Note> chord, int semitoneOffset) {
    return chord.map((note) => _transposeNote(note, semitoneOffset)).toList();
  }

  Note transposeNote(Note note, int semitoneOffset) {
    return transposeNote(note, semitoneOffset);
  }

  Note _transposeNote(Note note, int semitoneOffset) {
    final values = Note.values;
    final index = values.indexOf(note);
    final transposedIndex = (index + semitoneOffset) % values.length;
    return values[transposedIndex];
  }
}
