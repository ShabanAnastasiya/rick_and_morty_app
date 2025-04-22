import 'package:auto_route/auto_route.dart';
import 'package:character_list/list_navigation.gm.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:settings/settings_navigation.gm.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const <PageRouteInfo>[
        CharacterListRoute(),
        SettingsRoute(),
      ],
      builder: (BuildContext context, Widget child) {
        final TabsRouter tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: AppConstants.HOME_LABEL,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: AppConstants.SETTINGS_LABEL,
              ),
            ],
          ),
        );
      },
    );
  }
}
