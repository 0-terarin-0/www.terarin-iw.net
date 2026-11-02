import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/site_footer.dart';
import '../components/site_header.dart';
import '../components/document_viewer.dart';
import '../components/machine_translation_notice.dart';
import '../constants/theme.dart';
import '../i18n/i18n.dart';
import '../pages/entry_list.dart';
import '../pages/home_page.dart';

/// The layout of every page. The `layout` key in the frontmatter selects the view.
class SiteLayout extends PageLayoutBase {
  const SiteLayout();

  @override
  Pattern get name => RegExp('.*');

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page);
    yield link(rel: 'icon', href: '/favicon.ico');
    yield link(rel: 'apple-touch-icon', href: '/apple-icon.png');
    yield link(rel: 'preconnect', href: 'https://fonts.googleapis.com');
    yield link(rel: 'preconnect', href: 'https://fonts.gstatic.com', attributes: {'crossorigin': ''});
    yield link(rel: 'stylesheet', href: fontsUrl);
    // Fetches a page when a link is hovered or pressed, so that moving between pages feels instant. Browsers without
    // support ignore this and load pages normally.
    yield script(
      attributes: {'type': 'speculationrules'},
      content: '{"prefetch":[{"where":{"href_matches":"/*"},"eagerness":"moderate"}]}',
    );
  }

  @override
  Component buildBody(Page page, Component child) {
    return div(classes: 'site', [
      SiteHeader(currentUrl: page.url),
      const MachineTranslationNotice(),
      main_(classes: 'site-main', [_buildView(page, child)]),
      const SiteFooter(),
    ]);
  }

  Component _buildView(Page page, Component child) {
    final data = page.data.page;

    return switch (data['layout']) {
      // `child` must always be rendered, because it also outputs the theme styles.
      'home' => Component.fragment([const HomePage(), child]),
      'blog-list' => EntryList(directory: 'blog', data: data, child: child),
      'document-list' => EntryList(directory: 'documents', data: data, child: child),
      'post' => div(classes: 'page', [
        a(classes: 'back-link', href: '/blog', [
          span(classes: 'rtl-flip', [.text('←')]),
          .text(' '),
          T((messages) => messages.navBlog),
        ]),
        EntryMeta(data),
        h1(classes: 'page-title', [localized(data, 'title')]),
        EntryTags(data),
        _Body(child),
      ]),
      'document' => div(classes: 'page page-wide', [
        a(classes: 'back-link', href: '/documents', [
          span(classes: 'rtl-flip', [.text('←')]),
          .text(' '),
          T((messages) => messages.navDocuments),
        ]),
        EntryMeta(data),
        h1(classes: 'page-title', [localized(data, 'title')]),
        if (data['description'] != null) p(classes: 'page-lead', [localized(data, 'description')]),
        DocumentViewer(
          title: data['title'] as String,
          type: data['type'] as String,
          src: data['src'] as String,
          download: data['download'] as String?,
          filesUrl: page.data.site['filesUrl'] as String,
        ),
        _Body(child),
      ]),
      final layout => throw ArgumentError('Unknown layout "$layout" in ${page.path}.'),
    };
  }
}

/// The Markdown body of a post or document. It is not translated, so its direction follows its own text.
class _Body extends StatelessComponent {
  const _Body(this.child);

  final Component child;

  @override
  Component build(BuildContext context) {
    return div(attributes: {'dir': 'auto'}, [child]);
  }
}
