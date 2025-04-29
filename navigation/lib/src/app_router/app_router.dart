import 'package:auto_route/auto_route.dart';
import 'package:character_details/detail_navigation.dart';
import 'package:character_details/detail_navigation.gm.dart';
import 'package:character_favorites/favorites_navigation.dart';
import 'package:character_favorites/favorites_navigation.gm.dart';
import 'package:character_list/list_navigation.dart';
import 'package:character_list/list_navigation.gm.dart';
import 'package:home/home_navigation.dart';
import 'package:home/home_navigation.gm.dart';
import 'package:settings/settings_navigation.dart';
import 'package:settings/settings_navigation.gm.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen|Form,Route',
  modules: <Type>[
    HomeModule,
    ListModule,
    DetailModule,
    SettingsModule,
    FavoritesModule,
  ],
)

class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(
      page: HomeRoute.page,
      initial: true,
      children: <AutoRoute>[
        AutoRoute(page: CharacterListRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
    AutoRoute(page: CharacterDetailRoute.page),
    AutoRoute(page: FavoritesRoute.page),
  ];
}
