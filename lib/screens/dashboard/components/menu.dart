import 'package:get/get.dart';
import 'package:bonkano_meet/generated/assets.dart';

import '../../../main.dart';

enum BottomItem {
  home,
  appointment,
  encounter,
  healthSpace,
  notification,
  settings,
  profile,
}

class BottomBarItem {
  RxString title;
  final String icon;
  final String activeIcon;
  final String type;

  BottomBarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.type,
  });
}
RxList<BottomBarItem> bottomNavItems = [
  BottomBarItem(title: (locale.value.home).obs, icon: Assets.navigationIcHomeOutlined, activeIcon: Assets.navigationIcHomeFilled, type: BottomItem.home.name),
  BottomBarItem(title: (locale.value.appointment).obs, icon: Assets.navigationIcCalenderOutlined, activeIcon: Assets.navigationIcCalenderFilled, type: BottomItem.appointment.name),
  BottomBarItem(title: (locale.value.encounters).obs, icon: Assets.iconsIcEncounter, activeIcon: Assets.iconsIcEncounter, type: BottomItem.encounter.name),
  BottomBarItem(title: (locale.value.healthSpace).obs, icon: Assets.iconsIcHeart, activeIcon: Assets.iconsIcHeart, type: BottomItem.healthSpace.name),
  BottomBarItem(title: (locale.value.profile).obs, icon: Assets.navigationIcUserOutlined, activeIcon: Assets.navigationIcUserFilled, type: BottomItem.profile.name),
].obs;
