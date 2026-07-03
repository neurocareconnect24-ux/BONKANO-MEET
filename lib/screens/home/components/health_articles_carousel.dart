import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/article_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/colors.dart';
import '../article_detail_screen.dart';
import 'package:html/parser.dart' show parse;

class HealthArticlesCarousel extends StatefulWidget {
  const HealthArticlesCarousel({super.key});

  @override
  _HealthArticlesCarouselState createState() => _HealthArticlesCarouselState();
}

class _HealthArticlesCarouselState extends State<HealthArticlesCarousel> {
  bool isLoading = true;
  List<ArticleModel> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final response = await http.get(buildBaseUrl('health-articles'));
      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        if (body['status'] == true) {
          articles = (body['data'] as List)
              .map((e) => ArticleModel.fromJson(e))
              .toList();
        }
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(); // On cache pendant le chargement pour ne pas perturber l'UI
    }
    if (articles.isEmpty) {
      return const SizedBox(); // On cache s'il n'y a pas d'articles
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Prévention & Conseils Santé", style: boldTextStyle(size: 18)),
        ),
        12.height,
        CarouselSlider(
          options: CarouselOptions(
            height: 180.0,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.85,
          ),
          items: articles.map((article) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ArticleDetailScreen(article: article));
                  },
                  child: Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: radius(),
                      color: context.cardColor,
                      boxShadow: defaultBoxShadow(),
                    ),
                    child: ClipRRect(
                      borderRadius: radius(),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (article.imageUrl.isNotEmpty)
                            Image.network(
                              article.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200),
                            )
                          else
                            Container(color: appColorPrimary.withOpacity(0.1)),
                          
                          // Gradient over image
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          
                          // Text content
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: appColorPrimary,
                                    borderRadius: radius(4),
                                  ),
                                  child: Text("À la une", style: boldTextStyle(size: 10, color: Colors.white)),
                                ),
                                4.height,
                                Text(
                                  parse(article.title).body?.text ?? article.title,
                                  style: boldTextStyle(color: Colors.white, size: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        24.height,
      ],
    );
  }
}
