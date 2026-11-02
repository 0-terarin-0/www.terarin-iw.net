import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// Renders code fences without highlighting unless they are Dart.
///
/// The highlighter used by `CodeBlock` only ships the Dart grammar and throws for any other language, so this must be
/// listed before it.
class PlainCodeBlock extends CustomComponent {
  PlainCodeBlock() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'pre', children: [ElementNode(tag: 'code', :final children, :final attributes)])) {
      if (attributes['class'] == 'language-dart') return null;

      return pre([
        code([.text(children?.map((child) => child.innerText).join() ?? '')]),
      ]);
    }
    return null;
  }
}
