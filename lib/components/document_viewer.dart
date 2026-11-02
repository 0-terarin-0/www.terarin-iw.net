import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../i18n/i18n.dart';

/// Embeds a document according to the `type` in its frontmatter.
///
/// Paths in `src` and `download` that start with `/` are served from R2 through [filesUrl].
///
/// - `pdf`: a PDF.
/// - `pptx`: a PowerPoint file, shown through the Office Online viewer. The file must be publicly reachable, so it
///   only renders once deployed.
/// - `flutter_deck`: a flutter_deck web build.
/// - `embed`: the embed URL of an external service, e.g. Google Slides or Speaker Deck.
class DocumentViewer extends StatelessComponent {
  const DocumentViewer({
    required this.title,
    required this.type,
    required this.src,
    required this.filesUrl,
    this.download,
    super.key,
  });

  final String title;
  final String type;
  final String src;
  final String filesUrl;
  final String? download;

  String get _frameUrl => switch (type) {
    'pdf' || 'flutter_deck' || 'embed' => _url,
    'pptx' => 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(_url)}',
    _ => throw ArgumentError('Unknown document type "$type" for "$title".'),
  };

  String get _url => _resolve(src);

  String _resolve(String path) => path.startsWith('/') ? '$filesUrl$path' : path;

  String? get _downloadUrl => download != null ? _resolve(download!) : (type == 'pdf' || type == 'pptx' ? _url : null);

  @override
  Component build(BuildContext context) {
    return div(classes: 'document-viewer', [
      div(classes: 'card document-frame', [
        iframe(src: _frameUrl, attributes: {'title': title, 'allowfullscreen': 'true'}, []),
      ]),
      div(classes: 'document-actions', [
        a(
          classes: 'button button-ghost',
          href: _url,
          target: .blank,
          attributes: {'rel': 'noopener'},
          [T((messages) => messages.openInNewTab)],
        ),
        if (_downloadUrl case final url?)
          a(
            classes: 'button button-ghost',
            href: url,
            attributes: {'download': ''},
            [T((messages) => messages.download)],
          ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.document-frame', [
      css('&').styles(
        width: 100.percent,
        aspectRatio: AspectRatio(16, 9),
        overflow: .hidden,
      ),
      css('iframe').styles(width: 100.percent, height: 100.percent, border: .none),
    ]),
    css('.document-actions').styles(
      display: .flex,
      margin: .only(top: 1.rem, bottom: 2.rem),
      flexWrap: .wrap,
      gap: .all(0.5.rem),
    ),
  ];
}
