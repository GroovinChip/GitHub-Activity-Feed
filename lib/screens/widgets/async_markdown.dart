import 'dart:convert';
import 'package:crypto/crypto.dart' show md5;
import 'package:quiver/collection.dart' show LruMap;
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github_activity_feed/utils/markdown_io.dart';
import 'package:markdown/markdown.dart' as md;

final _markdownCache = LruMap<String, List<md.Node>>(maximumSize: 25);

List<md.Node> _parseMarkdownIsolate(String data) {
  return md.Document(
    extensionSet: md.ExtensionSet.gitHubFlavored,
    inlineSyntaxes: [TaskListSyntax()],
    encodeHtml: false,
  ).parseLines(LineSplitter.split(data).toList(growable: false));
}

String _generateHashKey(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

Future<void> preCacheMarkdown(String markdown) async {
  final hash = _generateHashKey(markdown);
  _markdownCache[hash] = await compute(_parseMarkdownIsolate, markdown);
}

class AsyncMarkdown extends StatefulWidget {
  /// Creates a widget that parses and displays Markdown.
  ///
  /// The [data] argument must not be null.
  const AsyncMarkdown({
    Key key,
    @required this.data,
    this.selectable = false,
    this.styleSheet,
    this.styleSheetTheme = MarkdownStyleSheetBaseTheme.material,
    this.syntaxHighlighter,
    this.onTapLink,
    this.imageDirectory,
    this.extensionSet,
    this.imageBuilder,
    this.checkboxBuilder,
    this.fitContent = false,
    this.padding = const EdgeInsets.all(16.0),
    this.controller,
    this.physics,
    this.shrinkWrap = false,
  })  : assert(data != null),
        assert(selectable != null),
        super(key: key);

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;

  /// An object that can be used to control the position to which this scroll view is scrolled.
  ///
  /// See also: [ScrollView.controller]
  final ScrollController controller;

  /// How the scroll view should respond to user input.
  ///
  /// See also: [ScrollView.physics]
  final ScrollPhysics physics;

  /// Whether the extent of the scroll view in the scroll direction should be
  /// determined by the contents being viewed.
  ///
  /// See also: [ScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// The Markdown to display.
  final String data;

  /// If true, the text is selectable.
  ///
  /// Defaults to false.
  final bool selectable;

  /// The styles to use when displaying the Markdown.
  ///
  /// If null, the styles are inferred from the current [Theme].
  final MarkdownStyleSheet styleSheet;

  /// Setting to specify base theme for MarkdownStyleSheet
  ///
  /// Default to [MarkdownStyleSheetBaseTheme.material]
  final MarkdownStyleSheetBaseTheme styleSheetTheme;

  /// The syntax highlighter used to color text in `pre` elements.
  ///
  /// If null, the [MarkdownStyleSheet.code] style is used for `pre` elements.
  final SyntaxHighlighter syntaxHighlighter;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback onTapLink;

  /// The base directory holding images referenced by Img tags with local or network file paths.
  final String imageDirectory;

  /// Markdown syntax extension set
  ///
  /// Defaults to [md.ExtensionSet.gitHubFlavored]
  final md.ExtensionSet extensionSet;

  /// Call when build an image widget.
  final MarkdownImageBuilder imageBuilder;

  /// Call when build a checkbox widget.
  final MarkdownCheckboxBuilder checkboxBuilder;

  /// Whether to allow the widget to fit the child content.
  final bool fitContent;

  @override
  _AsyncMarkdownWidgetState createState() => _AsyncMarkdownWidgetState();
}

class _AsyncMarkdownWidgetState extends State<AsyncMarkdown> implements MarkdownBuilderDelegate {
  List<Widget> _children;
  final List<GestureRecognizer> _recognizers = <GestureRecognizer>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parseMarkdown().catchError((error, stackTrace) {
      //
    });
  }

  @override
  void didUpdateWidget(AsyncMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data || widget.styleSheet != oldWidget.styleSheet) {
      _parseMarkdown().catchError((error, stackTrace) {
        //
      });
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  Future<void> _parseMarkdown() async {
    final MarkdownStyleSheet fallbackStyleSheet = kFallbackStyle(context, widget.styleSheetTheme);
    final MarkdownStyleSheet styleSheet = fallbackStyleSheet.merge(widget.styleSheet);

    _disposeRecognizers();

    List<md.Node> nodes;

    final hash = _generateHashKey(widget.data);
    nodes = _markdownCache[hash];
    if (nodes == null) {
      await Future.delayed(Duration(milliseconds: 250));
      nodes = await compute(_parseMarkdownIsolate, widget.data);
      _markdownCache[hash] = nodes;
    }

    final MarkdownBuilder builder = MarkdownBuilder(
      delegate: this,
      selectable: widget.selectable,
      styleSheet: styleSheet,
      imageDirectory: widget.imageDirectory,
      imageBuilder: widget.imageBuilder,
      checkboxBuilder: widget.checkboxBuilder,
      fitContent: widget.fitContent,
    );

    setState(() => _children = builder.build(nodes));
  }

  void _disposeRecognizers() {
    if (_recognizers.isEmpty) return;
    final List<GestureRecognizer> localRecognizers = List<GestureRecognizer>.from(_recognizers);
    _recognizers.clear();
    for (GestureRecognizer recognizer in localRecognizers) recognizer.dispose();
  }

  @override
  GestureRecognizer createLink(String href) {
    final TapGestureRecognizer recognizer = TapGestureRecognizer()
      ..onTap = () {
        if (widget.onTapLink != null) widget.onTapLink(href);
      };
    _recognizers.add(recognizer);
    return recognizer;
  }

  @override
  TextSpan formatText(MarkdownStyleSheet styleSheet, String code) {
    code = code.replaceAll(RegExp(r'\n$'), '');
    if (widget.syntaxHighlighter != null) {
      return widget.syntaxHighlighter.format(code);
    }
    return TextSpan(style: styleSheet.code, text: code);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: widget.padding,
      controller: widget.controller,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      itemCount: _children?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return _children[index];
      },
    );
  }
}
