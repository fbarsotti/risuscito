part of 'language_bloc.dart';

@immutable
abstract class LanguageEvent {}

class LanguageLoadStarted extends LanguageEvent {}

class LanguageSelected extends LanguageEvent {
  final Language languageCode;

  LanguageSelected(this.languageCode);
}
