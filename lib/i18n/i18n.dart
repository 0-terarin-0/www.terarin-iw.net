import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'language.dart';
import 'languages/ar.dart';
import 'languages/en.dart';
import 'languages/ja.dart';
import 'languages/mn.dart';

export 'language.dart';

/// The languages of the site.
///
/// To add a language, write its file under `languages/` and add a value here. The language menu and the styles follow
/// this list.
///
/// Every page has a single URL. Its HTML contains the text of all languages, and the `data-lang` attribute of the
/// `<html>` element selects the one shown. See `LanguageSelect`.
enum SiteLocale {
  en(enLanguage),
  ja(jaLanguage),
  ar(arLanguage),
  mn(mnLanguage);

  const SiteLocale(this.language);

  /// The language shown until a visitor chooses one.
  static const initial = en;

  /// The language the frontmatter values are written in.
  static const source = ja;

  final Language language;

  Messages get messages => language.messages;

  /// The value of the `dir` attribute.
  String get direction => language.isRtl ? 'rtl' : 'ltr';
}

/// Renders a message in all languages. The styles show only the active one.
class T extends StatelessComponent {
  const T(this.select, {super.key});

  final String Function(Messages) select;

  @override
  Component build(BuildContext context) {
    return Component.fragment([for (final locale in SiteLocale.values) _text(locale, select(locale.messages))]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.i18n').styles(display: .none),
    css('html:not([data-lang]) .i18n-${SiteLocale.initial.name}').styles(display: .inline),
    for (final locale in SiteLocale.values)
      css('html[data-lang="${locale.name}"] .i18n-${locale.name}').styles(display: .inline),
  ];
}

/// Renders the frontmatter value of [key], and its translations from the `<key>_<language>` keys if there are any.
///
/// Languages without a translation show the value of [key].
Component localized(Map<String, Object?> data, String key) {
  final text = '${data[key]}';
  String? translation(SiteLocale locale) => data['${key}_${locale.name}'] as String?;

  if (!SiteLocale.values.any((locale) => translation(locale) != null)) return .text(text);

  return Component.fragment([
    for (final locale in SiteLocale.values)
      _text(translation(locale) != null ? locale : SiteLocale.source, translation(locale) ?? text, shownIn: locale),
  ]);
}

Component _text(SiteLocale language, String text, {SiteLocale? shownIn}) {
  return span(classes: 'i18n i18n-${(shownIn ?? language).name}', attributes: {'lang': language.name}, [.text(text)]);
}
