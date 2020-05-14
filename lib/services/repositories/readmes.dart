import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart' show md5;
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:quiver/collection.dart' show LruMap;

/// This class will handle all things readme:
/// - fetch, pre-cache, cache
/// - parse markdown
/// - generate unique id's for readmes for referencing through the app
class ReadmeRepository {
  /// Readme cache
  final _markdownCache = LruMap<String, List<md.Node>>(maximumSize: 25);

  /// Parse the markdown for a readme
  List<md.Node> _parseMarkdownIsolate(String data) {
    return md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored,
      inlineSyntaxes: [TaskListSyntax()],
      encodeHtml: false,
    ).parseLines(LineSplitter.split(data).toList(growable: false));
  }

  /// Generate a unique key for a readme
  String _generateHashKey(String data) {
    return md5.convert(utf8.encode(data)).toString();
  }

  /// Pre-cache the markdown for a readme
  Future<void> preCacheMarkdown(String markdown) async {
    final hash = _generateHashKey(markdown);
    _markdownCache[hash] = await compute(_parseMarkdownIsolate, markdown);
  }

  ///
  Future<void> preCacheReadmes(GitHub gitHub, List<Event> events) async {
    final futureFiles = <Future<GitHubFile>>[];
    for(int i = 0; i < math.min(events.length, 25); i++) {
      final event = events[i];
      final slug = RepositorySlug.full(event.repo.name);
      futureFiles.add(gitHub.repositories.getReadme(slug));
    }
    final files = await Future.wait(futureFiles);
    final futureCaches = <Future<void>>[];
    for(final file in files) {
      futureCaches.add(preCacheMarkdown(file.content));
    }
    await Future.wait(futureCaches);
    print('Finished pre-caching readmes');
  }
}

/// Model class that represents a readme in a GitHub repository
class Readme {
  Readme({
    this.key,
    this.data,
  });

  /// A unique id key for the readme to easily identify it and retrieve it from the repository
  final String key;

  /// The readme data to be parsed
  final String data;
}
