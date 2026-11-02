import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/theme.dart';

import '../i18n/i18n.dart';
import '../constants/theme.dart';
import 'language_select.dart';

class SiteHeader extends StatelessComponent {
  const SiteHeader({required this.currentUrl, super.key});

  final String currentUrl;

  static final _links = <(String, String Function(Messages))>[
    ('/', (messages) => messages.navHome),
    ('/blog', (messages) => messages.navBlog),
    ('/documents', (messages) => messages.navDocuments),
  ];

  bool _isActive(String href) => href == '/' ? currentUrl == '/' : currentUrl.startsWith(href);

  @override
  Component build(BuildContext context) {
    return header(classes: 'site-header', [
      div(classes: 'site-header-bar', [
        a(classes: 'site-brand', href: '/', [
          img(src: '/images/icon_terarin.jpg', alt: '', width: 28, height: 28),
          span([.text('Koki Teramoto')]),
        ]),
        nav([
          for (final (href, select) in _links)
            a(
              href: href,
              attributes: _isActive(href) ? {'aria-current': 'page'} : null,
              [T(select)],
            ),
        ]),
        const LanguageSelect(),
        const ThemeToggle(),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-header').styles(
      position: .sticky(top: .zero),
      zIndex: ZIndex(10),
      padding: .only(top: 0.75.rem, left: 1.rem, right: 1.rem),
    ),
    css('.site-header-bar').styles(
      display: .flex,
      maxWidth: 66.rem,
      padding: .symmetric(horizontal: 0.75.rem, vertical: 0.375.rem),
      margin: .symmetric(horizontal: .auto),
      border: .all(color: ContentColors.hr, width: 1.px),
      radius: .circular(999.px),
      backdropFilter: .blur(12.px),
      alignItems: .center,
      gap: .all(0.25.rem),
      backgroundColor: glassColor,
    ),
    css('.site-brand', [
      css('&').styles(
        display: .none,
        alignItems: .center,
        gap: .all(0.5.rem),
        color: ContentColors.headings,
        fontSize: 0.9375.rem,
        fontWeight: .w600,
        textDecoration: .none,
      ),
      css('img').styles(radius: .circular(50.percent)),
      css('span').styles(display: .none),
    ]),
    css('.site-header-bar nav', [
      css('&').styles(
        display: .flex,
        flex: Flex(grow: 1),
        justifyContent: .end,
        gap: .all(0.25.rem),
      ),
      css('a').styles(
        position: .relative(),
        zIndex: ZIndex(0),
        padding: .symmetric(horizontal: 0.375.rem, vertical: 0.375.rem),
        color: ContentColors.lead,
        fontSize: 0.875.rem,
        fontWeight: .w500,
        textDecoration: .none,
      ),
      css('a:hover').styles(color: ContentColors.headings),
      css('a[aria-current="page"]').styles(color: ContentColors.primary),
      // A pseudo-element, so the view transition slides the highlight and leaves the label in place.
      css('a[aria-current="page"]::before').styles(
        content: '',
        position: .absolute(top: .zero, left: .zero, bottom: .zero, right: .zero),
        zIndex: ZIndex(-1),
        radius: .circular(999.px),
        raw: {
          'background-color': 'color-mix(in srgb, ${ContentColors.primary.value} 12%, transparent)',
          'view-transition-name': 'nav-pill',
        },
      ),
    ]),
    css('.site-header-bar .theme-toggle').styles(padding: .all(0.375.rem)),
    css.media(MediaQuery.all(minWidth: 420.px), [
      css('.site-brand').styles(display: .flex),
      css('.site-header-bar nav a').styles(
        padding: .symmetric(horizontal: 0.75.rem, vertical: 0.375.rem),
      ),
    ]),
    css.media(MediaQuery.all(minWidth: 640.px), [
      css('.site-brand span').styles(display: .inline),
    ]),
  ];
}
