/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'components/plain_code_block.dart';
import 'constants/theme.dart';
import 'layouts/site_layout.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  runApp(
    ContentApp(
      // The blog and document lists read the data of all pages.
      eagerlyLoadAllPages: true,
      parsers: [MarkdownParser()],
      extensions: [HeadingAnchorsExtension()],
      components: [PlainCodeBlock(), CodeBlock()],
      layouts: [const SiteLayout()],
      theme: siteTheme,
    ),
  );
}
