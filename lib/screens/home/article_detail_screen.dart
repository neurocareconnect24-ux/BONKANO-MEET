import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../models/article_model.dart';
import '../../../utils/colors.dart';
import 'package:html/parser.dart' show parse;

class ArticleDetailScreen extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    String cleanContent = parse(article.content).body?.text ?? article.content;
    
    return AppScaffold(
      appBartitleText: "Prévention Santé",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              Image.network(
                article.imageUrl,
                width: context.width(),
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: context.width(),
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              )
            else
              Container(
                width: context.width(),
                height: 200,
                color: appColorPrimary.withOpacity(0.1),
                child: const Icon(Icons.health_and_safety, size: 80, color: appColorPrimary),
              ),
            16.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parse(article.title).body?.text ?? article.title, style: boldTextStyle(size: 20)),
                  8.height,
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: textSecondaryColorGlobal),
                      4.width,
                      Text(article.date, style: secondaryTextStyle()),
                      16.width,
                      Icon(Icons.person, size: 14, color: textSecondaryColorGlobal),
                      4.width,
                      Text(article.author, style: secondaryTextStyle()),
                    ],
                  ),
                  16.height,
                  Divider(color: borderColor.withValues(alpha: 0.5)),
                  16.height,
                  // Using Text for content. In a real scenario, use flutter_html or flutter_widget_from_html_core if the content is rich HTML.
                  Text(cleanContent, style: primaryTextStyle(size: 15, height: 1.5)),
                  32.height,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
