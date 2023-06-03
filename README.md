# risuscito

A new Flutter application for the Neocatechumenal Way.

## Getting Started

Project structure:
<pre>
  lib
  ├── core
  │  ├── lots_of_goodies
  ├── feature
     ├── feature1
        ├── data
        ├── domain
        ├── presentation
</pre>

## Adding a new language

### 1. Translationss
Inside `i18n` folder, create a json with a 2 letter code of your language

Example: `i18n/en.json`
<pre>
{
   "key": "Translation"
   ...
}
</pre>

In the code, you must add in the language_bloc logic at `/lib/core/infrastructure/localization/bloc/language_bloc.dart`
<pre>
   ... else if (event.languageCode == Language.uk &&
          defaultLanguageCode != '$languageCode') {
        final locale = Locale('your_language_code', '$languageCodeZone');
        await sharedPrefService.setLanguage(locale.languageCode);
        emit(LanguageState(locale));
      }
</pre>
... and to the list in `/lib/feature/settings/sections/settings_language.dart`
<pre>
      RSLanguage(
        '$languageCode',
        AppLocalizations.of(context)!.translate('$languageCode'),
        Language.languageEnum,
      ),
</pre>
... and in `/lib/core/rs_app.dart`
<pre>
  static List<Locale> get supportedLocales {
    return [
      Locale('en', 'US'),
      Locale('it', 'IT'),
      // add your language
      Locale('$languageCode', '$languageCodeZone'),
    ];
  }
</pre>
... and in `/lib/core/infrastructure/localization/app_localizations.dart`
<pre>
  @override
  bool isSupported(Locale locale) {
    return ['en', 'it', 'your_language_code'].contains(locale.languageCode);
  }
</pre>

### 2. Files
Inside `assets/data/` you can find two other folders:
<pre>
  assets
  ├──images
     ├──...
  ├──data
     ├── songs_raw
     │  ├── all_songs_contents
     ├── songs_values
        ├── values-en
           ├── all_songs_values
</pre>

- Folder `songs_raw`: here you can find all songs HTML files, each file must have the same name as the other file contents, and the HTML content should remain pretty much the same.
- Folder `songs_values`: **IMPORTANT**: For all files ONLY TAG CONTENTS must be translated, not tag names. You will find as follow these files:

1. **LINK.XML** --> It contains the links to the recordings. For each song, you must put inside each tag the link to the ONLINE recording. If it's not present you can leave the TAG empty (like the UK and EN versions)
 
2. **NOMI_LITURGICI.XML** --> It contains the names of the Liturgic Index sections (for example some liturgic periods, or celebration parts)
 
3. **PAGINE.XML** --> It contains the pages of the songs in your version of the songbook.

4. **INDICE_BIBLICO.XML** --> It contains the songs titles used in Biblic Index (those with the bible reference ad the beginning)
 
5. **SORGENTI.XML** --> It contains the names of the HTM files with the song texts. They correspond  to the files inside the raw folder. If a song is not translated, you must put the value **no_canto** in the corresponding tag (see examples in [values-uk/sorgenti.xml](app/src/main/res/values-uk/sorgenti.xml) file)
 
6. **TITOLI.XML** --> It contains all the songs titles

**IMPORTANT**: You can recognize the lines corresponding to a specific song in the various files, because in each file the "NAME" property is the same, but has a different suffix (for example "_link" or "_title").

Eventually, in order for the app to work properly, you will have to have each song translated in your language and each of the previous files filled with the content.

### 3. pubspec.yaml
Specify the files added in the `pubspec.yaml` at the end of the file:
<pre>
flutter:
  uses-material-design: true
  assets:
    - i18n/
    - assets/images/
    - assets/data/songs_values/values-it/
    - assets/data/songs_values/values-en/
    - assets/data/songs_values/values-languageCode/
    - assets/data/songs_raw/raw-it/
    - assets/data/songs_raw/raw-en/
    - assets/data/songs_raw/raw-languageCode/
</pre>

## Utils
Amazing and easy tool to export drawable as SVG: [ShapeShifter](https://shapeshifter.design/)