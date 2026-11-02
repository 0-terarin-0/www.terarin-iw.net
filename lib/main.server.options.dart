// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/_internal/code_block_copy_button.dart'
    as _code_block_copy_button;
import 'package:jaspr_content/components/code_block.dart' as _code_block;
import 'package:jaspr_content/components/theme_toggle.dart' as _theme_toggle;
import 'package:www_terarin_iw_net/components/document_viewer.dart'
    as _document_viewer;
import 'package:www_terarin_iw_net/components/language_select.dart'
    as _language_select;
import 'package:www_terarin_iw_net/components/machine_translation_notice.dart'
    as _machine_translation_notice;
import 'package:www_terarin_iw_net/components/site_footer.dart' as _site_footer;
import 'package:www_terarin_iw_net/components/site_header.dart' as _site_header;
import 'package:www_terarin_iw_net/components/sns_card.dart' as _sns_card;
import 'package:www_terarin_iw_net/constants/page_transition.dart'
    as _page_transition;
import 'package:www_terarin_iw_net/constants/theme.dart' as _theme;
import 'package:www_terarin_iw_net/i18n/i18n.dart' as _i18n;
import 'package:www_terarin_iw_net/pages/entry_list.dart' as _entry_list;
import 'package:www_terarin_iw_net/pages/home_page.dart' as _home_page;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _code_block_copy_button.CodeBlockCopyButton:
        ClientTarget<_code_block_copy_button.CodeBlockCopyButton>(
          'jaspr_content:code_block_copy_button',
        ),
    _theme_toggle.ThemeToggle: ClientTarget<_theme_toggle.ThemeToggle>(
      'jaspr_content:theme_toggle',
    ),
    _language_select.LanguageSelect:
        ClientTarget<_language_select.LanguageSelect>('language_select'),
  },
  styles: () => [
    ..._page_transition.pageTransitionStyles,
    ..._theme.styles,
    ..._code_block.CodeBlock.styles,
    ..._theme_toggle.ThemeToggleState.styles,
    ..._document_viewer.DocumentViewer.styles,
    ..._language_select.LanguageSelectState.styles,
    ..._machine_translation_notice.MachineTranslationNotice.styles,
    ..._site_footer.SiteFooter.styles,
    ..._site_header.SiteHeader.styles,
    ..._sns_card.SnsCard.styles,
    ..._i18n.T.styles,
    ..._entry_list.EntryList.styles,
    ..._home_page.HomePage.styles,
  ],
);
