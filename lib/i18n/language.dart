/// One language of the site. Each language has a file of its own under `languages/`.
class Language {
  const Language({
    required this.label,
    required this.isRtl,
    required this.isMachineTranslated,
    required this.messages,
  });

  /// The name of this language, written in this language.
  final String label;

  /// Whether this language is written from right to left. The layout mirrors itself when it is.
  final bool isRtl;

  /// Whether a notice tells visitors that this language was machine-translated.
  ///
  /// Set this to false once a speaker of the language has reviewed it.
  final bool isMachineTranslated;

  final Messages messages;
}

/// All text of the site that does not come from `content/`.
///
/// Every field is required, so a missing translation is a compile error.
class Messages {
  const Messages({
    required this.navHome,
    required this.navBlog,
    required this.navDocuments,
    required this.status,
    required this.introduction,
    required this.readBlog,
    required this.seeDocuments,
    required this.findMeOn,
    required this.latest,
    required this.nothingYet,
    required this.openInNewTab,
    required this.download,
    required this.machineTranslationBadge,
    required this.machineTranslationNotice,
  });

  final String navHome;
  final String navBlog;
  final String navDocuments;
  final String status;
  final String introduction;
  final String readBlog;
  final String seeDocuments;
  final String findMeOn;
  final String latest;
  final String nothingYet;
  final String openInNewTab;
  final String download;

  /// The label of the badge shown on every page while [Language.isMachineTranslated] is true.
  final String machineTranslationBadge;

  /// The sentence next to the badge.
  final String machineTranslationNotice;
}
