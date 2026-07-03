import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/colors.dart';

class HealthSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final int itemCount;
  final VoidCallback onTap;

  const HealthSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.itemCount,
    required this.onTap,
    this.iconColor = appColorPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: radius(16),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius(16),
        child: InkWell(
          borderRadius: radius(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: boxDecorationDefault(
                    shape: BoxShape.circle,
                    color: iconColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                16.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: boldTextStyle(size: 14)),
                      4.height,
                      Text(subtitle, style: secondaryTextStyle(size: 12)),
                    ],
                  ),
                ),
                if (itemCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: boxDecorationDefault(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: radius(12),
                    ),
                    child: Text(
                      '$itemCount',
                      style: boldTextStyle(size: 12, color: iconColor),
                    ),
                  ),
                8.width,
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: secondaryTextColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
