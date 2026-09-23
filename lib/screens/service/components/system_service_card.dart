import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../home/model/system_service_res.dart';
import '../services_list_screen.dart';

class SystemServiceCard extends StatelessWidget {
  final SystemService systemServiceElement;

  const SystemServiceCard({super.key, required this.systemServiceElement});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        /// Store select system service in global variable
        selectedSysService(systemServiceElement);
        Get.to(() => ServiceListScreen(), arguments: systemServiceElement);
      },
      borderRadius: radius(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(8)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedImageWidget(
              url: systemServiceElement.systemServiceImage,
              fit: BoxFit.cover,
              circle: true,
              height: 60,
              width: 60,
            ),
            16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    systemServiceElement.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: boldTextStyle(),
                  ),
                  4.height,
                  Text(
                    '${locale.value.total} ${systemServiceElement.totalServices} ${locale.value.servicesAvailable}',
                    style: secondaryTextStyle(),
                  ),
                ],
              ),
            ),
            16.width,
            Icon(Icons.keyboard_arrow_right, color: textSecondaryColorGlobal),
          ],
        ),
      ),
    );
  }
}
