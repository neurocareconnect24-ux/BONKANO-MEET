import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';

class CommonSelectionWid extends StatelessWidget {
  final String title;
  final String selectedName;
  final void Function()? onEdit;
  final bool isAutoAssigned;

  const CommonSelectionWid({
    super.key,
    required this.title,
    required this.selectedName,
    this.onEdit,
    this.isAutoAssigned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: secondaryTextStyle(size: 12)),
                if (isAutoAssigned) ...[
                  6.width,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: boxDecorationDefault(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      borderRadius: radius(4),
                    ),
                    child: Text(
                      "Auto",
                      style: boldTextStyle(size: 10, color: context.primaryColor),
                    ),
                  ),
                ],
              ],
            ),
            6.height,
            Marquee(child: Text(selectedName, style: boldTextStyle(size: 14))),
          ],
        ).expand(),
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: const CachedImageWidget(
              url: Assets.iconsIcEditReview,
              height: 20,
              fit: BoxFit.fitHeight,
            ),
          )
        else if (isAutoAssigned)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
          ),
      ],
    );
  }
}
