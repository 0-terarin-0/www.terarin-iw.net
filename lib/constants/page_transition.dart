import 'package:jaspr/dom.dart';

const _duration = '280ms';
const _curve = 'cubic-bezier(0.2, 0.8, 0.2, 1)';

// Page changes animate with cross-document view transitions, which need no JavaScript. Browsers without support just
// load the next page. The header stays still while the highlight of the active tab slides to its new place, and the
// main content fades over. View transitions have no typed API in Jaspr yet.
@css
List<StyleRule> get pageTransitionStyles => [
  // Without this rule no transition runs, so visitors who prefer reduced motion get a plain page load.
  css.media(MediaQuery.raw('(prefers-reduced-motion: no-preference)'), [
    css('@view-transition').styles(raw: {'navigation': 'auto'}),
  ]),
  css('.site-header').styles(raw: {'view-transition-name': 'site-header'}),
  css('.site-main').styles(raw: {'view-transition-name': 'site-main'}),
  css.keyframes('page-out', {
    'to': Styles(opacity: 0),
  }),
  css.keyframes('page-in', {
    'from': Styles(opacity: 0, transform: .translate(y: 8.px)),
  }),
  css(
    '::view-transition-old(root), ::view-transition-new(root), ::view-transition-old(site-header), '
    '::view-transition-new(site-header)',
  ).styles(raw: {'animation': 'none'}),
  css('::view-transition-old(site-main)').styles(raw: {'animation': 'page-out 120ms ease-out both'}),
  css('::view-transition-new(site-main)').styles(raw: {'animation': 'page-in $_duration $_curve 60ms both'}),
  css('::view-transition-group(nav-pill)').styles(
    raw: {'animation-duration': _duration, 'animation-timing-function': _curve},
  ),
];
