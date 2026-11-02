import 'dart:async';
import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';
import 'package:universal_web/web.dart' as web;

import '../i18n/i18n.dart';
import '../constants/theme.dart';

/// A menu that switches the language of the site without changing the URL.
@client
class LanguageSelect extends StatefulComponent {
  const LanguageSelect({super.key});

  @override
  State createState() => LanguageSelectState();
}

class LanguageSelectState extends State<LanguageSelect> {
  static const _storageKey = 'terarin:lang';
  static const _focusInEvent = web.EventStreamProvider<web.Event>('focusin');

  final _subscriptions = <StreamSubscription<web.Event>>[];

  SiteLocale language = SiteLocale.initial;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) return;
    final current = web.document.documentElement!.getAttribute('data-lang');
    language = SiteLocale.values.firstWhere((locale) => locale.name == current, orElse: () => language);
    _subscriptions.addAll([
      web.EventStreamProviders.clickEvent.forTarget(web.document).listen(_closeIfOutside),
      _focusInEvent.forTarget(web.document).listen(_closeIfOutside),
      web.EventStreamProviders.keyDownEvent.forTarget(web.document).listen(_closeOnEscape),
    ]);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void _closeIfOutside(web.Event event) {
    if (isOpen && (event.target as web.Element).closest('.language-select') == null) {
      setState(() => isOpen = false);
    }
  }

  void _closeOnEscape(web.KeyboardEvent event) {
    if (!isOpen || event.key != 'Escape') return;
    setState(() => isOpen = false);
    (web.document.querySelector('.language-trigger') as web.HTMLElement).focus();
  }

  void _select(SiteLocale locale) {
    setState(() {
      language = locale;
      isOpen = false;
    });
    web.window.localStorage.setItem(_storageKey, locale.name);
  }

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      if (!kIsWeb)
        Document.head(
          children: [
            // Runs before the first paint, so the wrong language never flashes.
            script(
              id: 'language-script',
              content:
                  '''
            let languages = ${jsonEncode({for (final locale in SiteLocale.values) locale.name: locale.direction})};
            let language = window.localStorage.getItem('$_storageKey');
            if (!(language in languages)) {
              language = '${SiteLocale.initial.name}';
            }
            document.documentElement.setAttribute('data-lang', language);
            document.documentElement.setAttribute('lang', language);
            document.documentElement.setAttribute('dir', languages[language]);
          ''',
            ),
          ],
        ),
      if (kIsWeb)
        Document.html(attributes: {'data-lang': language.name, 'lang': language.name, 'dir': language.direction}),
      div(classes: 'language-select', [
        button(
          classes: 'language-trigger',
          attributes: {
            'type': 'button',
            'aria-label': 'Language / 言語',
            'aria-haspopup': 'menu',
            'aria-expanded': '$isOpen',
          },
          onClick: () => setState(() => isOpen = !isOpen),
          [
            const _GlobeIcon(),
            // Rendered through the styles, so the label is right before the page hydrates.
            span(classes: 'language-current', [
              for (final locale in SiteLocale.values)
                span(
                  classes: 'i18n i18n-${locale.name}',
                  attributes: {'lang': locale.name},
                  [.text(locale.language.label)],
                ),
            ]),
          ],
        ),
        if (isOpen)
          div(
            classes: 'language-menu',
            attributes: {'role': 'menu'},
            [
              for (final locale in SiteLocale.values)
                button(
                  attributes: {
                    'type': 'button',
                    'role': 'menuitemradio',
                    'aria-checked': '${locale == language}',
                    'lang': locale.name,
                  },
                  onClick: () => _select(locale),
                  [.text(locale.language.label)],
                ),
            ],
          ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.language-select').styles(position: .relative()),
    css('.language-trigger', [
      css('&').styles(
        display: .flex,
        padding: .all(0.375.rem),
        radius: .circular(8.px),
        cursor: .pointer,
        alignItems: .center,
        gap: .all(0.375.rem),
        color: ContentColors.lead,
        fontSize: 0.8125.rem,
        fontWeight: .w500,
        whiteSpace: .noWrap,
        backgroundColor: Colors.transparent,
      ),
      css('&:hover, &[aria-expanded="true"]').styles(color: ContentColors.headings),
    ]),
    css('.language-current').styles(display: .none),
    css.media(MediaQuery.all(minWidth: 400.px), [
      css('.language-current').styles(display: .inline),
    ]),
    css('.language-menu', [
      css('&').styles(
        position: .absolute(top: Unit.expression('calc(100% + 0.625rem)')),
        zIndex: ZIndex(20),
        display: .flex,
        minWidth: 9.rem,
        padding: .all(0.25.rem),
        border: .all(color: ContentColors.hr, width: 1.px),
        radius: .circular(12.px),
        shadow: BoxShadow(offsetX: .zero, offsetY: 8.px, blur: 24.px, color: Color.rgba(0, 0, 0, 0.2)),
        flexDirection: .column,
        backgroundColor: surfaceColor,
        raw: {'inset-inline-end': '0'},
      ),
      css('button').styles(
        padding: .symmetric(horizontal: 0.75.rem, vertical: 0.5.rem),
        radius: .circular(8.px),
        cursor: .pointer,
        color: ContentColors.text,
        textAlign: .start,
        fontSize: 0.875.rem,
        backgroundColor: Colors.transparent,
      ),
      css('button:hover').styles(
        raw: {'background-color': 'color-mix(in srgb, ${ContentColors.primary.value} 10%, transparent)'},
      ),
      css('button[aria-checked="true"]').styles(
        color: ContentColors.primary,
        fontWeight: .w600,
      ),
    ]),
  ];
}

/// The globe icon from lucide (https://lucide.dev/icons/globe).
class _GlobeIcon extends StatelessComponent {
  const _GlobeIcon();

  @override
  Component build(BuildContext context) {
    return svg(
      width: 20.px,
      height: 20.px,
      viewBox: '0 0 24 24',
      attributes: {
        'fill': 'none',
        'stroke': 'currentColor',
        'stroke-width': '2',
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
      },
      [
        circle(cx: '12', cy: '12', r: '10', []),
        path(d: 'M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20', []),
        path(d: 'M2 12h20', []),
      ],
    );
  }
}
