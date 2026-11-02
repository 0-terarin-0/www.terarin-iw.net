import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

import '../i18n/i18n.dart';

/// The blog posts or documents under [directories], newest first.
List<Page> entriesIn(BuildContext context, List<String> directories) {
  return context.pages
      .where((page) => directories.any((directory) => page.path.startsWith('$directory/')))
      .where((page) => !page.path.endsWith('/index.md'))
      .toList()
    ..sort((first, second) => '${second.data.page['date']}'.compareTo('${first.data.page['date']}'));
}

/// Lists the blog posts or documents under [directory].
class EntryList extends StatelessComponent {
  const EntryList({required this.directory, required this.data, required this.child, super.key});

  final String directory;
  final Map<String, Object?> data;
  final Component child;

  @override
  Component build(BuildContext context) {
    final entries = entriesIn(context, [directory]);

    return div(classes: 'page page-wide', [
      h1(classes: 'page-title', [localized(data, 'title')]),
      if (data['description'] != null) p(classes: 'page-lead', [localized(data, 'description')]),
      child,
      if (entries.isEmpty)
        p(classes: 'empty', [T((messages) => messages.nothingYet)])
      else if (directory == 'documents')
        div(classes: 'document-grid', [for (final entry in entries) _DocumentCard(entry)])
      else
        div(classes: 'post-list', [for (final entry in entries) _PostRow(entry)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.post-list').styles(
      border: .only(
        top: .solid(color: ContentColors.hr, width: 1.px),
      ),
    ),
    css('.post-row', [
      css('&').styles(
        display: .grid,
        padding: .symmetric(vertical: 1.5.rem),
        border: .only(
          bottom: .solid(color: ContentColors.hr, width: 1.px),
        ),
        gap: .all(0.375.rem),
        textDecoration: .none,
      ),
      css('h2').styles(
        color: ContentColors.headings,
        fontSize: 1.25.rem,
        fontWeight: .w600,
      ),
      css('p').styles(color: ContentColors.lead),
      css('&:hover h2').styles(color: ContentColors.primary),
    ]),
    css('.document-grid').styles(
      display: .grid,
      gridTemplate: GridTemplate(
        columns: GridTracks([
          GridTrack.repeat(TrackRepeat.autoFill, [
            GridTrack(TrackSize.minmax(TrackSize(16.rem), TrackSize.fr(1))),
          ]),
        ]),
      ),
      gap: .all(1.rem),
    ),
    css('.document-card', [
      css('&').styles(
        display: .flex,
        overflow: .hidden,
        flexDirection: .column,
        textDecoration: .none,
      ),
      css('&:hover').styles(
        border: .all(color: ContentColors.primary, width: 1.px),
      ),
      css('h2').styles(
        margin: .symmetric(vertical: 0.25.rem),
        color: ContentColors.headings,
        fontSize: 1.125.rem,
        fontWeight: .w600,
      ),
      css('p').styles(color: ContentColors.lead, fontSize: 0.875.rem),
    ]),
    css('.document-card-cover').styles(
      display: .flex,
      aspectRatio: AspectRatio(16, 9),
      padding: .all(1.rem),
      alignItems: .end,
      raw: {
        // Gradients have no typed API in Jaspr yet.
        'background-image':
            'linear-gradient(135deg, color-mix(in srgb, ${ContentColors.primary.value} 28%, transparent), color-mix(in srgb, var(--accent) 22%, transparent))',
      },
    ),
    css('.document-card-body').styles(padding: .all(1.25.rem)),
    css.media(MediaQuery.all(minWidth: 640.px), [
      css('.post-row').styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(TrackSize(8.rem)), GridTrack(TrackSize.fr(1))]),
        ),
        gap: Gap(column: 1.5.rem),
      ),
    ]),
  ];
}

class _PostRow extends StatelessComponent {
  const _PostRow(this.entry);

  final Page entry;

  @override
  Component build(BuildContext context) {
    final data = entry.data.page;

    return a(classes: 'post-row', href: entry.url, [
      EntryMeta(data),
      div([
        h2([localized(data, 'title')]),
        if (data['description'] != null) p([localized(data, 'description')]),
        EntryTags(data),
      ]),
    ]);
  }
}

class _DocumentCard extends StatelessComponent {
  const _DocumentCard(this.entry);

  final Page entry;

  @override
  Component build(BuildContext context) {
    final data = entry.data.page;

    return a(classes: 'card document-card', href: entry.url, [
      div(classes: 'document-card-cover', [
        span(classes: 'eyebrow', [.text('${data['type']}')]),
      ]),
      div(classes: 'document-card-body', [
        EntryMeta(data),
        h2([localized(data, 'title')]),
        if (data['description'] != null) p([localized(data, 'description')]),
        EntryTags(data),
      ]),
    ]);
  }
}

/// The date line of a post or document, with the event if present.
class EntryMeta extends StatelessComponent {
  const EntryMeta(this.data, {super.key});

  final Map<String, Object?> data;

  @override
  Component build(BuildContext context) {
    final parts = [data['date'], data['event']].nonNulls;
    return span(classes: 'meta', [.text(parts.join(' · '))]);
  }
}

class EntryTags extends StatelessComponent {
  const EntryTags(this.data, {super.key});

  final Map<String, Object?> data;

  @override
  Component build(BuildContext context) {
    final tags = data['tags'];
    if (tags is! List || tags.isEmpty) return const Component.empty();

    return div(classes: 'tags', [
      for (final tag in tags) span(classes: 'tag', [.text('$tag')]),
    ]);
  }
}
