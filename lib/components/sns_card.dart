import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';

import '../i18n/i18n.dart';
import '../constants/sns.dart';

/// Links to all SNS accounts.
class SnsCard extends StatelessComponent {
  const SnsCard({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'card sns-card', [
      h2(classes: 'eyebrow', [T((messages) => messages.findMeOn)]),
      for (final sns in snsAccounts)
        a(
          classes: 'sns-row',
          href: sns.url,
          target: .blank,
          attributes: {'rel': 'noopener'},
          [
            _SnsLogo(image: sns.image, theme: 'light'),
            _SnsLogo(image: sns.image, theme: 'dark'),
            span(classes: 'sns-name', [.text(sns.name)]),
            span(classes: 'sns-username', attributes: {'dir': 'ltr'}, [.text('@${sns.username}')]),
            span(classes: 'sns-arrow rtl-flip', attributes: {'aria-hidden': 'true'}, [.text('↗')]),
          ],
        ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.sns-card').styles(padding: .all(1.5.rem)),
    css('.sns-card h2').styles(margin: .only(bottom: 0.5.rem)),
    css('.sns-row', [
      css('&').styles(
        display: .grid,
        padding: .symmetric(vertical: 0.625.rem),
        border: .only(
          bottom: .solid(color: ContentColors.hr, width: 1.px),
        ),
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize(Unit.auto)),
            GridTrack(TrackSize(Unit.auto)),
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize(Unit.auto)),
          ]),
        ),
        alignItems: .center,
        gap: .all(0.625.rem),
        textDecoration: .none,
      ),
      css('&:last-child').styles(border: .none),
      css('img').styles(
        display: .block,
        width: 1.25.rem,
        height: 1.25.rem,
        opacity: 0.7,
        filter: .grayscale(),
      ),
      css('&:hover img').styles(opacity: 1, filter: .grayscale(0)),
      css('&:hover .sns-name, &:hover .sns-arrow').styles(color: ContentColors.primary),
    ]),
    css('.sns-name').styles(
      color: ContentColors.headings,
      fontWeight: .w500,
    ),
    css('.sns-username').styles(
      minWidth: .zero,
      overflow: .hidden,
      color: ContentColors.lead,
      fontSize: 0.8125.rem,
      textOverflow: .ellipsis,
      whiteSpace: .noWrap,
    ),
    css('.sns-arrow').styles(color: ContentColors.lead),
    css('html:not([data-theme="dark"]) .sns-logo-dark').styles(display: .none),
    css('html[data-theme="dark"] .sns-logo-light').styles(display: .none),
  ];
}

/// A logo for one color theme. The styles show only the one matching the active theme.
class _SnsLogo extends StatelessComponent {
  const _SnsLogo({required this.image, required this.theme});

  final String image;
  final String theme;

  @override
  Component build(BuildContext context) {
    return img(
      classes: 'sns-logo-$theme',
      src: '/images/sns/logo_${image}_$theme.png',
      alt: '',
      width: 20,
      height: 20,
    );
  }
}
