import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../configs.dart';
import '../../../utils/publisher_info.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _infoRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: secondaryTextStyle(size: 13))),
          Expanded(child: Text(value, softWrap: true, style: primaryTextStyle(size: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.aboutApp,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(PublisherInfo.publisherTitle, style: boldTextStyle(size: 16)),
                  12.height,
                  _infoRow(PublisherInfo.publisherTitle, PublisherInfo.companyName),
                  _infoRow(PublisherInfo.legalFormLabel, PublisherInfo.legalForm),
                  _infoRow('RCCM', PublisherInfo.rccm),
                  _infoRow('IFU', PublisherInfo.ifu),
                  _infoRow(PublisherInfo.addressLabel, PublisherInfo.address),
                  _infoRow(PublisherInfo.emailLabel, PublisherInfo.email),
                  8.height,
                  Text(PublisherInfo.publishedBy, softWrap: true, style: secondaryTextStyle(size: 12)),
                ],
              ),
            ),
            SettingItemWidget(
              title: locale.value.termsConditions,
              onTap: () => commonLaunchUrl(TERMS_CONDITION_URL, launchMode: LaunchMode.externalApplication),
              titleTextStyle: primaryTextStyle(),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            ),
            commonDivider,
            SettingItemWidget(
              title: locale.value.privacyPolicy,
              onTap: () => commonLaunchUrl(PRIVACY_POLICY_URL, launchMode: LaunchMode.externalApplication),
              titleTextStyle: primaryTextStyle(),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            ),
            commonDivider,
            ListView.separated(
              itemCount: aboutPages.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                if (aboutPages[index].name.isEmpty || aboutPages[index].url.isEmpty) {
                  return const SizedBox();
                } else {
                  return SettingItemWidget(
                    title: aboutPages[index].name,
                    onTap: () {
                      commonLaunchUrl(aboutPages[index].url.trim(), launchMode: LaunchMode.externalApplication);
                    },
                    titleTextStyle: primaryTextStyle(),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  );
                }
              },
              separatorBuilder: (context, index) => commonDivider,
            ),
          ],
        ),
      ),
    );
  }
}
