import 'package:flutter/material.dart';

import '../../component/card/not_found_navigation_widget.dart';

class NavigationRoute {
  NavigationRoute._init();
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      /* case NavigationConstants.DEFAULT:
        return normalNavigate(const SplashView(), NavigationConstants.DEFAULT); */

      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundNavigationWidget(),
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget, String pageName,
      {Object? arguments}) {
    return MaterialPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(
        name: pageName,
        arguments: arguments,
      ),
    );
  }
}
