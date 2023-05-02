enum Language { it, en, uk }

class RSLanguage {
  final String code;
  final String? name;
  final Language language;

  RSLanguage(this.code, this.name, this.language);
}
