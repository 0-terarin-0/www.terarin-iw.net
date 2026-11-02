import 'package:jaspr/dom.dart';
import 'package:jaspr_content/theme.dart';

const _sansFont = FontFamily.list([
  FontFamily('Noto Sans'),
  FontFamily('Noto Sans Arabic'),
  FontFamily('Noto Sans JP'),
  FontFamilies.sansSerif,
]);

const monoFont = FontFamily.list([
  FontFamily('Noto Sans Mono'),
  FontFamily('Noto Sans Arabic'),
  FontFamily('Noto Sans JP'),
  FontFamilies.monospace,
]);

/// The background of raised elements such as cards.
const surfaceColor = ColorToken('surface', Color('#ffffff'), dark: Color('#161a21'));

/// The translucent background of the floating header.
const glassColor = ColorToken('glass', Color.rgba(255, 255, 255, 0.72), dark: Color.rgba(22, 26, 33, 0.72));

/// The leaf green of the site icon, used as a second accent next to the primary blue.
const accentColor = ColorToken('accent', Color('#15803d'), dark: Color('#86e3a5'));

final siteTheme = ContentTheme(
  font: _sansFont,
  codeFont: monoFont,
  primary: const ThemeColor(Color('#2456e6'), dark: Color('#8fb0ff')),
  background: const ThemeColor(Color('#f7f7f3'), dark: Color('#0e1014')),
  text: const ThemeColor(Color('#1b1f27'), dark: Color('#e8eaee')),
  colors: [
    ContentColors.links.apply(const ThemeColor(Color('#2456e6'), dark: Color('#8fb0ff'))),
    ContentColors.headings.apply(const ThemeColor(Color('#0e1116'), dark: Colors.white)),
    ContentColors.lead.apply(const ThemeColor(Color('#5b6472'), dark: Color('#98a1b0'))),
    ContentColors.hr.apply(const ThemeColor(Color('#e3e3dc'), dark: Color('#262b34'))),
    surfaceColor,
    glassColor,
    accentColor,
  ],
);

const fontsUrl =
    'https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;500;600;700&family=Noto+Sans+Mono:wght@400;500&family=Noto+Sans+Arabic:wght@400;500;600;700&family=Noto+Sans+JP:wght@400;500;700&display=swap';

// Styles shared by more than one page.
@css
List<StyleRule> get styles => [
  css(':focus-visible').styles(
    outline: Outline(color: ContentColors.primary, style: .solid, width: OutlineWidth(2.px), offset: 2.px),
  ),
  // Arrows point the other way in right-to-left languages, but code always reads left to right.
  css('.rtl-flip').styles(display: .inlineBlock),
  css('[dir="rtl"] .rtl-flip').styles(transform: .matrix(-1, 0, 0, 1, 0, 0)),
  css('pre').styles(raw: {'direction': 'ltr'}),
  // Spacing out letters breaks the joins of connected scripts.
  css('[dir="rtl"] .eyebrow, [dir="rtl"] .page-title').styles(letterSpacing: .zero),
  css('.site').styles(
    display: .flex,
    minHeight: 100.vh,
    flexDirection: .column,
  ),
  css('.site-main').styles(flex: Flex(grow: 1)),
  css('.page').styles(
    width: 100.percent,
    maxWidth: 44.rem,
    padding: .only(top: 3.rem, left: 1.rem, right: 1.rem, bottom: 4.rem),
    margin: .symmetric(horizontal: .auto),
  ),
  css('.page-wide').styles(maxWidth: 68.rem),
  css('.page-title').styles(
    margin: .only(top: 0.5.rem, bottom: 0.75.rem),
    color: ContentColors.headings,
    fontSize: Unit.expression('clamp(2.25rem, 6vw, 3.25rem)'),
    fontWeight: .w600,
    letterSpacing: (-0.03).em,
    lineHeight: 1.15.em,
  ),
  css('.page-lead').styles(
    margin: .only(bottom: 2.5.rem),
    color: ContentColors.lead,
    fontSize: 1.125.rem,
  ),
  css('.card').styles(
    border: .all(color: ContentColors.hr, width: 1.px),
    radius: .circular(20.px),
    backgroundColor: surfaceColor,
  ),
  css('.button', [
    css('&').styles(
      display: .inlineFlex,
      padding: .symmetric(horizontal: 1.125.rem, vertical: 0.625.rem),
      border: .all(color: ContentColors.primary, width: 1.px),
      radius: .circular(999.px),
      transition: Transition('opacity', duration: Duration(milliseconds: 150)),
      color: ContentColors.background,
      fontSize: 0.875.rem,
      fontWeight: .w500,
      textDecoration: .none,
      backgroundColor: ContentColors.primary,
    ),
    css('&:hover').styles(opacity: 0.85),
  ]),
  css('.button-ghost', [
    css('&').styles(
      border: .all(color: ContentColors.hr, width: 1.px),
      color: ContentColors.text,
      backgroundColor: Colors.transparent,
    ),
    css('&:hover').styles(
      border: .all(color: ContentColors.primary, width: 1.px),
      opacity: 1,
    ),
  ]),
  css('.eyebrow').styles(
    color: ContentColors.lead,
    fontFamily: monoFont,
    fontSize: 0.75.rem,
    fontWeight: .w500,
    textTransform: .upperCase,
    letterSpacing: 0.08.em,
  ),
  css('.meta').styles(
    display: .block,
    color: ContentColors.lead,
    fontFamily: monoFont,
    fontSize: 0.8125.rem,
  ),
  css('.back-link', [
    css('&').styles(
      display: .inlineBlock,
      margin: .only(bottom: 1.5.rem),
      color: ContentColors.lead,
      fontSize: 0.875.rem,
      textDecoration: .none,
    ),
    css('&:hover').styles(color: ContentColors.primary),
  ]),
  css('.tags').styles(
    display: .flex,
    margin: .only(top: 0.75.rem),
    flexWrap: .wrap,
    gap: .all(0.375.rem),
  ),
  css('.tag').styles(
    padding: .symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
    radius: .circular(6.px),
    color: ContentColors.lead,
    fontFamily: monoFont,
    fontSize: 0.75.rem,
    raw: {'background-color': 'color-mix(in srgb, ${ContentColors.primary.value} 10%, transparent)'},
  ),
  css('.empty').styles(color: ContentColors.lead),
];
