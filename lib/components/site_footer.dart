import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';

import '../constants/theme.dart';

class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return footer(classes: 'site-footer', [
      span([.text('© ${DateTime.now().year} Koki Teramoto')]),
      a(href: 'https://jaspr.site', target: .blank, attributes: {'rel': 'noopener'}, [.text('Built with Jaspr')]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        display: .flex,
        width: 100.percent,
        maxWidth: 68.rem,
        padding: .all(1.rem),
        margin: .symmetric(horizontal: .auto),
        flexWrap: .wrap,
        justifyContent: .spaceBetween,
        gap: .all(0.5.rem),
        color: ContentColors.lead,
        fontFamily: monoFont,
        fontSize: 0.8125.rem,
      ),
      css('a').styles(textDecoration: .none),
      css('a:hover').styles(color: ContentColors.primary),
    ]),
  ];
}
