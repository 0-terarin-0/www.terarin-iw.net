import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';

import '../i18n/i18n.dart';

/// Tells visitors that the active language was machine-translated.
///
/// Each language turns this on with [Language.isMachineTranslated].
class MachineTranslationNotice extends StatelessComponent {
  const MachineTranslationNotice({super.key});

  static final _locales = SiteLocale.values.where((locale) => locale.language.isMachineTranslated);

  @override
  Component build(BuildContext context) {
    return div(classes: 'translation-notice', [
      for (final locale in _locales)
        p(
          classes: 'i18n i18n-${locale.name}',
          attributes: {'lang': locale.name},
          [
            span(classes: 'translation-badge', [
              const _WarningIcon(),
              .text(locale.messages.machineTranslationBadge),
            ]),
            span([.text(locale.messages.machineTranslationNotice)]),
          ],
        ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    for (final locale in _locales)
      css('html[data-lang="${locale.name}"] .translation-notice .i18n-${locale.name}').styles(
        display: .flex,
        padding: .only(top: 0.75.rem, left: 1.rem, right: 1.rem),
        flexWrap: .wrap,
        justifyContent: .center,
        alignItems: .center,
        gap: .all(0.5.rem),
        color: ContentColors.lead,
        textAlign: .center,
        fontSize: 0.8125.rem,
      ),
    css('.translation-badge').styles(
      display: .inlineFlex,
      padding: .symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
      radius: .circular(999.px),
      alignItems: .center,
      gap: .all(0.25.rem),
      color: const Color('#422006'),
      fontSize: 0.75.rem,
      fontWeight: .w600,
      whiteSpace: .noWrap,
      backgroundColor: const Color('#facc15'),
    ),
  ];
}

/// The triangle-alert icon from lucide (https://lucide.dev/icons/triangle-alert).
class _WarningIcon extends StatelessComponent {
  const _WarningIcon();

  @override
  Component build(BuildContext context) {
    return svg(
      width: 14.px,
      height: 14.px,
      viewBox: '0 0 24 24',
      attributes: {
        'fill': 'none',
        'stroke': 'currentColor',
        'stroke-width': '2',
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        'aria-hidden': 'true',
      },
      [
        path(d: 'm21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3', []),
        path(d: 'M12 9v4', []),
        path(d: 'M12 17h.01', []),
      ],
    );
  }
}
