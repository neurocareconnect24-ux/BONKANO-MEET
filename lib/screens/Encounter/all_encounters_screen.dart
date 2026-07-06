import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bonkano_meet/components/app_scaffold.dart';

import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import '../booking/encounter_detail_screen.dart';
import 'all_encounters_controller.dart';
import 'components/all_encounters_card.dart';

class AllEncountersScreen extends StatelessWidget {
  AllEncountersScreen({super.key});

  final AllEncountersController allEncountersCont = Get.put(AllEncountersController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.encounters, // "Actes Médicaux"
      isLoading: allEncountersCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
            Obx(
              () => SnapHelperWidget(
                future: Future.value(allEncountersCont.combinedList),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      allEncountersCont.page(1);
                      allEncountersCont.getAllEncounters();
                    },
                  ).paddingSymmetric(horizontal: 32);
                },
                loadingWidget: allEncountersCont.isLoading.value && allEncountersCont.combinedList.isEmpty ? const LoaderWidget() : const Offstage(),
                onSuccess: (data) {
                  if (allEncountersCont.combinedList.isEmpty && !allEncountersCont.isLoading.value) {
                    return NoDataWidget(
                      title: locale.value.noEncountersFound,
                      subTitle: "Aucun acte médical trouvé dans votre historique.",
                      titleTextStyle: primaryTextStyle(),
                      imageWidget: const EmptyStateWidget(),
                      retryText: locale.value.reload,
                      onRetry: () {
                        allEncountersCont.page(1);
                        allEncountersCont.getAllEncounters();
                      },
                    ).paddingSymmetric(horizontal: 32);
                  }

                  return AnimatedListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    itemCount: allEncountersCont.combinedList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    onNextPage: () async {
                      if (!allEncountersCont.isLastPage.value) {
                        allEncountersCont.page(allEncountersCont.page.value + 1);
                        allEncountersCont.getAllEncounters();
                      }
                    },
                    onSwipeRefresh: () async {
                      allEncountersCont.page(1);
                      return await allEncountersCont.getAllEncounters(showLoader: false);
                    },
                    itemBuilder: (context, index) {
                      var item = allEncountersCont.combinedList[index];

                      return InkWell(
                        onTap: () {
                          Get.to(() => EncounterDetailScreen(), arguments: item.id);
                        },
                        child: AllEncountersCard(encounterElement: item).paddingBottom(16),
                      );
                    },
                  );
                },
              ).expand(),
            ),
          ],
        ),
      ),
    );
  }
}
