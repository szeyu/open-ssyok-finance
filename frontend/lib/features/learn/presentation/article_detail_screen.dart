import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ssyok_finance/features/learn/data/articles_data.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final article = kArticles.firstWhere(
      (a) => a.id == articleId,
      orElse: () => kArticles.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(article.emoji),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                article.readTime,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Markdown(
        data: article.content,
        padding: const EdgeInsets.all(16),
        styleSheet: MarkdownStyleSheet(
          h1: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          h2: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          h3: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          p: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.primary,
                width: 4,
              ),
            ),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          ),
          tableHead: theme.textTheme.labelMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          tableBody: theme.textTheme.bodySmall,
          tableBorder: TableBorder.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          code: theme.textTheme.bodySmall?.copyWith(
            fontFamily: 'monospace',
            backgroundColor:
                theme.colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
    );
  }
}
