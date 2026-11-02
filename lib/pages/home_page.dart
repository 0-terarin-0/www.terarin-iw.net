import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';

import '../components/sns_card.dart';
import '../i18n/i18n.dart';
import '../constants/theme.dart';
import 'entry_list.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  static const _latestCount = 5;

  @override
  Component build(BuildContext context) {
    final latest = entriesIn(context, ['blog', 'documents']).take(_latestCount);

    return div(classes: 'page page-wide home', [
      section(classes: 'card home-hero', [
        p(classes: 'eyebrow home-status', [
          span(classes: 'home-dot', []),
          T((messages) => messages.status),
        ]),
        h1([.text('Koki'), br(), .text('Teramoto')]),
        p(classes: 'home-intro', [T((messages) => messages.introduction)]),
        div(classes: 'home-actions', [
          a(classes: 'button', href: '/blog', [T((messages) => messages.readBlog)]),
          a(classes: 'button button-ghost', href: '/documents', [T((messages) => messages.seeDocuments)]),
        ]),
      ]),
      div(classes: 'card home-portrait', [
        img(src: '/images/icon_terarin.jpg', alt: 'Icon of Koki Teramoto', width: 384, height: 384),
      ]),
      const SnsCard(),
      section(classes: 'card home-latest', [
        h2(classes: 'eyebrow', [T((messages) => messages.latest)]),
        if (latest.isEmpty)
          p(classes: 'empty', [T((messages) => messages.nothingYet)])
        else
          for (final entry in latest)
            a(classes: 'home-latest-row', href: entry.url, [
              span(classes: 'meta', [.text('${entry.data.page['date']}')]),
              span(classes: 'home-latest-title', [localized(entry.data.page, 'title')]),
              span(classes: 'eyebrow', [
                T((messages) => entry.url.startsWith('/blog/') ? messages.navBlog : messages.navDocuments),
              ]),
            ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.home').styles(
      display: .grid,
      gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      gap: .all(1.rem),
    ),
    css('.home > *').styles(minWidth: .zero),
    css('.home-hero', [
      css('&').styles(
        padding: .all(Unit.expression('clamp(1.5rem, 4vw, 2.75rem)')),
        raw: {
          // Gradients have no typed API in Jaspr yet.
          'background-image':
              'radial-gradient(90% 90% at 100% 0%, color-mix(in srgb, ${ContentColors.primary.value} 16%, transparent), transparent 70%)',
        },
      ),
      css('h1').styles(
        margin: .only(top: 1.25.rem, bottom: 1.25.rem),
        color: ContentColors.headings,
        fontSize: Unit.expression('clamp(3rem, 8vw, 5.25rem)'),
        fontWeight: .w600,
        letterSpacing: (-0.04).em,
        lineHeight: 1.em,
      ),
    ]),
    css('.home-status').styles(
      display: .flex,
      alignItems: .center,
      gap: .all(0.5.rem),
    ),
    css('.home-dot').styles(
      width: 0.5.rem,
      height: 0.5.rem,
      radius: .circular(50.percent),
      backgroundColor: accentColor,
    ),
    css('.home-intro').styles(
      maxWidth: 38.rem,
      color: ContentColors.lead,
      lineHeight: 1.7.em,
    ),
    css('.home-actions').styles(
      display: .flex,
      margin: .only(top: 1.75.rem),
      flexWrap: .wrap,
      gap: .all(0.5.rem),
    ),
    css('.home-portrait', [
      css('&').styles(aspectRatio: AspectRatio(16, 9), overflow: .hidden),
      css('img').styles(
        display: .block,
        width: 100.percent,
        height: 100.percent,
        raw: {'object-fit': 'cover', 'object-position': 'center 30%'},
      ),
    ]),
    css('.home-latest').styles(padding: .all(1.5.rem)),
    css('.home-latest-row', [
      css('&').styles(
        display: .grid,
        padding: .symmetric(vertical: 0.875.rem),
        border: .only(
          bottom: .solid(color: ContentColors.hr, width: 1.px),
        ),
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize(Unit.auto)),
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize(Unit.auto)),
          ]),
        ),
        alignItems: .center,
        gap: .all(1.rem),
        textDecoration: .none,
      ),
      css('&:last-child').styles(border: .none),
      css('&:hover .home-latest-title').styles(color: ContentColors.primary),
    ]),
    css('.home-latest-title').styles(
      color: ContentColors.headings,
      fontWeight: .w500,
    ),
    css.media(MediaQuery.all(minWidth: 768.px), [
      css('.home').styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack.repeat(TrackRepeat(3), [GridTrack(TrackSize.fr(1))]),
          ]),
          areas: GridAreas(['hero hero portrait', 'sns latest latest']),
        ),
      ),
      css('.home-hero').styles(gridPlacement: .area('hero')),
      css('.home-portrait').styles(aspectRatio: AspectRatio.auto, gridPlacement: .area('portrait')),
      css('.sns-card').styles(gridPlacement: .area('sns')),
      css('.home-latest').styles(gridPlacement: .area('latest')),
    ]),
  ];
}
