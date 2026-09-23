import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../service/model/service_list_model.dart';

class DoctorServiceCard extends StatelessWidget {
  final ServiceElement serviceElement;

  const DoctorServiceCard({super.key, required this.serviceElement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceElement.serviceName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: boldTextStyle(size: 16),
          ),
          16.height,
          if (serviceElement.clinicName.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.local_hospital_outlined, size: 18, color: textSecondaryColorGlobal).paddingTop(2),
                8.width,
                Text(
                  serviceElement.clinicName.map((e) => e.validate()).toList().join(', '),
                  style: secondaryTextStyle(size: 14),
                ).flexible(),
              ],
            ),
        ],
      ),
    );
  }
}
